{
  lib,
  writeShellApplication,
  jq,
  libnotify,
  niri,
  procps,
  zellij,
}:
let
  jqE = lib.getExe jq;
  niriE = lib.getExe niri;
  ps = lib.getExe' procps "ps";
  zellijE = lib.getExe zellij;
  notify-send = lib.getExe' libnotify "notify-send";
in
writeShellApplication {
  name = "codex-chirp";

  text = ''
    deliver() {
      local title=$1 message=$2 window_id=$3 pane_id=$4 action

      action=$(timeout --kill-after=1s 30s ${notify-send} \
        --app-name="Codex" \
        --action="default=Open Codex" \
        --wait \
        "$title" \
        "''${message:0:300}" || true)

      if [[ "$action" == "default" && -n "$window_id" ]]; then
        ${niriE} msg action focus-window --id "$window_id" >/dev/null 2>&1
      fi

      if [[ "$action" == "default" && -n "$pane_id" ]]; then
        ${zellijE} action focus-pane-id "$pane_id" >/dev/null 2>&1
      fi
    }

    if [[ "''${1:-}" == "--deliver" ]]; then
      deliver "''${2:-Codex}" "''${3:-Codex needs attention}" "''${4:-}" "''${5:-}"
      exit
    fi

    if (( $# > 0 )); then
      payload=$1
    else
      payload=$(</dev/stdin)
    fi
    [[ -n "$payload" ]] || payload='{}'

    cwd=$(${jqE} -r '.cwd // ""' <<< "$payload")
    project="''${cwd##*/}"
    project="''${project:-Codex}"
    thread=$(${jqE} -r '(."thread-id" // .session_id // "")[0:6]' <<< "$payload")
    hook_event=$(${jqE} -r '.hook_event_name // ""' <<< "$payload")
    event=$(${jqE} -r '.hook_event_name // .type // ""' <<< "$payload")

    if [[ "$event" == "PermissionRequest" ]]; then
      message=$(${jqE} -r \
        '.tool_input.description // .tool_input.command // ("Approval requested for " + (.tool_name // "a tool"))' \
        <<< "$payload")
      title="Codex needs approval — $project"
    else
      message=$(${jqE} -r \
        '.last_assistant_message // ."last-assistant-message" // "Task completed"' \
        <<< "$payload")
      title="Codex finished — $project"
    fi

    [[ -z "$thread" ]] || title="$title [$thread]"

    # Find the niri window belonging to the terminal that launched Codex. Niri
    # exposes the PID of each window, so walking our ancestors identifies the
    # exact terminal when several Codex sessions use the same project.
    windows=$(${niriE} msg --json windows 2>/dev/null || printf '[]')

    window_for_ancestor() {
      local pid=$1 window_id

      while [[ "$pid" =~ ^[0-9]+$ ]] && (( pid > 1 )); do
        window_id=$(${jqE} -r --argjson pid "$pid" \
          '[.[] | select(.pid == $pid)][0].id // ""' <<< "$windows")

        if [[ -n "$window_id" ]]; then
          printf '%s\n' "$window_id"
          return
        fi

        pid=$(while read -r key value _; do
          [[ "$key" == "PPid:" ]] && printf '%s\n' "$value"
        done < "/proc/$pid/status" 2>/dev/null || true)
      done
    }

    window_id=$(window_for_ancestor "$PPID")

    # Zellij panes are children of a detached server rather than the terminal.
    # Find the client attached to this session, then follow its ancestry to the
    # Alacritty window exposed by niri.
    if [[ -z "$window_id" && -n "''${ZELLIJ_SESSION_NAME:-}" ]]; then
      while read -r client_pid command; do
        case "$command" in
          *zellij*" -s $ZELLIJ_SESSION_NAME" | *zellij*" -s $ZELLIJ_SESSION_NAME "* | \
            *zellij*" attach $ZELLIJ_SESSION_NAME" | *zellij*" attach $ZELLIJ_SESSION_NAME "*)
            window_id=$(window_for_ancestor "$client_pid")
            [[ -n "$window_id" ]] && break
            ;;
        esac
      done < <(timeout 1s ${ps} -eo pid=,args= 2>/dev/null || true)
    fi

    window_focused=false
    if [[ -n "$window_id" ]]; then
      window_focused=$(${jqE} -r --argjson id "$window_id" \
        '[.[] | select(.id == $id)][0].is_focused // false' <<< "$windows")
    fi

    pane_id="''${ZELLIJ_PANE_ID:-}"
    pane_focused=true
    if [[ -n "$pane_id" ]]; then
      panes=$(${zellijE} action list-panes --json --all 2>/dev/null || printf '[]')
      tabs=$(${zellijE} action list-tabs --json 2>/dev/null || printf '[]')
      pane_tab=$(${jqE} -r --argjson id "$pane_id" \
        '[.[] | select(.is_plugin == false and .id == $id and .is_focused and (.is_suppressed | not))][0].tab_id // ""' \
        <<< "$panes")
      pane_is_floating=$(${jqE} -r --argjson id "$pane_id" \
        '[.[] | select(.is_plugin == false and .id == $id)][0].is_floating // false' \
        <<< "$panes")
      active_tab=$(${jqE} -r '[.[] | select(.active)][0].tab_id // ""' <<< "$tabs")
      floating_panes_visible=$(${jqE} -r \
        '[.[] | select(.active)][0].are_floating_panes_visible // false' <<< "$tabs")

      # Zellij tracks focus separately for tiled and floating panes. A tiled
      # pane can therefore report is_focused=true while the floating layer is
      # active (and vice versa), even though it cannot receive input.
      [[ -n "$pane_tab" && "$pane_tab" == "$active_tab" && \
        "$pane_is_floating" == "$floating_panes_visible" ]] || pane_focused=false
    fi

    if [[ "$window_focused" == true && "$pane_focused" == true ]]; then
      exit
    fi

    if [[ -n "$hook_event" ]]; then
      nohup "$0" --deliver "$title" "$message" "$window_id" "$pane_id" \
        </dev/null >/dev/null 2>&1 &
    else
      deliver "$title" "$message" "$window_id" "$pane_id"
    fi
  '';

  meta = {
    description = "Clickable Codex attention notifications for niri";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "codex-chirp";
  };
}

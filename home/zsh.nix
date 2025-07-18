{ pkgs, lib, ... }:
{
  persist.caches.contents = [
    ".zcompdump"
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    completionInit = ''
      autoload -U compinit && compinit -d /persistent/caches/home/eschb/.zcompdump
    '';

    initContent = ''
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word

      autoload -U up-line-or-beginning-search
      zle -N up-line-or-beginning-search
      bindkey "^[OA" up-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search

      autoload -U down-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[OB" down-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
    '';

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /home/eschb/nixcfg";
      ls = "ls --color=auto";
      reload = "source ~/.zshrc; rehash";
      m = "${lib.getExe pkgs.erdtree} --level=1 --sort=size -H --hidden --no-ignore";
      cat = "${lib.getExe pkgs.bat} --paging=never";
      df = "df -h";
      du = "du -h";
      free = "free -h";
      diff = "diff --color=auto";
      yoink = "${lib.getExe pkgs.git} clone --depth 1";
    };

    history = {
      append = true;
      ignorePatterns = [
        "poweroff"
        "reboot"
      ];
      path = "/persistent/data/home/eschb/.zsh_history";
      size = 100000;
    };
  };
}

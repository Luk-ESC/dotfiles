let
  lyt = "base07";
  mid = "base04";
  drk = "base01";
  blk = "base00";
  s_icon = "(bg:${lyt} fg:${blk})";
  s_1 = "(fg:${blk} bg:${mid})";
  s_2 = "(fg:${mid} bg:${drk})";
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      directory = {
        format = "[ $path ]${s_1}";
        truncate_to_repo = false;
        truncation_length = 0;
      };
      sudo = {
        disabled = false;
        format = "[ 󱑷 ]${s_1}";
      };

      git_branch.format = "[  $branch ]${s_2}";
      git_status.format = "[($all_status$ahead_behind )]${s_2}";
      rust.format = "[  ($version) ]${s_2}";

      format = "[╭─](${lyt})[  ]${s_icon}[](fg:${lyt} bg:${mid})$directory$sudo[]${s_2}$git_branch$git_status$rust[](fg:${drk} bg:${blk})$time[ ](${blk})\n[╰─ ](${lyt})";

      time = {
        disabled = false;
        format = "[ $time ](fg:${mid} bg:${blk})";
        time_format = "%R";
      };
    };
  };
}

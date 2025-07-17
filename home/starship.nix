{ ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = builtins.fromTOML ''
      format = """
      [╭─\ue0b6](#a3aed2)\
      [ \uf303 ](bg:#a3aed2 fg:#090c0c)\
      [](bg:#769ff0 fg:#a3aed2)\
      $directory\
      $sudo\
      [](fg:#769ff0 bg:#394260)\
      $git_branch\
      $git_status\
      [](fg:#394260 bg:#212736)\
      $rust\
      [](fg:#212736 bg:#1d2230)\
      $time\
      [ ](fg:#1d2230)\
      \n╰─ """

      [character] # The name of the module we are configuring is 'character'
      success_symbol = '[╰─](bold green)'

      [directory]
      style = "fg:#e3e5e5 bg:#769ff0"
      format = "[ $path ]($style)"
      truncation_length = 0
      truncate_to_repo = false


      [git_branch]
      symbol = ""
      style = "bg:#394260"
      format = '[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)'

      [git_status]
      style = "bg:#394260"
      format = '[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)'

      [rust]
      symbol = ""
      style = "bg:#212736"
      format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

      [time]
      disabled = false
      time_format = "%R" # Hour:Minute Format
      style = "bg:#1d2230"
      format = '[[ $time ](fg:#a0a9cb bg:#1d2230)]($style)'


      [sudo]
      disabled = false
      style = "fg:#e3e5e5 bg:#769ff0"
      format = '[ $symbol]($style)'
      symbol = '󱑷 '
    '';
  };
}

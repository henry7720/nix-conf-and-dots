{ config, pkgs, ... }:

{
  imports = [
    ./user-modules/packages.nix
    ./user-modules/theming.nix
    ./user-modules/desktop.nix
    ./user-modules/programs.nix
  ];

  home = {
    username = "henry";
    homeDirectory = "/home/henry";
    stateVersion = "26.05";

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
    ];

    sessionVariables = {
      EDITOR = "nano";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      PODMAN_COMPOSE_WARNING_LOGS = "false";
    };
  };

  programs.home-manager.enable = true;
}

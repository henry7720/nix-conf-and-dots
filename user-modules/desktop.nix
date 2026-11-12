{ config, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
  fullDotfilesDir = "${homeDir}/nixos/dotfiles";
  symlink = config.lib.file.mkOutOfStoreSymlink;
  scriptsDir = "${homeDir}/Documents/Scripts";
in
{
  services = {
    # prompt for passwords graphically
    hyprpolkitagent.enable = true;

    # (optional) for player control via bluetooth stuff
    # playerctld.enable = true;

    mako = {
      enable = true;
      settings = {
        background-color = "#11111bef";
        border-color = "#a32cc4ff";
        default-timeout = 10000;
      };
    };
  };

  programs = {
    waybar = {
      enable = true;
      #systemd.enable = true;
    };

    fuzzel = {
      enable = true;
      settings = {
        main = {
          icon-theme = "oxygen";
          width = 40;
          # tabs = 8;
          horizontal-pad = 8;
          vertical-pad = 2;
        };

        colors = {
          background = "11111bdf";
          text = "fcfcfcff";
          prompt = "fcfcfcff";
          input = "fcfcfcff";
          selection = "3daee9ff";
          selection-text = "fcfcfcff";
          border = "a32cc4ff";
        };

        border = {
          width = 2;
          radius = 0;
        };
      };
    };
  };

  # wayland.windowManager.niri.enable = true;
#   xdg.portal = {
#     enable = true;
#     extraPortals = with pkgs; [
#       xdg-desktop-portal-gtk
#       xdg-desktop-portal-gnome
#     ];
#     config = {
#       niri = {
#         default = [ "gtk" ];
#         "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
#         "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
#         "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
#         "org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
#       };
#     };
#   };

  xfconf.settings = {
    thunar = {
      "last-view" = "ThunarDetailsView";
      "last-show-hidden" = true;
      "misc-single-click" = false;
      "misc-use-csd" = false;
      "misc-text-beside-icons" = false;
      "misc-symbolic-icons-in-sidepane" = false;
      "misc-date-style" = "THUNAR_DATE_STYLE_LONG";
      "misc-full-path-in-tab-title" = false;
      "misc-confirm-move-to-trash" = true;
      "misc-window-title-style" = "THUNAR_WINDOW_TITLE_STYLE_FULL_PATH_WITH_THUNAR_SUFFIX";
      "hidden-bookmarks" = [ "network:///" ];
    };
    thunar-volman = {
      "automount-drives/enabled" = true;
    };
  };

  xdg.mimeApps = let
    browser = "firefox.desktop";
    editor = "org.kde.kwrite.desktop";
  in {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/chrome" = browser;
      "text/html" = browser;
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/x-extension-shtml" = browser;
      "application/xhtml+xml" = browser;
      "application/x-extension-xhtml" = browser;
      "application/x-extension-xht" = browser;
      "application/pdf" = "org.kde.okular.desktop";
      "inode/directory" = "thunar.desktop";
      "x-scheme-handler/terminal" = "kitty.desktop";

      "text/plain" = editor;
      "inode/x-empty" = editor;
      "text/css" = editor;
      "text/x-nix" = editor;
      "application/xml" = editor;
      "text/markdown" = editor;
      "video/mp4" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "audio/mp4" = "audacious.desktop";
    };
  };

  home.file = {
    #".bashrc".source = ../dotfiles/bash/.bashrc;
    #".bash_profile".source = ../dotfiles/bash/.bash_profile;
    #".gitconfig".source = ../dotfiles/git/.gitconfig;
    #".local/bin/update-all".source = symlink "${scriptsDir}/update-system-all.sh";
    #".local/bin/proc_zh".source = symlink "${scriptsDir}/process_zhongwen_export.py";
    #".local/bin/restart_shell".source = symlink "${scriptsDir}/restart-plasmashell.sh";
    #".local/bin/backup-remote".source = symlink "${scriptsDir}/backup-remote.sh";
    #".local/bin/build-os".source = symlink "${scriptsDir}/rebuild-system-bootc.sh";
    #".local/bin/check-reg".source = symlink "${scriptsDir}/check-bootc-base-image-update.sh";

    "Documents/Personal/FAMILY MEDIA ARCHIVE".source = symlink "/run/media/henry/Diff_Backups/FAMILY MEDIA ARCHIVE";
  };

  xdg.configFile = {
    #"mako/config".source = ../dotfiles/mako/config;
    "waybar".source = symlink "${fullDotfilesDir}/waybar";
    "Thunar/uca.xml".source = ../dotfiles/Thunar/uca.xml;
    "xdg-terminals.list".text = ''kitty.desktop'';
    "niri".source = symlink "${fullDotfilesDir}/niri";
    "rofi".source = symlink "${fullDotfilesDir}/rofi";
    "arch-dev".source = symlink "${fullDotfilesDir}/arch-dev";
    "fcitx5".source = symlink "${fullDotfilesDir}/fcitx5";
    "pika-backup".source = symlink "${fullDotfilesDir}/pika-backup";
  };
}

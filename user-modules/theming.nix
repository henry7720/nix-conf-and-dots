{ config, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

#   fonts.fontconfig = {
#     enable = true;
#     defaultFonts = {
#       sansSerif = [ "Noto Sans" "Noto Sans CJK TC" "Noto Sans CJK SC" "Jigmo" ];
#       serif = [ "Noto Serif" "Noto Serif CJK TC" "Noto Serif CJK SC" "Jigmo" ];
#       monospace = [ "JetBrainsMonoNL Nerd Font" "Noto Sans Mono CJK TC" "Jigmo" ];
#     };
#   };

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "oxygen";
      package = pkgs.kdePackages.oxygen-icons;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    gtk3 = {
      bookmarks = [
        "file:///home/henry/Documents"
        "file:///home/henry/Downloads"
        "file:///home/henry/Projects"
        "file:///home/henry/Pictures/Screenshots"
        "file:///home/henry/nixos"
        "file:///home/henry/Videos"
        "file:///home/henry/Music"
        "file:///home/henry/Documents/tOSU"
      ];
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    document-font-name = "Noto Sans 10";
    monospace-font-name = "JetBrainsMonoNL Nerd Font 12";
    font-antialiasing = "grayscale";
    font-hinting = "slight";
    color-scheme = "prefer-dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt6ctSettings = {
      Appearance = {
        #color_scheme_path = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
        color_scheme_path = "${homeDir}/.config/qt6ct/style-colors.conf";
        custom_palette = true;
        icon_theme = "oxygen";
        standard_dialogs = "default";
        style = "Breeze";
      };
      Fonts = {
        fixed = "\"JetBrainsMonoNL Nerd Font,10\"";
        general = "\"Noto Sans,10\"";
      };
      Troubleshooting = {
        force_raster_widgets = 1;
      };
    };
    qt5ctSettings = config.qt.qt6ctSettings;
  };

  xdg.configFile = {
    "kdeglobals" = {
      force = true;
      source = pkgs.concatText "kdeglobals" [
        "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"
        (pkgs.writeText "kdeglobals-extra" ''

          [Icons]
          Theme=oxygen

          [KDE]
          LookAndFeelPackage=org.kde.breezedark.desktop
          widgetStyle=Breeze

          [UiSettings]
          ColorScheme=BreezeDark
        '')
      ];
    };

    "qt6ct/style-colors.conf".source = ../dotfiles/qtct/style-colors.conf;
  };
}

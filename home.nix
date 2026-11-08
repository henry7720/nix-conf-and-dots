{ config, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
  # Points cleanly to ~/.config/home-manager/dotfiles
  fullDotfilesDir = "${homeDir}/nixos/dotfiles";
  symlink = config.lib.file.mkOutOfStoreSymlink;
  scriptsDir = "${config.home.homeDirectory}/Documents/Scripts";
in
{
  services.hyprpolkitagent.enable = true;
  home = {

    # Home Manager needs a bit of information about you and the paths it should
  # manage.
    username = "henry";
    homeDirectory = "/home/henry";

      # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
# Please read the comment before changing.
  # for my system
    stateVersion = "26.05";

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
    ];

        # The home.packages option allows you to install Nix packages into your
  # environment.
      packages = with pkgs; [
        ungoogled-chromium
	brightnessctl
        playerctl
        swaylock
        xarchiver
        bluetui
        wiremix
        swaybg
        wl-clipboard
	xwayland-satellite
        kdePackages.oxygen-icons
        kdePackages.breeze-gtk
        kdePackages.breeze
        kdePackages.isoimagewriter
        kdePackages.gwenview
        kdePackages.okular
        kdePackages.kclock
        kdePackages.kcharselect
        bazaar
        makemkv
        qalculate-qt
        pika-backup
        xournalpp
        freefilesync
        filezilla
        libreoffice-qt
        krita
        remmina
        kdePackages.kdenlive
        kdePackages.kate
        qbittorrent
        mkvtoolnix
        vlc
        audacious
        signal-desktop
        praat
        vscodium-fhs
        distrobox
        micro
        neovim

        # Compilers & Toolchains
        #gcc
        #gnumake           # make
        #clang
        #llvm
        #gdb
        #valgrind
        #rustc
        #cargo             # rust ecosystem

        # Runtimes & Languages
        #python3
        #uv
        #nodejs            # includes npm in nixpkgs
        #jdk               # jdk-openjdk

        # Media & Utilities
        ffmpeg-full
        # # Adds the 'hello' command to your environment. It prints a friendly
        # # "Hello, world!" when run.
        # pkgs.hello

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
      ];
    
     pointerCursor = {
       enable = true;
       package = pkgs.adwaita-icon-theme;
       name = "Adwaita";
       size = 24;
     };
        # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
      #".bashrc".source = dotfiles/bash/.bashrc;
      #".bash_profile".source = dotfiles/bash/.bash_profile;
      #".gitconfig".source = dotfiles/git/.gitconfig;
      #".local/bin/update-all".source = symlink "${scriptsDir}/update-system-all.sh";
      #".local/bin/proc_zh".source = symlink "${scriptsDir}/process_zhongwen_export.py";
      #".local/bin/restart_shell".source = symlink "${scriptsDir}/restart-plasmashell.sh";
      #".local/bin/backup-remote".source = symlink "${scriptsDir}/backup-remote.sh";
      #".local/bin/build-os".source = symlink "${scriptsDir}/rebuild-system-bootc.sh";
      #".local/bin/check-reg".source = symlink "${scriptsDir}/check-bootc-base-image-update.sh";

      "Documents/Personal/FAMILY MEDIA ARCHIVE".source = symlink "/run/media/henry/Diff_Backups/FAMILY MEDIA ARCHIVE";
    };

    sessionVariables = {
      EDITOR = "nano";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      PODMAN_COMPOSE_WARNING_LOGS = "false";

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/henry/etc/profile.d/hm-session-vars.sh
  #
    # EDITOR = "emacs";

    };

  };
  
  # wayland.windowManager.niri.enable = true;
#  xdg.portal = {
#       enable = true;
#       extraPortals = with pkgs; [
#     xdg-desktop-portal-gtk
#     xdg-desktop-portal-gnome
#   ];
#      config = {
#        niri = {
#          default = [ "gtk" ];
# 	 "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
#          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
#          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
#         "org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
#        };
#      };
#    };
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
    };
    iconTheme = {
      name = "oxygen";
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    gtk3 = {
      bookmarks = [
        "file:///home/henry/Documents"
        "file:///home/henry/Documents/tOSU/CDME"
        "file:///home/henry/Documents/tOSU"
        "file:///home/henry/Pictures/Screenshots"
        "file:///home/henry/Downloads"
      ];
    };
  };

  # Only need the remaining non-GTK keys in dconf now:
  dconf.settings."org/gnome/desktop/interface" = {
    document-font-name = "Noto Sans 10";
    monospace-font-name = "JetBrainsMonoNL Nerd Font 12";
    font-antialiasing = "grayscale";
    font-hinting = "slight";
    color-scheme = "prefer-dark";
  };

  xdg.configFile = {
    #"mako/config".source = dotfiles/mako/config;
    "waybar/config.jsonc".source = dotfiles/waybar/config.jsonc;
    "waybar/style.css".source = dotfiles/waybar/style.css;

    #"xfce4/xfconf/xfce-perchannel-xml/thunar.xml" = {
    #  source = dotfiles/xfce4/xfconf/xfce-perchannel-xml/thunar.xml;
    #  force = true;
    #};
    #"xfce4/xfconf/xfce-perchannel-xml/thunar-volman.xml" = {
    #  source = dotfiles/xfce4/xfconf/xfce-perchannel-xml/thunar-volman.xml;
    #  force = true;
    # };
    #"gtk-3.0/bookmarks".source = dotfiles/gtk-3.0/bookmarks;
    #"gtk-3.0/settings.ini".source = dotfiles/gtk-3.0/settings.ini;
    #"gtk-4.0/bookmarks".source = dotfiles/gtk-3.0/bookmarks;
    #"gtk-4.0/settings.ini".source = dotfiles/gtk-3.0/settings.ini;
    #"yt-dlp/config".source = dotfiles/yt-dlp/config;
    #"kdeglobals".source = dotfiles/kdeglobals;

    "kdeglobals" = {
    force = true;
    text = builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors" + ''

      [Icons]
      Theme=oxygen

      [KDE]
      LookAndFeelPackage=org.kde.breezedark.desktop
      widgetStyle=Breeze

      [UiSettings]
      ColorScheme=BreezeDark
    '';
    };

    "qt6ct/style-colors.conf".source = dotfiles/qtct/style-colors.conf;
    
    "niri/Chicago.jpg".source = dotfiles/niri/Chicago.jpg;
    "niri/config.kdl".source = symlink "${fullDotfilesDir}/niri/config.kdl";
    "fcitx5".source = symlink "${fullDotfilesDir}/fcitx5";
  };
  
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt6ctSettings = {
      Appearance = {
        #color_scheme_path= "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
        color_scheme_path= "${homeDir}/.config/qt6ct/style-colors.conf";
        custom_palette=true;
        icon_theme="oxygen";
        standard_dialogs="default";
        style="Breeze";
      }; 
      Fonts = {
        fixed = "\"JetBrainsMonoNL Nerd Font,10\"";
        general = "\"Noto Sans,10\"";
      };
      Troubleshooting = {
          force_raster_widgets=1;
      };
   };
  };

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

  services.mako = {
    enable = true;
    settings = {
      background-color = "#11111bef";
      border-color = "#a32cc4ff";
      default-timeout = 10000;
    };
  };

  programs = {
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMonoNL Nerd Font";
        # You can specify size here if needed, e.g., size = 12.0;
      };

      settings = {
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        disable_ligatures = "always";
        confirm_os_window_close = 0;
        remember_window_size = "no";
        background_opacity = "0.85";
        background = "#11111b";
        dynamic_background_opacity = "yes";
      };
    };

    # Let Home Manager install and manage itself.
    bash = {
      enable = true;
      
      shellAliases = {
        vim = "nvim";
      };

      initExtra = ''export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ "'';
    };

    obs-studio.enable = true;
    joplin-desktop.enable = true;
    waybar = {
      enable = true;
      #systemd.enable = true;
    };

    yt-dlp = {
      enable = true;
      settings = {
        js-runtimes = "node";
      };
    };
    

    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
        hosts = [ "https://github.com" "https://gist.github.com" ];
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Henry Trowbridge";
          email = "henry@htrow.dev";
        };
        init.defaultBranch = "main";
      };
    };

    btop.enable = true;

    fuzzel = {
      enable = true;
      settings = {
        main = {
          icon-theme="oxygen";
          width=40;
          # tabs=8
          horizontal-pad=8;
          vertical-pad=2;
        };

        colors = {
          background="11111bdf";
          text="fcfcfcff";
          prompt="fcfcfcff";
          input="fcfcfcff";
          selection="3daee9ff";
          selection-text="fcfcfcff";
          border="a32cc4ff";
        };

        border = {
         width=2;
         radius=0;
        };
      };
    };
    firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
	path = "lr2w8zpp.default";
        settings = {
          "browser.urlbar.trimURLs" = false;
        };
      };
    };

    anki.enable=true;
    home-manager.enable = true;
  };
}

{ config, pkgs, ... }:

{
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      #"org.jdownloader.JDownloader"
      #"com.makemkv.MakeMKV"
    ];

#     overrides = {
#       # Removes any override files in ~/.local/share/flatpak/overrides not declared here
#       pruneUnmanagedOverrides = true;
#       # Replaces override files with pure Nix-evaluated files instead of merging with old manual edits
#       writeMode = "replace";
#
#       settings = {
#         global = {
#           Context = {
#             filesystems = [
#               # Required on NixOS so Home Manager symlinks (kdeglobals, gtk-3.0) and icons resolve
#               "/nix/store:ro"
#               "xdg-config/kdeglobals:ro"
#               "xdg-config/gtk-3.0:ro"
#               "xdg-data/color-schemes:ro"
#               "xdg-data/icons:ro"
#               "${pkgs.kdePackages.oxygen-icons}:ro"
#               "~/.icons:ro"
#               "${pkgs.adwaita-icon-theme}:ro"
#             ];
#           };
#           Environment = {
#             XMODIFIERS = "@im=fcitx";
#             QT_QPA_PLATFORMTHEME = "kde";
#             QT_STYLE_OVERRIDE = "Breeze";
#             XCURSOR_THEME = config.home.pointerCursor.name;
#             XCURSOR_SIZE = toString config.home.pointerCursor.size;
#             XCURSOR_PATH = "${config.home.homeDirectory}/.icons:${config.home.homeDirectory}/.local/share/icons:${config.home.pointerCursor.package}/share/icons:/run/current-system/sw/share/icons";
#           };
#         };
#       };
#     };
  };

  home.packages = with pkgs; [
    ungoogled-chromium
    playerctl
    swaylock
    xarchiver
    bluetui
    wiremix
    swaybg
    wl-clipboard
    jq
    xwayland-satellite
    #libayatana-appindicator
    kdePackages.oxygen-icons
    kdePackages.breeze-gtk
    kdePackages.breeze
    kdePackages.breeze.qt5
    kdePackages.isoimagewriter
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.kclock
    kdePackages.kcharselect
    #bazaar
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
    #vscodium-fhs
    distrobox
    micro
    neovim
    fastfetch

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
  ];
}

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
    bluetui
    swaybg
    wl-clipboard
    jq
    xwayland-satellite
    trashy
    kdePackages.breeze-gtk
    kdePackages.breeze
    kdePackages.breeze.qt5
    kdePackages.isoimagewriter
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.kclock
    kdePackages.kcharselect
    kdePackages.ark
    makemkv
    pika-backup
    xournalpp
    freefilesync
    filezilla
    krita
    remmina
    kdePackages.kdenlive
    kdePackages.kate
    qbittorrent
    mkvtoolnix
    vlc
    audacious
    signal-desktop
    podman-compose
    nixfmt

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

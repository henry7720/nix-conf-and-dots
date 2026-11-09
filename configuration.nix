# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };

      efi.canTouchEfiVariables = true;
    };
    
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # LOAD GPU DRIVER for encryption prompt
    initrd.kernelModules = [ "amdgpu" ];

    kernelModules = [
      # ensure we can set conservation mode on every boot
      "ideapad_laptop"
      # for nixos:
      "sg"
    ];
  };

  console = {
    packages = with pkgs; [ spleen ];
    font = "spleen-12x24";
    earlySetup = true;
  };

  networking.hostName = "nixos-yoga"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    
  };
  # Enable networking
  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
  };
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_TW.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
          fcitx5-gtk
          qt6Packages.fcitx5-qt
        ];
      };
    };
  };
  
  fonts.packages = with pkgs; [
    noto-fonts
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    arphic-ukai
    arphic-uming
    jigmo
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."henry" = {
    isNormalUser = true;
    description = "Henry";
    extraGroups = [ "networkmanager" "wheel" "cdrom" "libvirtd" ];
    # packages = with pkgs; [];
  };


  programs = {
    niri = {
      enable = true;
      useNautilus = false;
    };
        
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    #setup for thunar by nix docs
    xfconf = {
      enable = true;
    };

    virt-manager.enable = true;
    dconf.enable = true;
    k3b.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
    };
  };
  
  security.rtkit.enable = true;
    #pam.services.swaylock = {};

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  
  systemd = {
    services = {
      # Custom service to force battery to STAY NOT CHARGING PAST 80%
      battery-conservation = {
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-modules-load.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
	# In previous revisions, the wildcard * was VPC2004:00 (identified via research), but this may not be stable on kernel updates, so we write * to be safe
        script = "echo 1 > /sys/bus/platform/drivers/ideapad_acpi/*/conservation_mode";
      };

      NetworkManager-wait-online.enable = false;
    };

    oomd.enable = true;
  };
  
  services = {
    tuned = {
      enable = true;
      ppdSupport = true;
    };
    
    greetd = {
      enable = true;
      settings = {
        default_session = {
          # Launches tuigreet, shows the time, and sets Niri as the default command
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "greeter";
        };
      };
    };

    # match niri's default
    gnome.gnome-keyring.enable = true;

    # for xfce
    tumbler.enable = true;

    gvfs.enable = true;

    udisks2.enable = true;
    
    flatpak.enable = true;
    
    upower.enable = true;
    
    tailscale.enable = true;
    
    ipp-usb.enable = true;
    #sudo firintd-enroll henry
    fprintd.enable = true;  

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      drivers = with pkgs; [
        cups-filters
      ];
      enable = true;
    };
    
    # Configure keyboard map in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      #alsa.support32Bit = true;
      pulse.enable = true;

      #if you want JACK apps, uncomment
      #jack.enable = true;
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  environment = {
    systemPackages = with pkgs; [
      brightnessctl
    ];
  };
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment = {
  #   systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #    brightnessctl
  #    playerctl
  #    swaylock
  #    ntfs3g
  #  ];
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

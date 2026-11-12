{ config, pkgs, ... }:

{
  programs = {
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMonoNL Nerd Font";
        size = 12.0;
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

    bash = {
      enable = true;

      shellAliases = {
        vi = "nvim";
        vim = "nvim";

        # low-risk changes only
        up-live = "nixos-rebuild switch --flake ~/nixos#nixos-yoga --sudo";

        # Update flakes for actual updates
        # Test build to see if it builds!
        up-flake = "(cd ~/nixos && nix flake update && nixos-rebuild build --flake .#nixos-yoga)";

        # Higher risk changes: install as the next boot entry without touching the running system
        # if it doesn't boot you lose nothing
        up-boot = "nixos-rebuild boot --flake ~/nixos#nixos-yoga --sudo";

        # Firmware (BIOS/EC) updates, which don't come from nixpkgs
        up-fw = "fwupdmgr refresh && fwupdmgr update";
      };

      initExtra = ''export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ "'';
    };

    obs-studio.enable = true;
    joplin-desktop.enable = true;

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

    anki.enable = true;
  };
}

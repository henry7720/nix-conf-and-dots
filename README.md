# NixOS Configuration + Dot Files

Enclosed in this repo are my configurations for my [`NixOS`](https://nixos.org/) (`nixos-yoga`), Infrastructure-as-Code-managed system. It uses a unified Flake architecture ([`flake.nix`](flake.nix)) combining system-level NixOS configurations and user-space Home Manager modules, with version-locking a la ([`flake.lock`](flake.lock)) and an aligned [`nixpkgs`](https://github.com/NixOS/nixpkgs) input (`nixos-unstable` via `inputs.nixpkgs.follows`) across all dependencies to prevent evaluation drift and ensure single-source reproducibility.

UEFI Secure Boot is implemented with custom keys generated via `sbctl` and by replacing standard `systemd-boot` (`lib.mkForce false`) with the [`lanzaboote`](https://github.com/nix-community/lanzaboote) module for signed UKI/boot generation management. Additionally, [`nix-flatpak`](https://github.com/gmodena/nix-flatpak) is wired into Home Manager's `sharedModules` with `uninstallUnmanaged = true` and weekly systemd calendar updates to enforce declarative Flatpak state (though individual Flatpak packages are currently commented out).

One feature I have loved is that the Nix language has an elegance in that it has a capability of being self-documenting in some instances. While the syntax and features of the language are specialized, the language has grown on me and it will on you also.

It has been an amazing learning experience diving into the declarative world, having used both Arch and [`fedora-bootc`-enabled systems](https://github.com/henry7720/fedora-atomic-container-setup) with custom `Containerfile`-based builds/managed servers, along with others such as Debian and FreeBSD in desktop and server forms.


## System Architecture

As a principle, the system [`configuration.nix`](configuration.nix) is focused on software interacting with hardware, kernel interfaces, and components requiring root privileges (think system daemons and virtualization), also included is a [`hardware-configuration.nix`](hardware-configuration.nix) file which would ideally be regenerated per-device.

* **Storage & Early Boot (`initrd`):** Built on a LUKS-encrypted Btrfs root filesystem with dedicated `home` and `nix` subvolumes, plus a monthly `btrfs.autoScrub` job. The `amdgpu` kernel module is injected directly into `boot.initrd.kernelModules` alongside early console setup (`spleen-12x24` font) to ensure outputs to external displays during the LUKS passphrase prompt. Impermanence may be a future project, time allowing.


* **Hardware Power & Conservation Management:** Loads the `ideapad_laptop` kernel module and declares and runs a custom oneshot systemd service (`battery-conservation.service`) ordered after `systemd-modules-load.service`. Rather than relying on a fragile hardcoded ACPI device ID (e.g., `VPC2004:00`) that might shift across kernel updates, the unit writes `1` to `/sys/bus/platform/drivers/ideapad_acpi/*/conservation_mode` via `sysfs` to cap battery charging at 80%. Power profiles are managed via `tuned` with `ppdSupport = true` to ensure standard power-profiles display in the my `waybar` setup/other shells.


**Display, Audio & Input Stack:**
* **Greetd & Niri:** `greetd` launches `tuigreet` into a `niri-session` Wayland compositor.

* **PipeWire:** Low-latency audio routing with `rtkit` realtime scheduling, ALSA, and PulseAudio compatibility layers enabled (`pulseaudio.enable = false`).

* **Internationalization & CJK Input:** Configured with `en_US.UTF-8`, `zh_TW.UTF-8`, and `zh_CN.UTF-8` locales, comprehensive CJK font coverage (`noto-fonts-cjk`, `arphic-ukai`, `arphic-uming`, `jigmo`), and `fcitx5` running with its native `waylandFrontend` and Qt6/GTK Chinese addons.

* **Networking & Virtualization:** NetworkManager paired with `systemd-resolved` for local DNS caching, `avahi` (`nssmdns4`) for local mDNS resolution, and `tailscale` for mesh networking. Virtualisation is handled via `libvirtd` (`virt-manager` / `kvm-amd`) and rootless `podman` configured with `dockerCompat = true`.


* **Nix Store Maintenance:** Automatic store hard-linking (`auto-optimise-store = true`) and weekly garbage collection (`--delete-older-than 30d`).


## User Environment (`home.nix` & `user-modules/`)

For my user profile, I use Home Manager wherever possible and convenient, integrated directly as a NixOS module (`useGlobalPkgs = true`, `useUserPackages = true`) so user packages evaluate against the system's `nixpkgs` instance. [`home.nix`](home.nix) acts as a global importer for four modularized files under [`user-modules/`](user-modules/):

* **[`desktop.nix`](user-modules/desktop.nix):** Manages Wayland session daemons (`mako` notification daemon, `hyprpolkitagent`, `waybar`, and `fuzzel` application launcher), declarative `xfconf` settings for `thunar` (details view, disabled CSD, `thunar-volman` drive automounting), and `xdg.mimeApps` default associations. For configs requiring live reloading or frequent manual iteration, it uses `config.lib.file.mkOutOfStoreSymlink` to bypass read-only `/nix/store` links and point `~/.config` entries directly at [`dotfiles/`](dotfiles/).

* **[`theming.nix`](uuser-modules/theming.nix):** Enforces a unified (dark) theme across toolkits. Configures `Breeze-Dark` and `oxygen` icons for GTK and Qt (`qt5ct` / `qt6ct`), sets `prefer-dark` in `dconf`, and dynamically constructs `~/.config/kdeglobals` using `pkgs.concatText` to merge upstream `BreezeDark.colors` with custom `[Icons]`, `[KDE]`, and `[UiSettings]` blocks.

* **[`programs.nix`](user-modules/programs.nix):** Declarative configurations for `kitty`, `git`, `gh`, `btop`, `obs-studio`, `joplin-desktop`, `anki`, `yt-dlp` (with Node JS runtime enabled), and `firefox`. Also defines custom `bash` rebuild workflow aliases:

    * `up-live`: `nixos-rebuild switch --flake ~/nixos#nixos-yoga --sudo` for applying low-risk changes immediately.

    * `up-flake`: Updates `flake.lock` and runs a dry test build (`nixos-rebuild build`) without switching.

    * `up-boot`: Stages higher-risk changes for the next reboot (`nixos-rebuild boot`) without interrupting the active session.

    * `up-fw`: Refreshes and applies BIOS/EC firmware updates via `fwupdmgr`.


* **[`packages.nix`](user-modules/packages.nix):** User-space package declarations (subject to change at my convenience).


## Out-of-Store Dotfiles

There is more not described above and plenty more work to be done. Meanwhile, there are various counterexamples in the [`dotfiles/`](dotfiles/) directory that remain separated from my Nix-based configuration -- either because no Home Manager module exists, or because frequent manual edits/compositor tweaks make pure Nix translation impractical:

* **Niri ([`dotfiles/niri/config.kdl`](dotfiles/niri/config.kdl)):** Scrollable-tiling Wayland compositor config featuring multi-monitor logical coordinate mapping (`eDP-1`, `DP-2`, `HDMI-A-1`), background blur shaders, `caps:ctrl_modifier` XKB remapping, and custom floating window rules that wrap TUI utilities (`wiremix`, `bluetui`, `nmtui`) in centered `kitty --class` popup windows. Includes a custom `jq` + `niri msg` keybind (`Super+Alt+O`) to dynamically query and toggle the laptop's internal `eDP-1` panel even while the screen is locked.


* **Waybar ([`dotfiles/waybar/`](dotfiles/waybar/)):** A compact 20px top bar with useful modules, such as clock/bluetooth/network/CPU, etc. styled with GTK CSS resets to prevent height clipping, color-coded per-module underlines, and click handlers tied to the floating Kitty TUI rules.


* **Fcitx5 ([`dotfiles/fcitx5/`](dotfiles/fcitx5/)):** Pinyin and Traditional/Simplified Chinese (`chttrans` via OpenCC) input method profiles, custom input-method toggle key of (`Caps_Lock`) matching mainland Chinese conventions (default function overridden in Niri), and `Noto Sans CJK TC` candidate rendering.


* **Bonus - Quasi-Declarative Distrobox (`dotfiles/arch-dev/arch-dev.ini`):** A Podman-backed `distrobox-assemble` manifest (`quay.io/toolbx/arch-toolbox:latest`) that provisions an `arch-dev` build container with its own dedicated home directory (`~/arch-dev`). On creation, it automatically installs compilers and toolchains (`gcc`, `clang`, `llvm`, `gdb`, `valgrind`, `rust`, `uv`, `python`, `nodejs`, `jdk-openjdk`), symlinks host credentials and IDE configs (`.ssh`, `.config/git`, `.gemini`, `VSCodium`), bootstraps `yay-bin` and `vscodium-bin` from the AUR via `init_hooks`, and exports the binaries (`exported_bins`) and VSCodium (`exported_apps`) directly back to the NixOS host. The very same build could very well be implemented in a Containerfile, also. To be clear, the script is *not perfect* and has some security gotchas, so use with caution, but it meets my needs very well (at least until I get VSCodium declaratively defined or managed otherwise).



## NOTE

This repo is very much a work in progress, so expect frequent changes. Up to this publication, it has been local-only (backed up, of course) but admittedly somewhat lazily-managed (one branch, undescriptive commit messages, and there are crufty comments throughout the codebase which need removing); however, seeing as I want it to be useful for those who follow, I will maintain commit messages better and better-document what has been done up to this point and why as I continually improve this base.

## License

The code and surrounding configurations (and all other files in this repo) are licensed under the [`AGPL v3`](LICENSE) license.

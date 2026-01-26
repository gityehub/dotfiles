{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
   # driSupport = true;
    enable32Bit = true;
  };
#OwnAdding to enable app discovery with plasma+hyprland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
  # OwnAdding: Virt-manager for virtual machine use
      ./vm.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # OwnAdding: This fixes an issue where an extra "unknown" monitor appears
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; # Plasma 6 prefers Wayland
};

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.niri = {
    enable = true;
  };

  services.xserver.xkb = {
    layout = "fi";
    variant = "";
  };

  console.keyMap = "fi";

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
     enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.jon = {
    isNormalUser = true;
    description = "Jon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kdePackages.kate
      thunderbird
      protonmail-bridge-gui
    ];
  };

  nixpkgs.config.allowUnfree = true;
  # OwnAdding: probably not even necessary, added when I was wondering why my packages weren't updating, but updating the channel fixed this
  nix.package = pkgs.nixVersions.stable;
  environment.systemPackages = with pkgs; [
    vim
    neovim
    lf
    fzf
    wget
    librewolf
    mullvad-browser
    brave
    spotify
    ffmpeg
    ffmpegthumbnailer
    discord
    tor-browser
    steam
    openvpn
    keepassxc
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    waybar
    fuzzel
    alacritty
    kitty
    wofi
    wlogout
    networkmanagerapplet
    hyprpaper
    github-desktop
    nwg-look
    pavucontrol
    libreoffice
    prismlauncher
    file
    vlc
    mpv
    imv
    syncthing
  ];

  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    noto-fonts-color-emoji
  ];

  environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
  };

  environment.variables = {
  EDITOR = "vim";
  VISUAL = "vim";
  };

  #polkit, apparently essential for hyprland to work
  security.polkit.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

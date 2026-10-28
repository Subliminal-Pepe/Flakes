{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "mac";
  networking.networkmanager.enable = true;

  # Time dash language
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

   services.xserver.xkb = {
    layout = "de";
    variant = "";
   };

  console.keyMap = "de";

 # user
  users.users.Mac-NixOS = {
    isNormalUser = true;
    group = "Mac-NixOS";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  users.groups.Mac-NixOS = {};


  # Pkgs
  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
    rquickshare
    vlc
    vscodium
    hyprmon
    neovim
    hyprmod
    fetch
  ];

  # Desktop: Hyprland + SDDM
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.firefox.enable = true;
  programs.git.enable = true;
  services.timesyncd.enable = true;  
  # Sound
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};

security.rtkit.enable = true;
  # Tools
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Did You read the commmend? No? Well f+ck You.
  system.stateVersion = "26.05";
}

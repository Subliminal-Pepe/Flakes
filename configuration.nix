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
    lazygit
    hyprshot
    loupe
    imagemagick
    nh
    kdePackages.kdeconnect-kde
    nautilus
    opencode
    cifs-utils # provides mount.cifs for the CIFS mount below
    fotema
    gimp
    chromium
    libreoffice
    bruno
    joplin-desktop
    joplin-cli
    fzf
    ollama
    python313Packages.pip
    python3
    aria2 
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

  programs.direnv.enable = false;
  programs.direnv.silent = false;
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

  # CIFS mount of the Samba share on HOMESERVER.
  # Credentials live in /etc/samba/gast.cred (root, 0600) so the password
  # does not end up world-readable in /nix/store or /etc/fstab:
  #   sudo install -d -m 0755 /etc/samba
  #   sudo sh -c 'printf "username=gast\npassword=gast\n" > /etc/samba/gast.cred && chmod 600 /etc/samba/gast.cred'
  fileSystems."/mnt/homeserver" = {
    device = "//192.168.178.10/share";
    fsType = "cifs";
    options = [
      "credentials=/etc/samba/gast.cred"
      "vers=3.0"              # server negotiates SMB 3.x fine
      "uid=1000"              # Mac-NixOS
      "gid=986"               # Mac-NixOS group
      "iocharset=utf8"
      "file_mode=0664"
      "dir_mode=0775"
      "nofail"                # never block boot if the NAS is offline
      "_netdev"               # wait for the network
      "x-systemd.automount"   # mount on first access
      "x-systemd.idle-timeout=600"  # unmount after 10 min idle
    ];
  };


  # Did You read the commmend? No? Well f+ck You.
  system.stateVersion = "26.05";
}


{ inputs, lib, ... }:

{
  home.username = "Mac-NixOS";
  home.homeDirectory = lib.mkForce "/home/Mac-NixOS";
  home.stateVersion = "26.05";
  imports = [
    ./Caelestia.nix
  ];


home.activation.cloneWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
  mkdir -p "$WALLPAPER_DIR"

  clone_or_pull() {
    local url="$1"
    local dest="$2"

    if [ ! -d "$dest/.git" ]; then
      git clone "$url" "$dest"
    else
      git -C "$dest" pull --ff-only || true
    fi
  }

  # clone_or_pull https://github.com/AlexandrosLiaskos/Awesome_Wallpapers "$WALLPAPER_DIR/Awesome_Wallpapers"
  # clone_or_pull https://github.com/JaKooLit/Wallpaper-Bank "$WALLPAPER_DIR/Wallpaper-Bank"
  # clone_or_pull https://github.com/NixOS/nixos-artwork/tree/master/wallpapers "$WALLPAPER_DIR/NixOS"
'';
}
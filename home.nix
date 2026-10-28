
{ inputs, lib, ... }:

{
  home.username = "Mac-NixOS";
  home.homeDirectory = lib.mkForce "/home/Mac-NixOS";
  home.stateVersion = "26.05";
  imports = [
    ./Caelestia.nix
  ];

}
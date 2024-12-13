{lib, config, pkgs, ... }: let  username = "goat "; in {
imports = [./hardware-configuration.nix];
boot.loader.efi.canTouchefiVariables = true;
boot.loader.grub.enable = true;
boot.loader.grub.efiSupport = true;
boot.loader.grub.device = "nodev";
nixpkgs.config.allowUnfree = true;
nix.experimental-features = ["nix-command" "flakes"];
networking.networkmanager.enable = true;
networking.hostName = "${username}"; 
users.users.${username}.isNormalUser = true;
users.users.${username}.extraGroups = ["wheel"];
system.stateVersion = "24.05";}
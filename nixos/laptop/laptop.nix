# nixos/laptop.nix
{ inputs, ... }:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ./../firefox.nix
  ];

  # Overrides: This takes precedence over configuration.nix
  hardware.tuxedo-drivers.enable = true;
  hardware.tuxedo-control-center.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}


{ config, pkgs, ... }:

let
  identity = import ./resources/identity.nix;

in
{
  imports = [
     ./containers/traefik.nix
     ./containers/homepage.nix
     ./containers/vaultwarden.nix
     ./containers/portainer.nix
     ./containers/syncthing.nix
  ];

   virtualisation = {
    docker = {
      enable = true;
      enableNvidia = true;
      autoPrune = {
         enable = true;
        dates = "weekly";
      };
   };

    oci-containers.backend = "docker";

    containers.registries.search = [ "docker.io" "ghcr.io" "lscr.io" ];

    # Virtual machines
    libvirtd.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
    interfaces.containers = {
      allowedUDPPorts = [ 53 ]; # this needs to be there so that containers can look eachother's names up over DNS
    };
  };
  
  systemd.services.containers-network = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "${backend}-traefik.service" "${backend}-homepage.service" "${backend}-portainer.service" "${backend}-vaultwarden.service" "${backend}-syncthing.service" ];
    script = ''
      ${pkgs.docker}/bin/${backend} network exists containers-network || \
      ${pkgs.docker}/bin/${backend} network create containers-network
      '';
  };
}
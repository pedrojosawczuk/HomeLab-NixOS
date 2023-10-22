{ config, lib, pkgs, ... }:
{
  virtualisation.oci-containers.containers.portainer = {
    autoStart = true;
    image = "docker.io/portainer/portainer-ce:latest";
    environment = {
      PUID = "1000"; 
      PGID = "1000";
    };
    # ports = [ "8000:8000" ];
    volumes = [
      "/home/homeserver/selfhosted/portainer:/data"
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
    dependsOn = [ "traefik" ];
    extraOptions = [
      "--network=containers-network"
      "-l" "traefik.enable=true"
      "-l" "traefik.http.routers.portainer.entrypoints=http"
      "-l" "traefik.http.routers.portainer.rule=Host(`portainer.docker.localhost`)"
      "-l" "traefik.http.middlewares.portainer-https-redirect.redirectscheme.scheme=https"
      "-l" "traefik.http.routers.portainer.middlewares=portainer-https-redirect"
      "-l" "traefik.http.routers.portainer-secure.entrypoints=https"
      "-l" "traefik.http.routers.portainer-secure.rule=Host(`portainer.docker.localhost`)"
      "-l" "traefik.http.routers.portainer-secure.tls=true"
      "-l" "traefik.http.routers.portainer-secure.service=portainer"
      "-l" "traefik.http.services.portainer.loadbalancer.server.port=9000"
      "-l" "traefik.docker.network=containers-network"
    ];
  };
}
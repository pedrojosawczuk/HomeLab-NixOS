{ config, lib, pkgs, ... }:
{
  virtualisation.oci-containers.containers.traefik = {
    autoStart = true;
    image = "docker.io/traefik:latest";
    environment = {
      PUID = "1000"; 
      PGID = "1000";
    };
    ports = [ "80:80" "443:443" ];
    volumes = [
      "/home/homeserver/selfhosted/traefik:/etc/traefik"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    extraOptions = [
      "--network=containers-network"
      "-l" "traefik.enable=true"
      "-l" "traefik.http.routers.traefik.entrypoints=http"
      "-l" "traefik.http.routers.traefik.rule=Host(`traefik.docker.localhost`)"
      "-l" "traefik.http.middlewares.traefik-https-redirect.redirectscheme.scheme=https"
      "-l" "traefik.http.routers.traefik.middlewares=traefik-https-redirect"
      "-l" "traefik.http.routers.traefik-secure.entrypoints=https"
      "-l" "traefik.http.routers.traefik-secure.rule=Host(`traefik.docker.localhost`)"
      "-l" "traefik.http.routers.traefik-secure.tls=true"
      "-l" "traefik.http.routers.traefik-secure.service=traefik"
      "-l" "traefik.http.services.traefik.loadbalancer.server.port=8080"
      "-l" "traefik.docker.network=containers-network"
    ];
  };
}
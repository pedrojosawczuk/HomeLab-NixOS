{ config, lib, pkgs, ... }:
{
  virtualisation.oci-containers.containers.homepage = {
    autoStart = true;
    image = "ghcr.io/gethomepage/homepage:latest";
    environment = {
      PUID = "1000"; 
      PGID = "1000";
    };
    # ports = [ "80:3000" ];
    volumes = [
      "/home/homeserver/selfhosted/homepage:/app/config"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    dependsOn = [ "traefik" ];
    extraOptions = [
      "--network=containers-network"
      "-l" "traefik.enable=true"
      "-l" "traefik.http.routers.home.entrypoints=http"
      "-l" "traefik.http.routers.home.rule=Host(`home.docker.localhost`)"
      "-l" "traefik.http.middlewares.home-https-redirect.redirectscheme.scheme=https"
      "-l" "traefik.http.routers.home.middlewares=home-https-redirect"
      "-l" "traefik.http.routers.home-secure.entrypoints=https"
      "-l" "traefik.http.routers.home-secure.rule=Host(`home.docker.localhost`)"
      "-l" "traefik.http.routers.home-secure.tls=true"
      "-l" "traefik.http.routers.home-secure.service=home"
      "-l" "traefik.http.services.home.loadbalancer.server.port=3000"
      "-l" "traefik.docker.network=containers-network"
    ];
  };
}
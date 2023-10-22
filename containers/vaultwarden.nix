{ config, lib, pkgs, ... }:
{
  virtualisation.oci-containers.containers.vaultwarden = {
    autoStart = true;
    image = "docker.io/vaultwarden/server:latest";
    environment = {
      PUID = "1000"; 
      PGID = "1000";
      SIGNUPS_ALLOWED = "false";
      INVITATIONS_ALLOWED = "false";
      WEBSOCKET_ENABLED = "true";
    };
    # ports = [ "8181:80" "3012:3012" ];
    volumes = [
      "/home/homeserver/selfhosted/vaultwarden:/data"
    ];
    dependsOn = [ "traefik" ];
    extraOptions = [
      "--network=containers-network"
      "-l" "traefik.enable=true"
      "-l" "traefik.http.routers.vaultwarden.entrypoints=http"
      "-l" "traefik.http.routers.vaultwarden.rule=Host(`vaultwarden.docker.localhost`)"
      "-l" "traefik.http.middlewares.vaultwarden-https-redirect.redirectscheme.scheme=https"
      "-l" "traefik.http.routers.vaultwarden.middlewares=vaultwarden-https-redirect"
      "-l" "traefik.http.routers.vaultwarden-secure.entrypoints=https"
      "-l" "traefik.http.routers.vaultwarden-secure.rule=Host(`vaultwarden.docker.localhost`)"
      "-l" "traefik.http.routers.vaultwarden-secure.tls=true"
      "-l" "traefik.http.routers.vaultwarden-secure.service=vaultwarden"
      "-l" "traefik.http.services.vaultwarden.loadbalancer.server.port=80"
      "-l" "traefik.docker.network=containers-network"
    ];
  };
}
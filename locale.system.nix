{ config, lib, pkgs, ... }:

{
  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
      "fr_CA.UTF-8/UTF-8"
      "pt_BR.UTF-8/UTF-8"
    ];
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_ADDRESS = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
    };
  };
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
}
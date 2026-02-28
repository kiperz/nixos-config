{ config, pkgs, ... }:

{
  # Disable PulseAudio (PipeWire replaces it)
  hardware.pulseaudio.enable = false;

  # PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol # GUI audio mixer
    pamixer # CLI volume control (for keybinds)
  ];
}

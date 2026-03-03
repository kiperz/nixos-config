# Vesktop — Discord client with Vencord, NVIDIA-compatible encoding flags
{ config, pkgs, lib, ... }:

let
  vesktop-nvidia = pkgs.vesktop.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      # Add NVIDIA-friendly Electron flags
      wrapProgram $out/bin/vesktop \
        --add-flags "--enable-features=VaapiVideoDecodeLinuxGL,WebRTCPipeWireCapturer" \
        --add-flags "--use-gl=egl"
    '';
  });
in
{
  home.packages = [ vesktop-nvidia ];
}

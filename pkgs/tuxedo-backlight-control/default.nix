{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "tuxedo-backlight-control";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/webketje/tuxedo-backlight-control/releases/download/v${version}/tuxedo-backlight-control-${version}-1-any.pkg.tar.xz";
    sha256 = "sha256-Ad/k27oOGerAWOLrkQpOKT9bYK/whlqwC5v9/vO3yWM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  /*
  buildInputs = [
    alsaLib
    openssl
    zlib
    pulseaudio
  ];
  */

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/usr/share/tuxedo-backlight-control/
    install -Dm644 usr/share/tuxedo-backlight-control/backlight.py $out/usr/local/bin/backlight
    install -Dm644 usr/share/polkit-1/actions/webketje.tuxedo-backlight-control.policy $out/usr/share/polkit-1/actions/webketje.tuxedo-backlight-control.policy
    install -Dm644 usr/share/applications/tuxedo-backlight-control.desktop $out/usr/share/applications/tuxedo-backlight-control.desktop
    install -D usr/share/tuxedo-backlight-control/ui.py $out/usr/share/tuxedo-backlight-control/ui.py
    install -D usr/share/tuxedo-backlight-control/backlight.py $out/usr/share/tuxedo-backlight-control/backlight.py
    install -D usr/share/tuxedo-backlight-control/backlight_control.py $out/usr/share/tuxedo-backlight-control/backlight_control.py
    install -D usr/share/tuxedo-backlight-control/icon.png $out/usr/share/tuxedo-backlight-control/icon.png
    install -D usr/share/tuxedo-backlight-control/colors.py $out/usr/share/tuxedo-backlight-control/colors.py
  '';

  meta = with lib; {
    homepage = "https://github.com/webketje/tuxedo-backlight-control";
    description = "Minimal Linux distro CLI & UI for TUXEDO / Clevo computers Keyboard Backlight";
    platforms = platforms.linux;
  };
}

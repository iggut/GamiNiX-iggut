{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkgconfig,
  wrapGAppsHook,
  gtk3,
  libpulseaudio,
  libmpdclient,
  libxkbcommon,
  gtk-layer-shell,
  json_c,
  glib,
}:
stdenv.mkDerivation rec {
  pname = "sfwbar";
  version = "git";
  src = fetchFromGitHub {
    owner = "LBCrion";
    repo = pname;
    rev = "077957eb942407464f9254d7af2b13e261706e11";
    sha256 = "UCnp3YXyWPsKxq/6lSBFVYv8eNBHpI4frmeW1W9OAbM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    json_c
    glib
    libpulseaudio
    libmpdclient
    libxkbcommon
  ];

  mesonFlags = [
    "-Dbsdctl=disabled"
  ];

  doCheck = false;

  postPatch = ''
    sed -i 's|gio/gdesktopappinfo.h|gio-unix-2.0/gio/gdesktopappinfo.h|' src/scaleimage.c
  '';

  meta = with lib; {
    description = "Sway Floating Window Bar";
    homepage = "https://github.com/LBCrion/sfwbar";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}

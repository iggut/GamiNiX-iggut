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
    rev = "e313920af8f9b269e0bf35b8f36f57f1b056778f";
    sha256 = "6S+Khj7uPfsNjEeGiBPvjICUpJv/SKPIUgqHXOApppE=";
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

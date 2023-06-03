{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook,
  gobject-introspection,
  gtk-layer-shell,
  pango,
  gdk-pixbuf,
  atk,
  # Extra packages called by various internal nwg-panel modules
  hyprland, # maybe
  sway, # swaylock, swaymsg
  systemd, # systemctl
  wlr-randr, # wlr-randr
  nwg-menu, # nwg-menu
  light, # light
  pamixer, # pamixer
  pulseaudio, # pactl
  libdbusmenu-gtk3, # tray
}:
python3Packages.buildPythonApplication rec {
  pname = "nwg-panel";
  version = "main";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-panel";
    #rev = "40cb44fe17b1da56f0adb451433e24d4fbead56e";
    #sha256 = "sha256-RakBwX6ftXg5Xvwpkj4JIIS1I3ATrBRw6PkFicIOs4k=";
    rev = "a4e18fc9627e4c285affb3aba2f07c64c999396e";
    sha256 = "sha256-nbHvLWv+cXj39ERT2Hbr7YJ1AxwV6xVXGz4EpqCV8qM=";
  };

  # No tests
  doCheck = false;

  # Because of wrapGAppsHook
  strictDeps = false;
  dontWrapGApps = true;

  buildInputs = [atk gdk-pixbuf gtk-layer-shell pango];
  nativeBuildInputs = [wrapGAppsHook gobject-introspection];
  propagatedBuildInputs =
    (with python3Packages; [i3ipc netifaces psutil pybluez pygobject3 requests dasbus setuptools])
    # Run-time GTK dependency required by the Tray module
    ++ [libdbusmenu-gtk3];

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}
    cp $src/nwg-panel-config.desktop $out/share/applications/
    cp $src/nwg-shell.svg $src/nwg-panel.svg $out/share/pixmaps/
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix XDG_DATA_DIRS : "$out/share"
      --prefix PATH : "${lib.makeBinPath [light nwg-menu pamixer pulseaudio sway systemd wlr-randr]}"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/nwg-piotr/nwg-panel";
    description = "GTK3-based panel for Sway window manager";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
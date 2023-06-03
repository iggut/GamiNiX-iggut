{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./home-main.nix
  ]; # Setup home manager for hyprland

  programs = lib.mkIf config.desktop-environment.hyprland.enable {
    nm-applet.enable = true; # Network manager tray icon
    kdeconnect.enable = true; # Connect phone to PC
  };

  environment = lib.mkIf config.desktop-environment.hyprland.enable {
    systemPackages = with pkgs; [
      # Status bar
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
        postPatch = ''
          sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
        '';
      }))
      baobab # Disk usage analyser
      blueberry # Bluetooth manager
      clipman # Clipboard manager for wayland
      dotnet-sdk_7 # SDK for .net
      fd # Find alternative
      gdtoolkit # Tools for gdscript
      gnome.file-roller # Archive file manager
      gnome.gnome-calculator # Calculator
      gnome.gnome-disk-utility # Disks manager
      gnome.nautilus # File manager
      grim # Screenshot tool
      jc # JSON parser
      playerctl # mpris controller
      brightnessctl # Adjust screen brightness
      pamixer # PulseAudio mixer
      networkmanagerapplet # Network manager tray icon
      nixfmt # A nix formatter
      pavucontrol # Sound manager
      nwg-bar # Sexy bar
      nwg-dock # Sexy dock
      nwg-drawer # Sexy app launcher
      nwg-menu # Sexy app menu
      polkit_gnome # Polkit manager
      ripgrep # Silver searcher grep
      rofi-wayland # App launcher
      slurp # Monitor selector
      swappy # Edit screenshots
      swaynotificationcenter # Notification daemon
      unzip # An extraction utility
      wdisplays # Displays manager
      wl-clipboard # Clipboard daemon
      wlogout # Logout screen
      swww # Wallpaper
      eww-wayland # Widgets and bars
      mpvpaper # Play videos with mpv as your wallpaper
    ];

    # Configure system services
    etc = {
      "wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
      "polkit-gnome".source = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      "kdeconnectd".source = "${pkgs.libsForQt5.kdeconnect-kde}/libexec/kdeconnectd";
    };
  };

  services = lib.mkIf config.desktop-environment.hyprland.enable {
    dbus.enable = true;
    gvfs.enable = true; # Needed for nautilus
  };

  security.polkit.enable = lib.mkIf config.desktop-environment.hyprland.enable true; # Enable polkit security

  disabledModules = ["programs/hyprland.nix"]; # Needed for hyprland flake

  security.pam.services.swaylock = { };

  home-manager.sharedModules = [{

    programs.swaylock = {
      package = pkgs."swaylock-effects";
      settings = {
        show-keyboard-layout = true;
        daemonize = true;
        effect-blur = "5x2";
        clock = true;
        indicator = true;
        font-size = 25;
        indicator-radius = 85;
        indicator-thickness = 16;
        screenshots = true;
        fade-in = 1;
      };
    };

    xdg = { userDirs = { enable = true; }; };
    xdg.configFile."hypr/hyprland.conf".text = ''

env=GLFW_IM_MODULE,ibus
    
# █▀▀ ▀▄▀ █▀▀ █▀▀
# ██▄ █░█ ██▄ █▄▄
# Basic functionalities

exec-once = dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = sleep 2 && hyprctl reload & /etc/polkit-gnome & swaync
#exec-once = sleep 2 && /home/iggut/.config/eww/bin/start_continuous 
exec-once = sleep 2 && sfwbar
exec-once = sleep 2 && bash /home/iggut/.config/hypr/scripts/change-bg.sh "code"
# Tray applications
exec-once = kdeconnect-indicator & clipman clear --all & wl-paste -t text --watch clipman store & nm-applet --indicator
# Standard applications
exec-once = sleep 2 && code & firefox
exec-once = sleep 4 && corectrl
exec-once = sleep 5 && webcord
exec-once = mullvad-vpn
exec-once = systemctl --user start kdeconnect
# Terminals/Task managers
exec-once = kitty --class startup-monitor --session ~/.config/kitty/kitty-task-managers.session  & kitty --class startup-kitty --session ~/.config/kitty/kitty.session


# █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█
# █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄

# See available monitors with 'hyprctl monitors'
monitor = DP-1,1920x1080@165,0x0,1
monitor = HDMI-A-1,2560x1440@60,1920x0,1
workspace = 1, monitor:DP-1, default:true
workspace = 2, monitor:DP-1
workspace = 3, monitor:DP-1
workspace = 4, monitor:DP-1
workspace = 5, monitor:DP-1
workspace = 6, monitor:DP-1
workspace = 7, monitor:HDMI-A-1
workspace = 8, monitor:HDMI-A-1
workspace = 9, monitor:HDMI-A-1
workspace = 10, monitor:HDMI-A-1




# █▀▀ █▀▀ █▄░█ █▀▀ █▀█ ▄▀█ █░░
# █▄█ ██▄ █░▀█ ██▄ █▀▄ █▀█ █▄▄
general {
  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  gaps_in = 6
  gaps_out = 12
  border_size = 0
  no_border_on_floating = true
  #one color
  #col.active_border = rgba(7aa2f7aa)
  #two colors - gradient
  col.active_border = rgba(7aa2f7aa) rgba(c4a7e7aa) 45deg
  col.inactive_border = rgba(414868aa)
  layout = dwindle
}

# █▀▄ █▀▀ █▀▀ █▀█ █▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
# █▄▀ ██▄ █▄▄ █▄█ █▀▄ █▀█ ░█░ █ █▄█ █░▀█
decoration {
  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  rounding = 10
  multisample_edges = true
  blur = yes
  blur_size = 10
  blur_passes = 3
  blur_new_optimizations = on

  active_opacity = 0.9
  inactive_opacity = 0.9
  fullscreen_opacity = 1.0

  drop_shadow = true
  shadow_ignore_window = true
  shadow_offset = 4 4
  shadow_range = 47
  shadow_render_power = 2
  col.shadow = 0x66000000

  # dim_inactive = true
  # dim_strength = 0.8
}

  blurls = gtk-layer-shell


# ▄▀█ █▄░█ █ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
# █▀█ █░▀█ █ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█
animations {
  enabled = yes
  bezier = overshot, 0.05, 0.9, 0.1, 1.05
  bezier = smoothOut, 0.36, 0, 0.66, -0.56
  bezier = smoothIn, 0.25, 1, 0.5, 1

  animation = windows, 1, 5, overshot, slide
  animation = windowsOut, 1, 4, smoothOut, slide
  animation = windowsMove, 1, 4, default
  animation = border, 1, 10, default
  animation = fade, 1, 10, smoothIn
  animation = fadeDim, 1, 10, smoothIn
  animation = workspaces, 1, 6, default
}

# █ █▄░█ █▀█ █░█ ▀█▀
# █ █░▀█ █▀▀ █▄█ ░█░
input {

  kb_layout = us


  kb_variant =
  kb_model =
  kb_options =
  kb_rules =

  follow_mouse = 1
  numlock_by_default = 1

  touchpad {
    natural_scroll = true
    tap-to-click = true
    drag_lock = true
    disable_while_typing = true
  }

  sensitivity = 1.0 # -1.0 - 1.0, 0 means no modification.
}

# █▀▄▀█ █ █▀ █▀▀
# █░▀░█ █ ▄█ █▄▄
misc {
  disable_hyprland_logo = true
  disable_splash_rendering = true
  mouse_move_enables_dpms = true
  vfr = true
  #enable_swallow = true
  #swallow_regex = ^(kitty)$
  no_direct_scanout = false #for fullscreen games
}

# █░░ ▄▀█ █▄█ █▀█ █░█ ▀█▀ █▀
# █▄▄ █▀█ ░█░ █▄█ █▄█ ░█░ ▄█
dwindle {
  # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
  # pseudotile = yes
  preserve_split = yes
  special_scale_factor = 0.6
}

master {
  # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
  new_is_master = true
  special_scale_factor = 0.6
}

gestures {
  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  workspace_swipe = true
  workspace_swipe_fingers = 3
}

# █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄
# █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀
$files = dolphin
$browser = google-chrome-stable
$term = kitty
$editor = code
# Set mod key to Super
$mainMod = SUPER

#Desktop usage
bind = $mainMod, R, exec, rofi -show drun
bind = $mainMod, V, exec, clipman pick -t rofi
bind = , Print, exec, grim - | wl-copy
bind = SHIFT, insert, exec, grim - | swappy -f -
bind = $mainMod, insert, exec, grim -g "$(slurp)" - | wl-copy
bind = $mainMod SHIFT, insert, exec, grim -g "$(slurp)" - | swappy -f -
bind = $mainMod, L, exec, wlogout
bind = $mainMod, N, exec, swaync-client -t -sw
bind = $mainMod SHIFT, N, exec, swaync-client -d -sw

bindr = SUPER, SUPER_L, exec, nwg-drawer

bind = $mainMod, D, exec, dolphin
bind = $mainMod SHIFT, Q, killactive,
bind = $mainMod SHIFT, Return, exec, $files
bind = $mainMod SHIFT, Space, togglefloating,
bind = $mainMod, E, exec, code
bind = $mainMod, F, fullscreen
bind = $mainMod, Q, killactive,
bind = $mainMod, Return, exec, $term
bind = $mainMod, T, exec, $term
bind = $mainMod, V, exec, pavucontrol
bind = $mainMod, Space, togglefloating,

# Change Workspace Mode
bind = SUPER_ALT, Space, workspaceopt, allfloat
bind = $mainMod, P, pseudo, # dwindle


# Mainmod + Function keys
bind = $mainMod, F1, exec, $browser
bind = $mainMod, F2, exec, $editor
bind = $mainMod, F3, exec, inkscape
bind = $mainMod, F4, exec, gimp
bind = $mainMod, F5, exec, meld
bind = $mainMod, F6, exec, vlc
bind = $mainMod, F7, exec, virtualbox
bind = $mainMod, F8, exec, $files
bind = $mainMod, F9, exec, evolution
bind = $mainMod, F10, exec, spotify
bind = $mainMod, F11, exec, rofi -show drun
bind = $mainMod, F12, exec, rofi -show drun

# Special Keys
bind = , xf86audioraisevolume, exec, $volume --uo
bind = , xf86audiolowervolume, exec, $volume --down
bind = , xf86audiomute, exec, $volume --toggle
bind = , xf86audioplay, exec, playerctl play-pause
bind = , xf86audionext, exec, playerctl next
bind = , xf86audioprev, exec, playerctl previous
bind = , xf86audiostop, exec, playerctl stop
bind = , xf86monbrightnessup, exec, $brightness --inc
bind = , xf86monbrightnessdown, exec, $brightness --dec

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window and follow to workspace
bind = $mainMod CTRL, 1, movetoworkspace, 1
bind = $mainMod CTRL, 2, movetoworkspace, 2
bind = $mainMod CTRL, 3, movetoworkspace, 3
bind = $mainMod CTRL, 4, movetoworkspace, 4
bind = $mainMod CTRL, 5, movetoworkspace, 5
bind = $mainMod CTRL, 6, movetoworkspace, 6
bind = $mainMod CTRL, 7, movetoworkspace, 7
bind = $mainMod CTRL, 8, movetoworkspace, 8
bind = $mainMod CTRL, 9, movetoworkspace, 9
bind = $mainMod CTRL, 0, movetoworkspace, 10
bind = $mainMod CTRL, bracketleft, movetoworkspace, -1
bind = $mainMod CTRL, bracketright, movetoworkspace, +1

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10
bind = $mainMod SHIFT, bracketleft, movetoworkspacesilent, -1
bind = $mainMod SHIFT, bracketright, movetoworkspacesilent, +1

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1
bind = $mainMod, period, workspace, e+1
bind = $mainMod, comma, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = , mouse:276, movewindow
bindm = , mouse:275, resizewindow
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Group windows 
bind = $mainMod, G, togglegroup
bind = $mainMod, tab, changegroupactive, f

# Switch windows

bind = ALT, Tab, exec, killall -SIGUSR1 .sfwbar-wrapped 




# █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█ █▀█ █░█ █░░ █▀▀ █▀
# ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀ █▀▄ █▄█ █▄▄ ██▄ ▄█
#windowrule = float, file_progress
#windowrule = float, confirm
#windowrule = float, dialog
#windowrule = float, download
#windowrule = float, notification
#windowrule = float, error
#windowrule = float, splash
#windowrule = float, confirmreset
#windowrule = float, title:Open File
#windowrule = float, title:branchdialog
#windowrule = float, Lxappearance
#windowrule = float, Rofi
#windowrule = float, Lxtask
#windowrule = animation none,Rofi
#windowrule = float, viewnior
#windowrule = float, Viewnior
#windowrule = float, feh
#windowrule = float, pavucontrol-qt
#windowrule = float, pavucontrol
#windowrule = float, file-roller

windowrulev2 = float, class:^(wlogout)$
windowrulev2 = center, class:^(wlogout)$
windowrulev2 = size 50% 50%, class:^(wlogout)$



#windowrule = float, title:^(Media viewer)$
#windowrule = float, title:^(Friends List)$
#windowrule = float, title:^(Volume Control)$
#windowrule = float, title:^(Picture-in-Picture)$
#windowrule = size 800 600, title:^(Volume Control)$
#windowrule = float, ^(Rofi)$
windowrule = float, ^(org.gnome.Calculator)$
#windowrule = float, ^(org.gnome.thunar)$
windowrule = float, ^(eww)$
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(nm-connection-editor)$
windowrule = float, ^(blueberry.py)$
windowrule = float, ^(org.gnome.Settings)$
windowrule = float, ^(org.gnome.design.Palette)$
#windowrule = float, ^(Color Picker)$
windowrule = float, ^(Network)$
#windowrule = float, ^(xdg-desktop-portal)$
#windowrule = float, ^(xdg-desktop-portal-gnome)$
#windowrule = float, ^(xdg-desktop-portal-hyprland)$
#windowrule = float, ^(org.freedesktop.impl.portal.desktop.kde)$
#windowrule = center, ^(org.freedesktop.impl.portal.desktop.kde)$

# Remove initial focus from apps
#windowrulev2 = noinitialfocus, class:^(steam)$, title:^(notificationtoasts.*)$, floating:1

# Remove transparancy from video
windowrulev2 = opaque,class:^(google-chrome)$,title:^(Netflix)(.*)$
windowrulev2 = opaque,class:^(google-chrome)$,title:^(.*YouTube.*)$
windowrulev2 = opaque,class:^(firefox)$,title:^(.*YouTube.*)$
windowrulev2 = opaque,class:^(firefox)$,title:^(Netflix)(.*)$
windowrulev2 = opaque,class:^(firefox)$,title:^(Picture-in-Picture)$
windowrulev2 = opaque,class:^(looking-glass-client)$

# Move apps to workspaces
windowrulev2 = workspace 2 silent,class:^(code-url-handler)$
windowrulev2 = workspace 3 silent,class:^(signal)$
windowrulev2 = workspace 3 silent,title:^(WebCord)$
windowrulev2 = workspace 4 silent,class:^(startup-monitor|corectrl)$ # btop
windowrulev2 = workspace 5 silent,class:^(looking-glass-client)$
windowrulev2 = workspace 6 silent,class:^(startup-kitty)$ # Terminal


#windowrulev2 = float,class:^(Steam)$,title:(.*Steam.*)
#windowrulev2 = float,class:^(steam_app_.*)$
#windowrulev2 = workspace 4 silent, class:^(Steam|steam_app_.*)$
#windowrulev2 = workspace 4 silent, title:^(.*Steam[A-Za-z0-9\s]*)$

#windowrulev2 = float,class:^(yad)$

# Hide apps
#windowrulev2 = float, title:^(Firefox — Sharing Indicator|Wine System Tray)$
#windowrulev2 = size 0 0, title:^(Firefox — Sharing Indicator|Wine System Tray)$

# for file open code
windowrulev2 = animation popin, class:^(code)$, title:^(.*Open.*)$
windowrulev2 = float, class:^(code)$, title:^(.*Open.*)$
windowrulev2 = center, class:^(code)$, title:^(.*Open.*)$

# for file save/down Chrome
windowrulev2 = animation popin, class:^(google-chrome)$, title:^(.*File.*)$
windowrulev2 = float, class:^(google-chrome)$, title:^(.*File.*)$
windowrulev2 = center, class:^(google-chrome)$, title:^(.*File.*)$

# for file transfer Progress
windowrulev2 = animation popin, class:^(thunar)$, title:^(.*File.*)$
windowrulev2 = float, class:^(thunar)$, title:^(.*File.*)$
windowrulev2 = center, class:^(thunar)$, title:^(.*File.*)$

# for file replace
windowrulev2 = animation popin, class:^(thunar)$, title:^(.*Operation.*)$
windowrulev2 = float, class:^(thunar)$, title:^(.*Operation.*)$
windowrulev2 = center, class:^(thunar)$, title:^(.*Operation.*)$
windowrulev2 = animation popin, class:^(thunar)$, title:^(.*Confirm.*)$
windowrulev2 = float, class:^(thunar)$, title:^(.*Confirm.*)$
windowrulev2 = center, class:^(thunar)$, title:^(.*Confirm.*)$


# Dolphin File manager
windowrulev2 = unset, class:^(org.kde.dolphin)$,title:^(.*Dolphin.*)$
windowrulev2 = nofullscreenrequest, class:^(org.kde.dolphin)$,title:^(.*Dolphin.*)$
windowrulev2 = float, class:^(org.kde.dolphin)$,title:^(.*Dolphin.*)$
windowrulev2 = size 1100 770, class:^(org.kde.dolphin)$,title:^(.*Dolphin.*)$
windowrulev2 = center, class:^(org.kde.dolphin)$,title:^(.*Dolphin.*)$
#windowrulev2 = move 3000 170, class:^(org.kde.dolphin)$,title:^(.*Dolphin.*)$      


    '';
  }];
}

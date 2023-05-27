{ config, pkgs, ... }:
let
  host = {
    hostName = "nixos";
    mainMonitor = "HDMI-A-1";
    secondMonitor = "DP-1";
  };
  modifier = "Mod4";
in
# I3 configuration to use with KDE
{
  # We add this file to disable the systemBoot option to replace KNWM with i3
  home.file.".config/startkderc" = {
    source = ./startkderc;
  };

  home.packages = with pkgs; [ i3lock-fancy maim ];

  xsession.enable = true;

  # Disable the command set by the i3 service of home manager
  xsession.windowManager.command = pkgs.lib.mkForce ''test -n "$1" && eval "$@"'';

  xsession.windowManager.i3 = {
    enable = true;

    config = {

      inherit modifier;

      fonts = {
        names = [ "HackNerdFont" ];
        style = "Bold Semi-Condensed";
        size = 12.0;
      };


      focus.followMouse = false;

      floating.border = 1;

      gaps = {
        inner = 6;
        outer = 14;
        smartBorders = "on";
      };

      assigns = {
        "3" = [{ class = "^Slack$"; } { class = "^webcord$"; }];
        "2" = [{ class = "^firedragon$"; }];
      };

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "${host.mainMonitor}";
        }
        {
          workspace = "2";
          output = "${host.secondMonitor}";
        }
        {
          workspace = "3";
          output = "${host.secondMonitor}";
        }
      ];

      keybindings = pkgs.lib.mkOptionDefault {
        "${modifier}+u" = "border none";
        "${modifier}+n" = "border pixel 1";

        "${modifier}+t" = "exec kitty";
        "${modifier}+Shift+a" = "split toggle";
        "${modifier}+Ctrl+l" = "exec i3lock-fancy -t 'Ask for permission to unlock !' -- maim --quiet";
        "${modifier}+Ctrl+y" = "exec --no-startup-id systemctl --user restart polybar";
        "${modifier}+Ctrl+s" = "exec --no-startup-id ~/.screenlayout/script.sh";
        "${modifier}+p" = "exec --no-startup-id picom --experimental-backends -b";
        "${modifier}+Ctrl+t" = "exec --no-startup-id pkill picom ";
        "${modifier}+Shift+e" = "exec qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1";
        "${modifier}+Shift+f" = "exec flameshot gui";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+b" = "move container to workspace back_and_forth; workspace back_and_forth";

        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";

        "${modifier}+s" = "layout stacking";
        "${modifier}+z" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+q" = "kill";
        "${modifier}+d" = "exec dolphin";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

        "${modifier}+Ctrl+c" = "move scratchpad";
        "${modifier}+c" = "scratchpad show";

        "${modifier}+Ctrl+Right" = "workspace next";
        "${modifier}+Ctrl+Left" = "workspace prev";

        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+6" = "workspace 6";
        "${modifier}+7" = "workspace 7";
        "${modifier}+8" = "workspace 8";

        "${modifier}+Ctrl+x" = "move workspace to output next";

        "${modifier}+Ctrl+1" = "move container to workspace 1";
        "${modifier}+Ctrl+2" = "move container to workspace 2";
        "${modifier}+Ctrl+3" = "move container to workspace 3";
        "${modifier}+Ctrl+4" = "move container to workspace 4";
        "${modifier}+Ctrl+5" = "move container to workspace 5";
        "${modifier}+Ctrl+6" = "move container to workspace 6";
        "${modifier}+Ctrl+7" = "move container to workspace 7";
        "${modifier}+Ctrl+8" = "move container to workspace 8";

        "${modifier}+Shift+1" = "move container to workspace 1; workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2; workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3; workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4; workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5; workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6; workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7; workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8; workspace 8";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";
        "${modifier}+r" = ''mode "resize"'';
      };

      menu = "${pkgs.plasma-workspace}/bin/krunner";

      defaultWorkspace = "workspace 1";

      workspaceAutoBackAndForth = true;

      startup = [
        {
          command = ''pkill "ksplashqml"'';
          always = true;
          notification = false;
        }

      ];

      bars = [ ];

      terminal = "kitty";
    };

    extraConfig = ''
      title_align center

      ####################################
      ## Specific windows configuration ##
      ####################################

      for_window [window_role="pop-up"] floating enable
      for_window [window_role="task_dialog"] floating enable

      for_window [class="GParted"] floating enable border pixel 1
      for_window [class="Nitrogen"] floating enable sticky enable border pixel 1
      for_window [class="qt5ct"] floating enable sticky enable border pixel 1
      for_window [class="Qtconfig-qt4"] floating enable sticky enable border pixel 1
      for_window [class="Simple-scan"] floating enable border pixel 1
      for_window [class="yakuake"] floating enable
      for_window [class="systemsettings"] floating enable
      for_window [class="plasmashell"] floating enable;
      for_window [class="Plasma"] floating enable; border none
      for_window [class="krunner"] floating enable; border none
      for_window [class="Kmix"] floating enable; border none
      for_window [class="Klipper"] floating enable; border none
      for_window [class="Plasmoidviewer"] floating enable; border none
      for_window [class="(?i)*nextcloud*"] floating disable
      for_window [class="plasmashell" window_type="notification"] border none, move position 80ppt 10ppt
      for_window [class="plasmashell" window_type="dialog"] floating enable, border pixel 1, resize set 400 300
      for_window [class="ksplashqml"] kill; border pixel 1

      for_window [title="plasma-desktop"] floating enable; border none
      for_window [title="win7"] floating enable; border none
      for_window [title=".*Desktop.*Plasma.*"] kill; border pixel 1
      for_window [title="i3_help"] floating enable sticky enable border pixel 1

      no_focus [class="plasmashell" window_type="notification"]
      no_focus [class="plasmashell" window_type="on_screen_display"]
    '';
  };
}
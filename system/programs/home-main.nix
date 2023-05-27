{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.main.user.enable {
  home-manager.users.${config.main.user.username} = {
    
    imports = [
      ./i3-plasma.nix
    ];

    programs = {
      git = {
        enable = true;
        # Git config
        userName = "${config.main.user.github.username}";
        userEmail = "${config.main.user.github.email}";
      };

      kitty = {
        enable = true;
        settings = {
          background_opacity = lib.mkDefault "0";
          confirm_os_window_close = "0";
          cursor_shape = "beam";
          enable_audio_bell = "no";
          hide_window_decorations = "yes";
          update_check_interval = "0";
        };
        font.name = "Jetbrains Mono Nerd Font";
        theme = "Monokai Soda";
      };

      mangohud = {
        enable = true;
        # Mangohud config
        settings = {
          arch = true;
          background_alpha = "0.05";
          cpu_color = "FFFFFF";
          cpu_temp = true;
          engine_version = true;
          engine_color = "FFFFFF";
          font_size = 20;
          fps = true;
          fps_limit = "120+60+0";
          frame_timing = 0;
          gamemode = true;
          gl_vsync = 0;
          gpu_color = "FFFFFF";
          gpu_temp = true;
          no_small_font = true;
          offset_x = 50;
          position = "top-right";
          round_corners = 8;
          vram = true;
          vulkan_driver = true;
          toggle_fps_limit = "Ctrl_L+Shift_L+F1";
          vsync = 1;
        };
      };

      zsh = {
        enable = true;
        # Enable firefox wayland
        profileExtra = "export MOZ_ENABLE_WAYLAND=1";

        # Install powerlevel10k
        plugins = with pkgs; [
          {
            name = "powerlevel10k";
            src = zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-nix-shell";
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = zsh-nix-shell;
          }
        ];

        initExtra = ''eval "$(direnv hook zsh)"'';
      };

      # Install gnome extensions using firefox
      #firefox.enableGnomeExtensions = true;
    };

    home.file = {
      # Add zsh theme to zsh directory
      ".config/zsh/zsh-theme.zsh" = {
        source = ../configs/zsh-theme.zsh;
        recursive = true;
      };

      # Add proton-ge-updater script to zsh directory
      ".config/zsh/proton-ge-updater.sh" = {
        source = ../scripts/proton-ge-updater.sh;
        recursive = true;
        force = true;
      };

      # Add steam-library-patcher to zsh directory
      ".config/zsh/steam-library-patcher.sh" = {
        source = ../scripts/steam-library-patcher.sh;
        recursive = true;
        force = true;
      };

      # Add arkenfox user.js
      ".mozilla/firefox/privacy/user.js" = lib.mkIf config.firefox-privacy.enable {
        source = "${(config.nur.repos.slaier.arkenfox-userjs.overrideAttrs (oldAttrs: {
          installPhase = ''
            cat ${../configs/firefox-user-overrides.js} >> user.js
            mkdir -p $out
            cp ./user.js $out/user.js
          '';
        }))}/user.js";
        recursive = true;
        force = true;
      };

      # Set firefox to privacy profile
      ".mozilla/firefox/profiles.ini" = lib.mkIf config.firefox-privacy.enable {
        source = ../configs/firefox-profiles.ini;
        recursive = true;
        force = true;
      };

      # Add noise suppression microphone
      ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
        source = ../configs/pipewire.conf;
        recursive = true;
        force = true;
      };

      # Add btop config
      ".config/btop/btop.conf" = {
        source = ../configs/btop.conf;
        recursive = true;
        force = true;
      };

      # Add kitty session config
      ".config/kitty/kitty.session" = {
        source = ../configs/kitty.session;
        recursive = true;
        force = true;
      };

      # Add kitty task managers session config
      ".config/kitty/kitty-task-managers.session" = {
        source = ../configs/kitty-task-managers.session;
        recursive = true;
        force = true;
      };

      # Add adwaita steam skin
      ".local/share/Steam/steamui/libraryroot.custom.css" = {
        source = "${(pkgs.callPackage ../programs/self-built/adwaita-for-steam {})}/build/libraryroot.custom.css";
        recursive = true;
        force = true;
      };

      # Enable steam beta
      ".local/share/Steam/package/beta" = lib.mkIf config.steam.beta.enable {
        text = "publicbeta";
        recursive = true;
        force = true;
      };
      # Add custom mangohud config for CS:GO
      ".config/MangoHud/csgo_linux64.conf" = {
        text = ''
          background_alpha=0
          cpu_color=FFFFFF
          cpu_temp
          engine_color=FFFFFF
          font_size=20
          fps
          fps_limit=0+144
          frame_timing=0
          gamemode
          gl_vsync=0
          gpu_color=FFFFFF
          gpu_temp
          no_small_font
          offset_x=50
          position=top-right
          toggle_fps_limit=Ctrl_L+Shift_L+F1
          vsync=1
        '';
        recursive = true;
        force = true;
      };
      # Add custom mangohud config for CS2
      ".config/MangoHud/wine-cs2.conf" = {
        text = ''
          background_alpha=0
          cpu_color=FFFFFF
          cpu_temp
          engine_color=FFFFFF
          font_size=20
          fps
          fps_limit=0+144
          frame_timing=0
          gamemode
          gl_vsync=0
          gpu_color=FFFFFF
          gpu_temp
          no_small_font
          offset_x=50
          position=top-right
          toggle_fps_limit=Ctrl_L+Shift_L+F1
          vsync=1
        '';
        recursive = true;
      };
    };
  };
}

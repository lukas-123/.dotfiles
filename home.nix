{ config, pkgs, ... }:

let
  configHome = ~/dotfiles;
in {
  home.packages =
    [
      # Desktop programs
      pkgs.alacritty
      pkgs.evince
      pkgs.firefox
      pkgs.gnome3.gnome-terminal
      pkgs.jetbrains.idea-community
      pkgs.keepassxc
      pkgs.lean
      pkgs.nextcloud-client
      pkgs.tdesktop
      pkgs.thunderbird

      # Developer utilities
      pkgs.cmake
      pkgs.rustup
      pkgs.texlive.combined.scheme-full

      # Command line utilities
      pkgs.ffmpeg
      pkgs.thefuck
      pkgs.tree
      (pkgs.vimHugeX.override {
          python = pkgs.python3;
          ruby = pkgs.ruby;
      })
      pkgs.xclip
      pkgs.xorg.xprop
      pkgs.youtube-dl
      pkgs.gnupg

      # Window manager
      pkgs.base16-builder
      pkgs.gnome3.networkmanagerapplet
      pkgs.hicolor-icon-theme
      pkgs.i3
      pkgs.i3lock
      pkgs.i3blocks
      pkgs.rofi
      pkgs.glibcLocales

      # Fonts
      pkgs.fira
      pkgs.fira-code
      pkgs.inconsolata
      pkgs.powerline-fonts
      pkgs.lmodern
      pkgs.lmmath
      
    ];

    fonts.fontconfig.enable = true;

    nixpkgs.overlays = [
    ];

    home.sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "vim";
      I3BLOCKS_SCRIPT_DIR = "${pkgs.i3blocks}/libexec/i3blocks/";
      LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };

    home.keyboard = {
      layout = "de";
      options = [ "lv3:caps_switch" ];
    };

    xdg = {
      enable = true;
      configFile."i3/i3blocks".source = "${configHome}/i3/i3blocks";
      configFile."alacritty/alacritty.yml".source = "${configHome}/alacritty.yml";
      configFile."mimeapps.list".text=''
      [Default Applications]
      application/pdf=evince.desktop;
      '';
    };

    xresources.extraConfig = (builtins.readFile (configHome + /Xresources));

    home.file = {
      ".profile".source = "${configHome}/profile";
      ".zprofile".source = "${configHome}/zprofile";
      ".zshenv".source = "${configHome}/zshenv";
      ".vimrc".source = "${configHome}/vimrc";
      ".vim/colors/my-base16.vim".source = "${configHome}/colors/my-base16.vim";
      ".latexmkrc".text = "$pdf_previewer = 'start evince';\n";
    };

    services.network-manager-applet.enable = true;

    services.nextcloud-client.enable = true;

    services.gpg-agent.enable = true;

    gtk = {
      enable = true;
      font = {
        name = "DejaVu Sans 11";
        package = pkgs.dejavu_fonts;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome3.adwaita-icon-theme;
      };
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
    };

    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraConfig = (builtins.readFile (configHome + /i3/config));
        config = null;
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      sessionVariables = {
        ANTIGEN_DIR = "${pkgs.antigen}/share/antigen/";
      }; 
      initExtra = (builtins.readFile (configHome + /zshrc)) + ''
        vim() {
          nix-shell -p python37Packages.pynvim --run "vim $@"
        }
      '';
    };

    programs.git = {
      enable = true;
      userName = "Lukas Stevens";
      userEmail = "mail@lukas-stevens.de";
    };

    programs.home-manager = {
      enable = true;
      path = "https://github.com/rycee/home-manager/archive/master.tar.gz";
    };

    nixpkgs.config.allowUnfree = true;

    programs.vscode = {
      enable = true;
    };

  }



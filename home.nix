# Link this file to ~/.config/nixpkgs/home.nix to use it with home-manager

{ config, pkgs, ... }:

let
  configHome = ~/dotfiles;

  pkgs-master = import (builtins.fetchTarball {
      name = "nixpkgs-master";
      url = https://github.com/NixOS/nixpkgs/archive/a2ee5cbb0513ee0623bc93aa1af74f172080ce6b.tar.gz;
      # Hash obtained using `nix-prefetch-url --unpack <url>`
      sha256 = "18f09wck7h89y202hhf67iwqd6i6bhd47pz19mbc4q682x77q6fy";
    }) {};
  nur = import (builtins.fetchTarball {
      name = "nur";
      url = https://github.com/nix-community/NUR/archive/01aa1f5755d2c719320d128b021cd0926ab08ca0.tar.gz;
      sha256 = "1sy3m58jjgak1gqpbhnlnld57gk4q3zxq4js0nkjb2n515fi6r14";
    }) { inherit pkgs; };
in {
  programs.home-manager = {
    enable = true;
    path = "https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz";
  };

  home.packages = with pkgs; [
    # Desktop programs
    evince
    gnome3.gnome-terminal
    isabelle
    # isabelle-devel
    keepassxc
    lean
    nextcloud-client
    pkgs-master.signal-desktop
    pkgs-master.tdesktop
    thunderbird

    # Developer utilities
    cmake
    ruby
    rustup
    stack
    texlive.combined.scheme-full

    # Command line utilities
    acpi
    ffmpeg-full
    rename
    thefuck
    tree
    youtube-dl
    gnupg

    # Window manager
    base16-builder
    glibcLocales
    gnome3.networkmanagerapplet
    hicolor-icon-theme
    playerctl
    swaylock
    swayidle
    wl-clipboard
    mako
    wofi 
    qt5.qtwayland

    # Fonts
    fira
    fira-code
    font-awesome
    inconsolata
    league-of-moveable-type
    lmodern
    lmmath
    powerline-fonts
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    TERMINAL = "alacritty";
    EDITOR = "nvim";
    LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  xdg = {
    enable = true;
    configFile."nvim/colors/my-base16.vim".source = "${configHome}/colors/my-base16.vim";
  };

  home.file = {
    ".profile".source = "${configHome}/profile";
    ".zprofile".source = "${configHome}/zprofile";
    ".latexmkrc".text = "$pdf_previewer = 'start evince';\n";
    ".XCompose".source = "${configHome}/XCompose";
    ".vscode/argv.json".text = ''
      { "enable-crash-reporter": false }
    '';
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

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      '';
    config = import (configHome + /sway/settings.nix) pkgs;
  };

  nixpkgs.overlays = [ (self: super: {
    waybar = super.waybar.override { pulseSupport = true; };
  })];

  programs.waybar = {
    enable = true;
    settings = import (configHome + /sway/waybar-settings.nix) pkgs;
  };

  programs.alacritty = {
    enable = true;
    settings = import (configHome + /alacritty-settings.nix);
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    extensions = with nur.repos.rycee.firefox-addons; [
      ublock-origin
      umatrix
      keepassxc-browser
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Lukas Stevens";
    userEmail = "mail@lukas-stevens.de";
    extraConfig = {
      pull.rebase = true;
    };
  };

  programs.mercurial = {
    enable = true;
    userName = "Lukas Stevens";
    userEmail = "mail@lukas-stevens.de";
    extraConfig = '' 
      [extensions]
      rebase = 
      strip =
      evolve = ${pkgs.python37Packages.hg-evolve}/lib/python3.7/site-packages/hgext3rd/evolve/__init__.py
      topic = ${pkgs.python37Packages.hg-evolve}/lib/python3.7/site-packages/hgext3rd/topic/__init__.py
    '';
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = true;
    extraConfig = builtins.readFile (configHome + /vimrc);
    plugins =
      let
        cyp-syntax = pkgs.vimUtils.buildVimPlugin {
          pname = "cyp-syntax";
          version = "2019-11-30";
          src = pkgs.fetchFromGitHub {
            owner = "HE7086";
            repo = "cyp-vim-syntax";
            rev = "a13fc823a490fca1150d36d449594ce0e0a33a79";
            sha256 = "1wadkvn4vkck9c11r2s33747qx3p1iwzrxfxzlchlw0vc5spr2f7";
          };
        };
      in
        with pkgs.vimPlugins; [
          vim-nix
          nerdtree
          rust-vim
          command-t
          deoplete-nvim
          ale
          { plugin = vimtex; config = "let g:tex_flavor = 'latex'"; }
          haskell-vim
          cyp-syntax
        ];
  };

  programs.ssh = {
    enable = true;
    extraConfig = "AddKeysToAgent yes";
  };

  programs.vscode = {
    enable = true;
    package = pkgs-master.vscode;
    userSettings = {
      "telemetry.enableTelemetry" = false;
      "update.mode" = "manual";
      #"isabelle.home" = "${isabelle-devel}";
      "haskell.indentationRules.enabled" = false;
      "haskell.trace.server" = "messages";
      "editor.fontFamily" = "Inconsolata for Powerline, monospace";
      "extensions.autoUpdate" = false;
      "window.zoomLevel" = 1;
    };
    keybindings = [
      { key = "ctrl+`"; command = "terminal.focus"; }
      { key = "ctrl+`"; command = "workbench.action.focusActiveEditorGroup"; when = "terminalFocus"; }
      { key = "ctrl+h"; command = "workbench.action.navigateLeft"; }
      { key = "ctrl+l"; command = "workbench.action.navigateRight"; }
      { key = "ctrl+j"; command = "workbench.action.navigateDown"; }
      { key = "ctrl+k"; command = "workbench.action.navigateUp"; }
    ];
    extensions =
      let
        vsliveshare = pkgs-master.callPackage ./nix/vsliveshare {
          mktplcRef = {
            name = "vsliveshare";
            publisher = "ms-vsliveshare";
            version = "1.0.3121";
            sha256 = "0jmbp2nph786n6gzd58yhmx22p2h87s98xq4shjn42blrkcgnb7z";
          };
        };

        hoogle = pkgs-master.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "hoogle-vscode";
            publisher = "jcanero";
            version = "0.0.7";
            sha256 = "0ndapfrv3j82792hws7b3zki76m2s1bfh9dss1xjgcal1aqajka1";
          };
        };

        haskell-language-server = pkgs-master.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "haskell";
            publisher = "haskell";
            version = "1.2.0";
            sha256 = "0vxsn4s27n1aqp5pp4cipv804c9cwd7d9677chxl0v18j8bf7zly";
          };
        };

        cyp = pkgs-master.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-cyp";
            publisher = "jonhue";
            version = "1.1.0";
            sha256 = "19pyn7l6hjl4mrvqfd137mi06k33glb7xiq37kkqannzhbh7did3";
          };
        };
      in [
        cyp
        haskell-language-server
        hoogle
        pkgs-master.vscode-extensions.justusadam.language-haskell
        pkgs-master.vscode-extensions.vscodevim.vim
        vsliveshare
      ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      ANTIGEN_DIR = "${pkgs.antigen}/share/antigen/";
    }; 
    initExtra = (builtins.readFile (configHome + /zshrc));
  };
}



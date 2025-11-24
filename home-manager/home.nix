# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "mond";
    homeDirectory = "/home/mond";
  };

  # Enable home-manager and git
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mond/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  services.ssh-agent.enable = true;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        cursorline = true;
        gutters = [
          "diagnostics"
          "line-numbers"
        ];
        auto-save = true;

        file-picker = {
          hidden = true;
        };
        soft-wrap = {
          enable = true;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
      keys = {
        normal = {
          C-j = "half_page_down";
          C-k = "half_page_up";
        };
      };
    };

    languages.language = [
      {
        name = "nix";
        auto-format = false;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
      {
        name = "rust";
        auto-format = false;
      }
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "herecomesthemoon@protonmail.com";
    userName = "Mond";
    extraConfig = {
      init.defaultBranch = "main";
    };
    delta = {
      enable = true;
    };
    aliases = {
      a = "add";
      aa = "add -A";
      c = "commit -v";
      ca = "commit --amend -v";
      d = "diff";
      p = "push";
      s = "status -s";
      lg = "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "fira-code";
      size = 14;
    };
    shellIntegration.enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    # fzf_configure_bindings ensures that ctrl+r uses the fzf fish plugin properly
    # See https://github.com/PatrickF1/fzf.fish/wiki/Troubleshooting
    shellInitLast = "tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Round --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Sparse --icons='Few icons' --transient=No && fzf_configure_bindings";
    plugins = [
      {
        # powerlevel 10k look
        name = "tide";
        src = pkgs.fishPlugins.tide;
      }
      {
        # 'z' command to switch dirs
        name = "z";
        src = pkgs.fishPlugins.z;
      }
      {
        # automatic parens and quotes
        name = "autopair";
        src = pkgs.fishPlugins.autopair;
      }
      {
        # CTRL+ALT+(F/R/P/V) to fzf search
        # files / history / processes/ env variables respectively
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish;
      }
    ];
    shellAliases = {
      h = "hx";
      g = "git";
    };
  };
}

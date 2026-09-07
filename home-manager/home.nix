{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  username = "dychen";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/zoxide.nix
    ./programs/git.nix
    ./programs/zathura.nix
    ./programs/btop.nix
    ./programs/fzf.nix
    ./programs/direnv.nix
    ./programs/bat.nix
    ./programs/yazi.nix
    ./services/gpg-agent.nix
  ];
  home = {
    inherit username;
    packages = with pkgs-unstable; [
      home-manager
      eza
      docker
      gnupg
      dust
      gping
      curl
      fd
      git-lfs
      gnugrep
      graphviz
      gum
      gzip
      imagemagick
      jq
      lsof
      neovim
      nodejs
      ripgrep
      rsync
      sqlite
      tree
      time
      tlrc
      wget
      unzip
      cargo
      tree-sitter
      lazygit
      ttyper
      go
      shellcheck
      uv
      typescript
      gh
      yarn
      duckdb
      coursier
      lsix
      poetry
      nixfmt
      google-cloud-sdk
      ffmpeg
      pulumi
      pulumiPackages.pulumi-nodejs
      claude-code
      cursor-cli
    ];

    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";
    file = {
      ".config/nvim".source = link "/Users/${username}/my-home-manager/nvim";
      ".p10k.zsh".source = link "/Users/${username}/my-home-manager/terminal/.p10k.zsh";
      ".markdownlint-cli2.yaml".text = ''
        config:
          MD013: false
      '';
    };
  };
}

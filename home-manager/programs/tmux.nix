{ pkgs, pkgs-unstable, ... }:
let
  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-super-fingers";
    version = "unstable-2026-04-24";
    src = pkgs.fetchFromGitHub {
      owner = "artemave";
      repo = "tmux_super_fingers";
      rev = "523dc9b7a79f1ceb8d9be72e22c263c4a7cd3bdf";
      sha256 = "sha256-GiOkSADuWz19ndsVlKiKatPnplUpmukoZTPakIXWqF0=";
    };
  };
  tmux-rose-pine = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "rose-pine";
    version = "unstable-2026-07-23";
    rtpFilePath = "rose-pine.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "tmux";
      rev = "43d03507427ac3ad92cadfdf0d1307b8b0ff5128";
      sha256 = "sha256-niFXeZRyJ26ukNxEgQjzGbNPPQPtpoe5/7cF/9VGOTk=";
    };
  };
  tmux-mode-indicator = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "mode-indicator";
    version = "unstable-2024-08-25";
    src = pkgs.fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "tmux-mode-indicator";
      rev = "7027903adca37c54cb8f5fa99fc113b11c23c2c4";
      sha256 = "sha256-SAzsn4LoG8Ju5t13/U3/ctlJQPyPgv2FjpPkWSeKbP0=";
    };
  };
  vim-tmux-navigator = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "vim-tmux-navigator";
    version = "unstable-2026-01-26";
    rtpFilePath = "vim-tmux-navigator.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "christoomey";
      repo = "vim-tmux-navigator";
      rev = "e41c431a0c7b7388ae7ba341f01a0d217eb3a432";
      sha256 = "sha256-efqiRffnidYx+qjgsHyWshCFWgZp/ZrHl+Clt04pfpM=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    package = pkgs-unstable.tmux;
    plugins = with pkgs-unstable.tmuxPlugins; [
      fingers
      {
        plugin = tmux-super-fingers;
        extraConfig = "set -g @super-fingers-key f";
      }
      {
        plugin = tmux-rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'main' # Options are 'main', 'moon' or 'dawn'
          set -g @rose_pine_host 'on' # Enables hostname in the status bar
          set -g @rose_pine_directory 'on' # Turn on the current folder component in the status bar
          set -g @rose_pine_date_time '%d/%m/%y %H:%M' # It accepts the date UNIX command format (man date for info)
          set -g @rose_pine_user 'on' # Turn on the username component in the statusbar
          set -g @rose_pine_bar_bg_disable 'on'
          set -g @rose_pine_bar_bg_disabled_color_option 'default'
          set -g @rose_pine_show_current_program 'on' # Forces tmux to show the current running program as window name
          set -g @rose_pine_show_pane_directory 'on' # Forces tmux to show the current directory as
          set -g @rose_pine_field_separator '  ' # Default is two-space-padded, but can be set to anything
          set -g @rose_pine_status_left_prepend_section '#{tmux_mode_indicator}  '
        '';
      }
      tmux-mode-indicator
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      continuum
      better-mouse-mode
      yank
      vim-tmux-navigator
    ];
    prefix = "C-a";
    extraConfig = ''
      set -s escape-time 10                     # faster command sequences
      set -sg repeat-time 600                   # increase repeat timeout
      set -s focus-events on

      set -q -g status-utf8 on                  # expect UTF-8 (tmux < 2.2)
      setw -q -g utf8 on

      set -g history-limit 5000                 # boost history

      set -g base-index 1           # start windows numbering at 1
      setw -g pane-base-index 1     # make pane numbering consistent with windows

      setw -g automatic-rename on   # rename window to reflect current program
      set -g renumber-windows on    # renumber windows when a window is closed

      set -g set-titles on          # set terminal title
      set -g set-titles-string "#W"

      set -g display-panes-time 800 # slightly longer pane indicators display time
      set -g display-time 1000      # slightly longer status messages display time

      set -g status-interval 10     # redraw status line every 10 seconds

      set -g monitor-activity on
      set -g visual-activity off
      bind C-c new-session

      # find session
      bind C-f command-prompt -p find-session 'switch-client -t %%'

      # session navigation
      bind BTab switch-client -l  # move to last session

      # split current window horizontally
      bind _ split-window -h -c "#{pane_current_path}"
      # split current window vertically
      bind - split-window -v -c "#{pane_current_path}"

      # open new window on cwd
      bind-key c new-window -c "#{pane_current_path}"

      # pane navigation
      bind -r h select-pane -L  # move left
      bind -r j select-pane -D  # move down
      bind -r k select-pane -U  # move up
      bind -r l select-pane -R  # move right
      bind > swap-pane -D       # swap current pane with the next one
      bind < swap-pane -U       # swap current pane with the previous one

      # pane resizing
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      # window navigation
      unbind n
      unbind p
      bind -r C-h previous-window # select previous window
      bind -r C-l next-window     # select next window
      bind Tab last-window        # move to last active window

      bind Enter copy-mode # enter copy mode

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send -X cancel
      bind -T copy-mode-vi H send -X start-of-line
      bind -T copy-mode-vi L send -X end-of-line

      bind b list-buffers     # list paste buffers
      bind p paste-buffer -p  # paste from the top paste buffer
      bind P choose-buffer    # choose which buffer to paste from

      set -g mouse on
      set-option -g status-position top
      set -g status-keys vi
      set -g mode-keys vi

      set -g default-terminal "tmux-256color"
      set-option -a terminal-features ',xterm-256color:RGB'

      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      %if #{==:#{TMUX_PROGRAM},}
        run 'TMUX_PROGRAM="''$(LSOF=''$(PATH="''$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" command -v lsof); ''$LSOF -b -w -a -d txt -p #{pid} -Fn 2>/dev/null | perl -n -e "if (s/^n((?:.(?!dylib$|so$))+)$/\1/g && s/(?:\s+\([^\s]+?\))?$//g) { print; exit } } exit 1; {" || readlink "/proc/#{pid}/exe" 2>/dev/null || printf tmux)"; "''$TMUX_PROGRAM" -S #{socket_path} set-environment -g TMUX_PROGRAM "''$TMUX_PROGRAM"'
      %endif

      %if #{==:#{TMUX_SOCKET},}
        run '"''$TMUX_PROGRAM" -S #{socket_path} set-environment -g TMUX_SOCKET "#{socket_path}"'
      %endif

      %if #{==:#{TMUX_CONF},}
        run '"''$TMUX_PROGRAM" set-environment -g TMUX_CONF ''$(for conf in "''$HOME/.tmux.conf" "''$XDG_CONFIG_HOME/tmux/tmux.conf" "''$HOME/.config/tmux/tmux.conf"; do [ -f "''$conf" ] && printf "%s" "''$conf" && break; done)'
      %endif

      # Bind keys to split windows while retaining the current path
      bind-key % split-window -h -c "#{pane_current_path}"
      bind-key '"' split-window -v -c "#{pane_current_path}"

      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      set -g extended-keys on
      set -g extended-keys-format csi-u
      set -as terminal-features ',xterm*:extkeys'
    '';
  };
}

if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_prompt
  powerline-shell --shell bare $status
end
export PATH="$HOME/.cargo/bin:$HOME/.emacs.d/bin:$PATH"

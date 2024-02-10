#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell --packages bash fish jq git gh cacert
#! nix-shell -I https://github.com/NixOS/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz

# This script cleans up commit histories of all repositories of a Github user.

fish -c "$(cat <<'END_HEREDOC'
    echo hello world
    set --show argv 
END_HEREDOC
)" isnt  iesnti eisnti
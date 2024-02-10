#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell --packages bash fish jq git gh cacert
#! nix-shell -I https://github.com/NixOS/nixpkgs/archive/057f9aecfb71c4437d2b27d3323df7f93c010b7e.tar.gz

# This script cleans up commit histories of all repositories of a Github user.

fish --private --no-config --command "$(cat <<'END_HEREDOC'

set PATH (string split ":" $argv[1])
set argv $argv[2..]

set options (fish_opt -s h -l help)
argparse --stop-nonopt $options -- $argv

if set --query _flag_help
    echo '
Usage: ./clean-my-commit-history.sh [-h | --help] [REPO_URLS...]

Clean up commit histories of the provided remote git repositories. The user must have full access to the repositories.
Prompts the user to log in with a Github account if no repository URLs are provided.

Options:
    -h, --help  Show this help message and exit.
'
    exit
end

if test (count $argv) != 0
    set repo_urls $argv
else
    echo "You'll now be prompted to login to Github to fetch the URLs of your repositories.\n"
    fish -i -c "gh auth login" &&
    set repo_urls (
        gh repo list --json url --limit 1000000 |
        jq -r '.[] | .url'
    )
    echo setn
end
and echo ahha

for repo_url in $repo_urls
    set -x repo_url $repo_url
    fish -c '
        set repo_dir (mktemp -d)
        git clone -q $repo_url $repo_dir
        cd $repo_dir
        git checkout -q --orphan temp_branch
        git add -A
        git commit -qm "Initial commit"
        git branch -qD main
        git branch -qm main
        git push -qf origin main
        rm -rf $repo_dir
        echo "Finished cleaning $repo_url"
    ' &
end

wait
echo "Finished cleaning all repositories."

END_HEREDOC
)" "$PATH" "$@"
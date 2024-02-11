set PATH (string split ":" $argv[1])
set argv $argv[2..]

set options (fish_opt -s h -l help)
argparse --stop-nonopt $options -- $argv

if set --query _flag_help
    echo -e "
Usage: ./clean-my-commit-history.sh [-h | --help] [REPO_URLS...]

Clean up commit histories of the provided remote git repositories. The user 
must have full access to the repositories. If no repository URLs are provided,
you'll be prompted to log in with a Github account...

and \033[1mALL OF YOUR REPOSITORIES' COMMIT HISTORY WILL BE DELETED!!! \033[0m
"
    exit
end

if test (count $argv) != 0
    set repo_urls $argv
else
    echo -e "\nYou'll now be prompted to login with Github to get a list of your repositories."
    sleep 2
    echo -e "\033[1m\n !!! THIS ACTION WILL DELETE ALL OF YOUR REPOSITORIES' COMMIT HISTORY !!! \033[0m\n"
    sleep 5
    gh auth login
    set repo_urls (
        gh repo list --json url --limit 1000000 |
        jq -r '.[] | .url'
    )
end

for repo_url in $repo_urls
    set -x repo_url $repo_url
    fish --no-config -c '
        echo "Cleaning $repo_url..."
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
echo -e "\nDone."
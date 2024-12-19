#!/bin/bash

# Ensure the repository is clean before running
if [[ -n $(git status --porcelain) ]]; then
    echo "Please commit or stash your changes before running this script."
    exit 1
fi

# Iterate through each commit this year
for commit in $(git log --since="Jan 1 2024" --pretty=format:"%H"); do
    echo "Checking commit: $commit"
    # Checkout the commit
    git checkout $commit > /dev/null 2>&1

    # Try to evaluate the attribute
    result=$(nix eval --json '.#nixosConfigurations.GLaDOS.config.stylix.base16Scheme')
    if [[ $? -eq 0 ]]; then
        echo "Commit: $commit -> $result"
    else
        echo "Commit: $commit -> Evaluation failed"
    fi
done

# Checkout back to the original branch
git checkout - > /dev/null 2>&1

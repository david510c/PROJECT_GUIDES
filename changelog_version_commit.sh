#!/bin/bash

# Path to the CHANGELOG.md file
CHANGELOG_FILE="CHANGELOG.md"

# Check if the CHANGELOG file exists
if [[ ! -f $CHANGELOG_FILE ]]; then
    echo "Error: $CHANGELOG_FILE not found."
    exit 1
fi

# Extract the most recent version number using regex pattern for ## [X.Y.Z] format
# Skip the "Unreleased" section
VERSION=$(grep -E "^## \[\d+\.\d+\.\d+\]" "$CHANGELOG_FILE" | head -n 1 | sed -E 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/')

if [[ -z $VERSION ]]; then
    echo "Error: Could not extract version from $CHANGELOG_FILE."
    exit 1
fi

# Extract the summary line that follows the version heading
# Look for the line starting with "**Summary**:" after the version heading
SUMMARY=$(awk -v ver="## [$VERSION]" 'BEGIN{found=0} $0 ~ ver {found=1; next} found==1 && $0 ~ /^\*\*Summary\*\*:/ {print substr($0, index($0, ":")+2); exit}' "$CHANGELOG_FILE")

# If summary not found, try to extract from the first few lines after the version heading
if [[ -z $SUMMARY ]]; then
    SUMMARY=$(awk -v ver="## [$VERSION]" 'BEGIN{found=0; count=0} $0 ~ ver {found=1; next} found==1 {count++; if (count==2 && length($0)>5) {print $0; exit}}' "$CHANGELOG_FILE")
    # Clean up the summary if it's not already clean
    SUMMARY=$(echo "$SUMMARY" | sed -E 's/^\*\*Summary\*\*: *//')
fi

if [[ -z $SUMMARY ]]; then
    echo "Warning: Could not extract summary from $CHANGELOG_FILE."
    echo "You will need to provide a commit message manually."
fi

# Extract branch name (using version as default)
BRANCH_NAME="release-$VERSION"

# Show the extracted information and confirm with user
echo "Found in $CHANGELOG_FILE:"
echo "Version: $VERSION"
echo "Summary: $SUMMARY"
echo "Branch: $BRANCH_NAME"
echo

# Confirm version
read -p "Is this the version you want to tag? (y/n): " CONFIRM_VERSION
if [[ $CONFIRM_VERSION != "y" ]]; then
    read -p "Enter the correct version: " VERSION
    if [[ -z $VERSION ]]; then
        echo "No version provided. Aborting."
        exit 1
    fi
fi

# Confirm or edit branch name
read -p "Use '$BRANCH_NAME' as the branch name? (y/n): " CONFIRM_BRANCH
if [[ $CONFIRM_BRANCH != "y" ]]; then
    read -p "Enter branch name: " NEW_BRANCH
    if [[ -n $NEW_BRANCH ]]; then
        BRANCH_NAME="$NEW_BRANCH"
    fi
fi

# Confirm or edit commit message
if [[ -n $SUMMARY ]]; then
    read -p "Use this summary as your commit message? (y/n/e for edit): " CONFIRM_MESSAGE
    if [[ $CONFIRM_MESSAGE == "e" ]]; then
        read -p "Enter your modified commit message: " NEW_MESSAGE
        COMMIT_MESSAGE="$NEW_MESSAGE"
    elif [[ $CONFIRM_MESSAGE != "y" ]]; then
        read -p "Enter your new commit message: " NEW_MESSAGE
        COMMIT_MESSAGE="$NEW_MESSAGE"
    else
        COMMIT_MESSAGE="$SUMMARY"
    fi
else
    read -p "Enter your commit message: " COMMIT_MESSAGE
    if [[ -z $COMMIT_MESSAGE ]]; then
        echo "No commit message provided. Aborting."
        exit 1
    fi
fi

# Final confirmation
echo
echo "About to commit and tag with:"
echo "Version: $VERSION"
echo "Branch: $BRANCH_NAME"
echo "Message: $COMMIT_MESSAGE"
read -p "Proceed? (y/n): " FINAL_CONFIRM
if [[ $FINAL_CONFIRM != "y" ]]; then
    echo "Aborting the tagging and pushing process."
    exit 0
fi

# Checkout the branch
git checkout -b "$BRANCH_NAME" 2>/dev/null || git checkout "$BRANCH_NAME"

# Stage all changes, commit, tag, and push
git add -A
git commit -m "$COMMIT_MESSAGE"
git tag -a "v$VERSION" -m "Version $VERSION: $COMMIT_MESSAGE"
git push origin "$BRANCH_NAME"

# Push the tag
git push origin "v$VERSION"

# Confirm success
echo "Version $VERSION has been tagged and pushed successfully."

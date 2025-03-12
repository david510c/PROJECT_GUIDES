#!/bin/bash

# -------------------------------------------------------
# Changelog Version Commit Script
# 
# This script extracts version and summary from CHANGELOG.md,
# creates a branch, commits changes, and tags the release
# -------------------------------------------------------

# Configuration
CHANGELOG_FILE="CHANGELOG.md"
USER_PREFS_FILE=".changelog_prefs"

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Check if the CHANGELOG file exists
if [[ ! -f $CHANGELOG_FILE ]]; then
    handle_error "$CHANGELOG_FILE not found."
fi

# Get current Git branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ -z $CURRENT_BRANCH ]]; then
    CURRENT_BRANCH="main"  # Fallback
fi

# Extract the most recent version number
VERSION=$(grep "^## \[" "$CHANGELOG_FILE" | grep -v "Unreleased" | head -n 1 | sed 's/^## \[\([0-9]*\.[0-9]*\.[0-9]*\)\].*/\1/')
if [[ -z $VERSION ]]; then
    handle_error "Could not extract version from $CHANGELOG_FILE."
fi

# Extract the summary from CHANGELOG.md
VERSION_LINE_NUM=$(grep -n "^## \[$VERSION\]" "$CHANGELOG_FILE" | cut -d ':' -f1)
if [[ -n $VERSION_LINE_NUM ]]; then
    # Look for **Summary**: line within 5 lines after the version line
    SUMMARY_LINE_NUM=$((VERSION_LINE_NUM + 1))
    SUMMARY=$(sed -n "${SUMMARY_LINE_NUM},+5p" "$CHANGELOG_FILE" | grep "^\*\*Summary\*\*:" | sed 's/^\*\*Summary\*\*:[ ]*//')
fi

# Default release branch name based on version
RELEASE_BRANCH_NAME="release-$VERSION"

# Load user preferences for custom branches
LAST_CUSTOM_BRANCH=""
if [[ -f $USER_PREFS_FILE ]]; then
    LAST_CUSTOM_BRANCH=$(grep "^last_custom_branch=" $USER_PREFS_FILE | cut -d'=' -f2)
fi

# Show the extracted information
echo "Found in $CHANGELOG_FILE:"
echo "Version: $VERSION"
echo "Summary: $SUMMARY"
echo "Current Branch: $CURRENT_BRANCH"
echo

# Confirm version
read -p "Is this the version you want to tag? (y/n): " CONFIRM_VERSION
if [[ $CONFIRM_VERSION != "y" ]]; then
    read -p "Enter the correct version: " NEW_VERSION
    if [[ -z $NEW_VERSION ]]; then
        handle_error "No version provided. Aborting."
    fi
    VERSION=$NEW_VERSION
    RELEASE_BRANCH_NAME="release-$VERSION"
fi

# Display branch options
echo "Select branch options:"
echo "1) $CURRENT_BRANCH (current branch)"
echo "2) $RELEASE_BRANCH_NAME (version-specific release branch)"

# Add appropriate additional options based on current branch and preferences
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    echo "3) main"
    OPTION_MAIN=3
    OPTION_CUSTOM_START=4
else
    OPTION_CUSTOM_START=3
fi

if [[ -n $LAST_CUSTOM_BRANCH ]]; then
    echo "${OPTION_CUSTOM_START}) $LAST_CUSTOM_BRANCH (last used custom branch)"
    OPTION_NEW=$((OPTION_CUSTOM_START + 1))
    echo "${OPTION_NEW}) Enter a new branch name"
else
    echo "${OPTION_CUSTOM_START}) Enter a new branch name"
    OPTION_NEW=$OPTION_CUSTOM_START
fi

# Get user's branch choice
read -p "Enter your choice: " BRANCH_CHOICE

# Process branch selection
case $BRANCH_CHOICE in
    1)
        BRANCH_NAME="$CURRENT_BRANCH"
        ;;
    2)
        BRANCH_NAME="$RELEASE_BRANCH_NAME"
        ;;
    $OPTION_MAIN)
        BRANCH_NAME="main"
        ;;
    $OPTION_CUSTOM_START)
        if [[ -n $LAST_CUSTOM_BRANCH && $OPTION_CUSTOM_START -ne $OPTION_NEW ]]; then
            BRANCH_NAME="$LAST_CUSTOM_BRANCH"
        else
            read -p "Enter your custom branch name: " CUSTOM_BRANCH
            if [[ -n $CUSTOM_BRANCH ]]; then
                BRANCH_NAME="$CUSTOM_BRANCH"
                echo "last_custom_branch=$CUSTOM_BRANCH" > $USER_PREFS_FILE
            else
                BRANCH_NAME="$CURRENT_BRANCH"  # Fallback
            fi
        fi
        ;;
    $OPTION_NEW)
        if [[ $OPTION_NEW -ne $OPTION_CUSTOM_START ]]; then
            read -p "Enter your custom branch name: " CUSTOM_BRANCH
            if [[ -n $CUSTOM_BRANCH ]]; then
                BRANCH_NAME="$CUSTOM_BRANCH"
                echo "last_custom_branch=$CUSTOM_BRANCH" > $USER_PREFS_FILE
            else
                BRANCH_NAME="$CURRENT_BRANCH"  # Fallback
            fi
        fi
        ;;
    *)
        BRANCH_NAME="$CURRENT_BRANCH"  # Default choice
        ;;
esac

echo "Using branch: $BRANCH_NAME"

# Confirm or edit tag name
TAG_NAME="v$VERSION"
read -p "Use '$TAG_NAME' as the tag name? (y/n): " CONFIRM_TAG
if [[ $CONFIRM_TAG != "y" ]]; then
    read -p "Enter tag name: " NEW_TAG
    if [[ -n $NEW_TAG ]]; then
        TAG_NAME="$NEW_TAG"
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
        handle_error "No commit message provided. Aborting."
    fi
fi

# Final confirmation
echo
echo "About to commit and tag with:"
echo "Version: $VERSION"
echo "Branch: $BRANCH_NAME"
echo "Tag: $TAG_NAME"
echo "Message: $COMMIT_MESSAGE"
read -p "Proceed? (y/n): " FINAL_CONFIRM
if [[ $FINAL_CONFIRM != "y" ]]; then
    echo "Aborting the tagging and pushing process."
    exit 0
fi

# Checkout the branch, creating it if it doesn't exist
git checkout $BRANCH_NAME 2>/dev/null || git checkout -b "$BRANCH_NAME"

# Stage all changes, commit, tag, and push
git add -A
git commit -m "$COMMIT_MESSAGE"
git tag -a "$TAG_NAME" -m "Version $VERSION: $COMMIT_MESSAGE"
git push origin "$BRANCH_NAME"

# Push the tag
git push origin "$TAG_NAME"

# Confirm success
echo "Version $VERSION has been tagged and pushed successfully."
echo "Branch: $BRANCH_NAME"
echo "Tag: $TAG_NAME"

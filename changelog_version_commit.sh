#!/bin/bash

# Path to the CHANGELOG.md file
CHANGELOG_FILE="CHANGELOG.md"
# Path to store user preferences
USER_PREFS_FILE=".changelog_prefs"

# Check if the CHANGELOG file exists
if [[ ! -f $CHANGELOG_FILE ]]; then
    echo "Error: $CHANGELOG_FILE not found."
    exit 1
fi

# Get current Git branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ -z $CURRENT_BRANCH ]]; then
    # Fallback in case git command fails
    CURRENT_BRANCH="main"
fi

# Extract the most recent version number using grep
# Using simpler regex pattern compatible with BSD grep on macOS
VERSION=$(grep "^## \[" "$CHANGELOG_FILE" | grep -v "Unreleased" | head -n 1 | sed 's/^## \[\([0-9]*\.[0-9]*\.[0-9]*\)\].*/\1/')

if [[ -z $VERSION ]]; then
    echo "Error: Could not extract version from $CHANGELOG_FILE."
    exit 1
fi

# Extract the summary, looking specifically for the **Summary** line after the version header
# Use a marker to indicate the start of the version section
VERSION_LINE_NUM=$(grep -n "^## \[$VERSION\]" "$CHANGELOG_FILE" | cut -d ':' -f1)
if [[ -n $VERSION_LINE_NUM ]]; then
    # Look for the first line with "**Summary**:" after the version line
    # We'll search the next 5 lines to account for empty lines
    SUMMARY_LINE_NUM=$((VERSION_LINE_NUM + 1))
    SUMMARY=$(sed -n "${SUMMARY_LINE_NUM},+5p" "$CHANGELOG_FILE" | grep "^\*\*Summary\*\*:" | sed 's/^\*\*Summary\*\*:[ ]*//')
fi

if [[ -z $SUMMARY ]]; then
    echo "Warning: Could not extract summary from $CHANGELOG_FILE."
    echo "You will need to provide a commit message manually."
fi

# Calculate release branch name (for option purposes only)
RELEASE_BRANCH_NAME="release-$VERSION"

# Load user preferences if they exist
LAST_CUSTOM_BRANCH=""
if [[ -f $USER_PREFS_FILE ]]; then
    LAST_CUSTOM_BRANCH=$(grep "^last_custom_branch=" $USER_PREFS_FILE | cut -d'=' -f2)
fi

# Show the extracted information and confirm with user
echo "Found in $CHANGELOG_FILE:"
echo "Version: $VERSION"
echo "Summary: $SUMMARY"
echo "Current Branch: $CURRENT_BRANCH"
echo

# Confirm version
read -p "Is this the version you want to tag? (y/n): " CONFIRM_VERSION
if [[ $CONFIRM_VERSION != "y" ]]; then
    read -p "Enter the correct version: " VERSION
    if [[ -z $VERSION ]]; then
        echo "No version provided. Aborting."
        exit 1
    fi
    # Update release branch name
    RELEASE_BRANCH_NAME="release-$VERSION"
fi

# Branch selection options
echo "Select branch options:"
echo "1) $CURRENT_BRANCH (current branch)"
echo "2) $RELEASE_BRANCH_NAME (version-specific release branch)"
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    echo "3) main"
    if [[ -n $LAST_CUSTOM_BRANCH ]]; then
        echo "4) $LAST_CUSTOM_BRANCH (last used custom branch)"
        echo "5) Enter a new branch name"
    else
        echo "4) Enter a new branch name"
    fi
else
    if [[ -n $LAST_CUSTOM_BRANCH ]]; then
        echo "3) $LAST_CUSTOM_BRANCH (last used custom branch)"
        echo "4) Enter a new branch name"
    else
        echo "3) Enter a new branch name"
    fi
fi

# Get user's branch choice
read -p "Enter your choice: " BRANCH_CHOICE

case $BRANCH_CHOICE in
    1)
        BRANCH_NAME="$CURRENT_BRANCH"
        ;;
    2)
        BRANCH_NAME="$RELEASE_BRANCH_NAME"
        ;;
    3)
        if [[ "$CURRENT_BRANCH" != "main" ]]; then
            BRANCH_NAME="main"
        else
            if [[ -n $LAST_CUSTOM_BRANCH ]]; then
                BRANCH_NAME="$LAST_CUSTOM_BRANCH"
            else
                read -p "Enter your custom branch name: " CUSTOM_BRANCH
                if [[ -n $CUSTOM_BRANCH ]]; then
                    BRANCH_NAME="$CUSTOM_BRANCH"
                    # Save this custom branch for future use
                    echo "last_custom_branch=$CUSTOM_BRANCH" > $USER_PREFS_FILE
                else
                    BRANCH_NAME="$CURRENT_BRANCH"
                fi
            fi
        fi
        ;;
    4)
        if [[ "$CURRENT_BRANCH" != "main" ]]; then
            if [[ -n $LAST_CUSTOM_BRANCH ]]; then
                BRANCH_NAME="$LAST_CUSTOM_BRANCH"
            else
                read -p "Enter your custom branch name: " CUSTOM_BRANCH
                if [[ -n $CUSTOM_BRANCH ]]; then
                    BRANCH_NAME="$CUSTOM_BRANCH"
                    # Save this custom branch for future use
                    echo "last_custom_branch=$CUSTOM_BRANCH" > $USER_PREFS_FILE
                else
                    BRANCH_NAME="$CURRENT_BRANCH"
                fi
            fi
        else
            read -p "Enter your custom branch name: " CUSTOM_BRANCH
            if [[ -n $CUSTOM_BRANCH ]]; then
                BRANCH_NAME="$CUSTOM_BRANCH"
                # Save this custom branch for future use
                echo "last_custom_branch=$CUSTOM_BRANCH" > $USER_PREFS_FILE
            else
                BRANCH_NAME="$CURRENT_BRANCH"
            fi
        fi
        ;;
    5)
        if [[ "$CURRENT_BRANCH" != "main" && -n $LAST_CUSTOM_BRANCH ]]; then
            read -p "Enter your custom branch name: " CUSTOM_BRANCH
            if [[ -n $CUSTOM_BRANCH ]]; then
                BRANCH_NAME="$CUSTOM_BRANCH"
                # Save this custom branch for future use
                echo "last_custom_branch=$CUSTOM_BRANCH" > $USER_PREFS_FILE
            else
                BRANCH_NAME="$CURRENT_BRANCH"
            fi
        else
            BRANCH_NAME="$CURRENT_BRANCH"
        fi
        ;;
    *)
        BRANCH_NAME="$CURRENT_BRANCH"
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
        echo "No commit message provided. Aborting."
        exit 1
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

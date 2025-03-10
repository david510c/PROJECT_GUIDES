#!/bin/bash
# Read the version and short name from manifest.json in Project_Guide
MANIFEST_FILE="Project_Guides/manifest.json"
if [[ ! -f $MANIFEST_FILE ]]; then
    echo "Error: $MANIFEST_FILE not found in the Project_Guides directory."
    exit 1
fi
# Extract version using grep and sed
VERSION=$(grep '"version":' "$MANIFEST_FILE" | sed -E 's/.*"version": *"([^"]+)".*/\1/')
if [[ -z $VERSION ]]; then
    echo "Error: Could not extract version from $MANIFEST_FILE."
    exit 1
fi
# Extract short name using grep and sed
SHORT_NAME=$(grep '"short_name":' "$MANIFEST_FILE" | sed -E 's/.*"short_name": *"([^"]+)".*/\1/')
if [[ -z $SHORT_NAME ]]; then
    echo "Error: Could not extract short name from $MANIFEST_FILE."
    exit 1
fi
# Extract commit message from breakdown_and_tracking.md
BREAKDOWN_FILE="Project_Guides/breakdown_and_tracking.md"
if [[ ! -f $BREAKDOWN_FILE ]]; then
    echo "Error: $BREAKDOWN_FILE not found in the Project_Guides directory."
    exit 1
fi
# Extract commit message from the first bullet point under ## Next Steps, 2. **Documentation Updates**
COMMIT_MESSAGE=$(awk '/## Next Steps/{flag=1;next}/##/{flag=0}flag' "$BREAKDOWN_FILE" | awk '/2\. \*\*Documentation Updates\*\*/{flag=1;next}/\*\*/{flag=0}flag' | sed -n 's/^- //p' | head -n 1)
if [[ -z $COMMIT_MESSAGE ]]; then
    echo "Error: Could not extract commit message from $BREAKDOWN_FILE."
    read -p "Enter your commit message: " COMMIT_MESSAGE
fi
# Show the extracted information and confirm with user
echo "Found in $MANIFEST_FILE:"
echo "Version: $VERSION"
echo "Short Name: $SHORT_NAME"
echo "Commit Message: $COMMIT_MESSAGE"
echo
# Confirm version
read -p "Is this the version you want to tag? (y/n): " CONFIRM_VERSION
if [[ $CONFIRM_VERSION != "y" ]]; then
    echo "Aborting the tagging and pushing process."
    exit 0
fi
# Confirm or edit commit message
if [[ -n $COMMIT_MESSAGE ]]; then
    read -p "Use this commit message? (y/n/e for edit): " CONFIRM_MESSAGE
    if [[ $CONFIRM_MESSAGE == "e" ]]; then
        read -p "Enter your modified commit message: " NEW_MESSAGE
        COMMIT_MESSAGE="$NEW_MESSAGE"
    elif [[ $CONFIRM_MESSAGE != "y" ]]; then
        read -p "Enter your new commit message: " NEW_MESSAGE
        COMMIT_MESSAGE="$NEW_MESSAGE"
    fi
else
    read -p "Enter your commit message: " COMMIT_MESSAGE
fi
# Final confirmation
echo
echo "About to commit and tag with:"
echo "Version: $VERSION"
echo "Short Name: $SHORT_NAME"
echo "Message: $COMMIT_MESSAGE"
read -p "Proceed? (y/n): " FINAL_CONFIRM
if [[ $FINAL_CONFIRM != "y" ]]; then
    echo "Aborting the tagging and pushing process."
    exit 0
fi
# Change to the Project_Guides directory
cd Project_Guides
# Checkout the branch specified by the short name
git checkout -b "$SHORT_NAME" || git checkout "$SHORT_NAME"
# Stage all changes, commit, tag, and push
git add -A
git commit -m "$COMMIT_MESSAGE"
git tag -a "$VERSION" -m "$VERSION"
git push origin "$SHORT_NAME"
# Push the tag
git push origin "$VERSION"
# Confirm success
echo "Version $VERSION has been tagged and pushed successfully."
# Change back to the root directory
cd ..

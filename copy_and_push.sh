#!/bin/bash

# Repo Paths
REPO_A_PATH="/Users/yoganandareddykanchisamudram/Documents/Repo_A"
REPO_B_PATH="/Users/yoganandareddykanchisamudram/Documents/Repo_B"

# Files to Copy
FILTER_FILES=("src/main/java/HelloWorld.java")
BRANCH="main"

# Get Latest Commit Hash
COMMIT_HASH=$(git rev-parse HEAD)
echo "Latest Commit: $COMMIT_HASH"

# Get List of Changed Files
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r "$COMMIT_HASH")

COPY_FILES=()
for file in "${FILTER_FILES[@]}"; do
  if echo "$CHANGED_FILES" | grep -q "$file"; then
    COPY_FILES+=("$file")
  fi
done

if [ ${#COPY_FILES[@]} -eq 0 ]; then
  echo "No matching files found!"
  exit 0
fi

echo "Copying Files: ${COPY_FILES[*]}"

# Copy Files to Repo B
for file in "${COPY_FILES[@]}"; do
  mkdir -p "$(dirname "$REPO_B_PATH/$file")"
  cp "$REPO_A_PATH/$file" "$REPO_B_PATH/$file"
  echo "Copied: $file"
done

# Commit and Push Changes to Repo B
cd "$REPO_B_PATH" || exit
git add "${COPY_FILES[@]}"
git commit -m "Auto commit from $COMMIT_HASH"
git push origin "$BRANCH"
echo "Changes Pushed to Repo B!"

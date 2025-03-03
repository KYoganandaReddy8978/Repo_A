#!/bin/bash

# Repo B details
REPO_B_URL="https://github.com/KYoganandaReddy8978/Repo_B.git"
BRANCH="main"
TEMP_DIR="/tmp/repo_b"

# Files to Copy (Add your files here)
FILTER_FILES=("src/main/java/HelloWorld.java")

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

echo "Files to Copy: ${COPY_FILES[*]}"

# Clone Repo B into Temporary Directory
if [ -d "$TEMP_DIR" ]; then
  rm -rf "$TEMP_DIR"
fi
git clone "$REPO_B_URL" "$TEMP_DIR"

# Copy Files to Repo B
for file in "${COPY_FILES[@]}"; do
  mkdir -p "$(dirname "$TEMP_DIR/$file")"
  cp "$file" "$TEMP_DIR/$file"
  echo "Copied: $file"
done

# Commit and Push Changes to Repo B
cd "$TEMP_DIR" || exit
git add "${COPY_FILES[@]}"
git commit -m "Auto commit from $COMMIT_HASH"
git push origin "$BRANCH"

echo "Changes pushed to Repo B!"

# Clean up
rm -rf "$TEMP_DIR"

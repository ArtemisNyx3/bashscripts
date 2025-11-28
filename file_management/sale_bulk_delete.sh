#!/bin/bash

# Ask for the directory to search in
read -p "Enter the directory to search in: " SEARCH_DIR

# Expand ~ to full path
SEARCH_DIR="${SEARCH_DIR/#\~/$HOME}"

# Check if directory exists
if [[ ! -d "$SEARCH_DIR" ]]; then
  echo "Directory does not exist!"
  exit 1
fi

# Ask for the search pattern
read -p "Enter the search pattern (e.g., *.log): " SEARCH_PATTERN

# Show a dry-run of files to be deleted
echo
echo "Dry-run: The following files would be deleted:"
FILES_TO_DELETE=$(find "$SEARCH_DIR" -type f -name "$SEARCH_PATTERN")
if [[ -z "$FILES_TO_DELETE" ]]; then
  echo "No files match the pattern '$SEARCH_PATTERN' in '$SEARCH_DIR'."
  exit 0
fi

echo "$FILES_TO_DELETE"
echo

# Final confirmation
read -p "Are you sure you want to delete these files? Type 'yes' to proceed: " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "Aborted."
  exit 0
fi

# Log file in home directory
LOG_FILE="$HOME/deleted_files.log"

echo "Deleting files..."
for FILE in $FILES_TO_DELETE; do
  # Prompt for each file with clear instructions
  read -p "Delete '$FILE'? Type 'y' or 'yes' to confirm: " FILE_CONFIRM
  if [[ "$FILE_CONFIRM" == "y" || "$FILE_CONFIRM" == "yes" ]]; then
    rm "$FILE" && echo "$FILE" >>"$LOG_FILE"
  else
    echo "Skipped: $FILE"
  fi
done

echo
echo "Done. Deleted files are logged in '$LOG_FILE'."

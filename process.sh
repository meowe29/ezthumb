#!/bin/sh
set -e # This line ensures that the script will exit immediately if any command fails.

echo "--- Script starting in /data directory. ---"
echo "--- Finding video files... ---"

# Loop over all files ending in .mp4 (case-insensitive)
for f in *.[mM][pP]4; do
  # Check if a matching file actually exists to avoid errors if the folder is empty
  if [ -f "$f" ]; then
    echo "" # Add a blank line for readability
    echo ">>> Processing File: $f"
    # Run the command on the file. Quotes around "$f" handle spaces in names.
    ezthumb -g 4x10 -R -s 30% "$f"
  fi
done

echo ""
echo "--- Script finished. ---"
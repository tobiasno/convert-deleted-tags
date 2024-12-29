#!/bin/bash
set -e  # Exit on any error

# Initialize a status variable
status=0

# Find all messages tagged as deleted in notmuch
notmuch search --output=files tag:deleted | while read file; do
    # Get the directory and filename
    dir=$(dirname "$file")
    name=$(basename "$file")

    # Remove the ":2," from the filename if it exists and get the flags
    base=${name%%:2,*}
    flags=${name##*:2,*}

    # If the name didn't have flags, initialize empty flags
    if [ "$base" = "$flags" ]; then
        flags=""
    fi

    # Add the Deleted flag ('T') if not already present
    if [[ "$flags" != *"T"* ]]; then
        # Create new filename with 'T' flag
        newname="${base}:2,${flags}T"
        if ! mv "$file" "$dir/$newname"; then
            status=1
            break
        fi
    fi
done

exit $status

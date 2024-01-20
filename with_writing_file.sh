#!/bin/bash

backup_source="/store/backup"
backup_destination="/store/backup.local"

# Get the current date in the format YYYY-MM-DD
current_date=$(date +"%Y-%m-%d")

# Construct the backup filename
backup_filename="backup_${current_date}.tar.gz"

# Full paths for source and destination files
source_file="${backup_source}/${backup_filename}"
destination_file="${backup_destination}/${backup_filename}"

# Check if the source backup file exists
if [ -e "$source_file" ]; then
    echo "Source backup file found. Starting backup copy process..."
    
    # Copy the backup file
    cp "$source_file" "$destination_file"
    
    # Validate if the copy was successful
    if [ $? -eq 0 ]; then
        echo "Backup copy successful."
        
        # Compare source and destination file names
        if [ "$(basename "$source_file")" == "$(basename "$destination_file")" ]; then
            echo "File names match."
            
            # Assuming validation logic here (e.g., check file integrity)
            # Compare source and destination file sizes
            source_size=$(stat -c %s "$source_file")
            destination_size=$(stat -c %s "$destination_file")
            
            if [ "$source_size" -eq "$destination_size" ]; then
                echo "File sizes match. Validation successful."
                
                # If validation is successful, remove the source file
                if [ $? -eq 0 ]; then
                    rm "$source_file"
                    echo "Source backup file removed."
                    
                    # Remove old backup files (older than 3 days) from backup destination
                    find "$backup_destination" -type f -name "backup_*.tar.gz" -mtime +3 -exec rm {} \;
                    echo "Old backup files (older than 3 days) removed."
                else
                    echo "Error removing source backup file."
                fi
            else
                echo "File sizes do not match. Validation failed."
            fi
        else
            echo "File names do not match."
        fi
    else
        echo "Backup copy failed."
    fi
else
    echo "Source backup file does not exist. No backup to copy."
fi

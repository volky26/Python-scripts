#!/bin/bash

backup_source="/store/backup"
backup_destination="/store/backup.local"
log_file="/path/to/your/logfile.log"

# Get the current date in the format YYYY-MM-DD
current_date=$(date +"%Y-%m-%d")

# Construct the backup filename
backup_filename="backup_${current_date}.tar.gz"

# Full paths for source and destination files
source_file="${backup_source}/${backup_filename}"
destination_file="${backup_destination}/${backup_filename}"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$log_file"
}

# Check if the source backup file exists
if [ -e "$source_file" ]; then
    log_message "Source backup file found. Starting backup copy process..."
    
    # Copy the backup file
    cp "$source_file" "$destination_file"
    
    # Validate if the copy was successful
    if [ $? -eq 0 ]; then
        log_message "Backup copy successful."
        
        # Assuming validation logic here (e.g., check file integrity)
        # You can add your validation steps here
        # ...
        
        # If validation is successful, remove the source file
        if [ $? -eq 0 ]; then
            rm "$source_file"
            log_message "Source backup file removed."
            
            # Remove old backup files (older than 3 days) from backup destination
            find "$backup_destination" -type f -name "backup_*.tar.gz" -mtime +3 -exec rm {} \;
            log_message "Old backup files (older than 3 days) removed."
        else
            log_message "Validation failed. Source file not removed."
        fi
    else
        log_message "Backup copy failed."
    fi
else
    log_message "Source backup file does not exist. No backup to copy."
fi

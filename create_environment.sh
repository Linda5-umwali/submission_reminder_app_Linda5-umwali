#!/bin/bash

# Prompt user for their name
echo -n "Enter your name: "
read user_name

# Create main directory with user's name
main_dir="submission_reminder_${user_name}"
mkdir -p "$main_dir"/app "$main_dir"/assets "$main_dir"/config "$main_dir"/modules

# Create the reminder.sh script in app directory
cat <<EOL > "$main_dir/app/reminder.sh"
#!/bin/bash

# Load environment variables and functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Check if the submissions file exists
if [ ! -f "\$submissions_file" ]; then
    echo "Error: Submissions file not found at \$submissions_file"
    exit 1
fi

# Display assignment details from the environment variables
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "----------------------------------------------"

# Call the function to check submissions
check_submissions "\$submissions_file"

# Final message
echo "Reminder app started successfully!"
EOL
chmod +x "$main_dir/app/reminder.sh"

# Create the submissions.txt file in assets directory
cat <<EOL > "$main_dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Kellia, shell scripting, submitted
Razro, Bash, not submitted
Liliane, Git, submitted
Lindah, Shell Navigation, not submitted
Shalom, Shell Basics, not submitted
EOL

# Create the config.env file in config directory
cat <<EOL > "$main_dir/config/config.env"
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

# Create the functions.sh file in modules directory
cat <<EOL > "$main_dir/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOL
chmod +x "$main_dir/modules/functions.sh"

# Create the startup.sh script in the main directory
cat <<EOL > "$main_dir/startup.sh"
#!/bin/bash

# Navigate to the app directory and execute reminder.sh
cd "\$(dirname "\$0")/app" || exit
./reminder.sh
echo "Reminder app started successfully!"
EOL
chmod +x "$main_dir/startup.sh"

# Ensure all .sh files are executable
chmod +x "$main_dir"/app/*.sh "$main_dir"/modules/*.sh "$main_dir/startup.sh"

echo "the project is completed successfully"


#!/bin/bash

# Stop the Chrome Remote Desktop service if it's already running
sudo service chrome-remote-desktop stop

# Start the Chrome Remote Desktop service with the CRP token
DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AeaYSHBJvGI_Z-4ecqETr0LIyWEa4a6ifuk5Y9haaUx2kzIQvJSFVJYrwQPYRKEDKqDiOw" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)

# Check if the Chrome Remote Desktop service started successfully
if [ $? -eq 0 ]; then
    echo "Chrome Remote Desktop host started successfully."
else
    echo "Error: Failed to start Chrome Remote Desktop host."
fi

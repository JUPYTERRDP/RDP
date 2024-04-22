#!/bin/bash

# Stop the Chrome Remote Desktop service if it's already running
sudo service chrome-remote-desktop stop

# Start the Chrome Remote Desktop service with the CRP token
DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AeaYSHCQcU7E_0IJQmJe_3btm1pf4vDJ526cObruWLYnzhyMdvMoyUbE9pxhBcJT1a47gQ" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)

# Check if the Chrome Remote Desktop service started successfully
if [ $? -eq 0 ]; then
    echo "Chrome Remote Desktop host started successfully."
else
    echo "Error: Failed to start Chrome Remote Desktop host."
fi

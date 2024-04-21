# Use a base image with necessary dependencies
FROM ubuntu:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y wget sudo xfce4 desktop-base xfce4-terminal xscreensaver xdg-utils fonts-liberation libu2f-udev libvulkan1 xvfb xserver-xorg-video-dummy policykit-1 xbase-clients psmisc python3-packaging python3-psutil python3-xdg

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb && \
    apt-get install -y --fix-broken

# Install Chrome Remote Desktop
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    dpkg -i chrome-remote-desktop_current_amd64.deb && \
    apt-get install -y --fix-broken

# Add a non-root user (replace "myuser" with your preferred username)
RUN useradd -m myuser && \
    echo "myuser:password" | chpasswd

# Start Chrome Remote Desktop with the specified user name
CMD ["/bin/bash", "-c", "/opt/google/chrome-remote-desktop/start-host --user-name=myuser --code=\"$CRP\" --pin=\"$PIN\" --redirect-url=\"https://remotedesktop.google.com/_/oauthredirect\""]

# Use a base image with necessary dependencies
FROM ubuntu:latest

# Set noninteractive mode to prevent prompts during installation
ENV DEBIAN_FRONTEND noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y wget sudo xfce4 desktop-base xfce4-terminal xscreensaver xdg-utils fonts-liberation libu2f-udev libvulkan1 xvfb xserver-xorg-video-dummy policykit-1 xbase-clients psmisc python3-packaging python3-psutil python3-xdg && \
    apt-get install -y x11-xkb-utils keyboard-configuration

# Create a non-root user
RUN useradd -m myuser && \
    echo "myuser:password" | chpasswd && \
    usermod -aG sudo myuser

# Switch to the non-root user
USER myuser

# Download Google Chrome and install it
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    sudo dpkg -i /tmp/chrome.deb && \
    sudo apt-get install -y --fix-broken && \
    rm /tmp/chrome.deb

# Download Chrome Remote Desktop and install it
RUN wget -q -O /tmp/chrome-remote-desktop.deb https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    sudo dpkg -i /tmp/chrome-remote-desktop.deb && \
    sudo apt-get install -y --fix-broken && \
    rm /tmp/chrome-remote-desktop.deb

# Configure keyboard layout to English (US)
RUN echo "keyboard-configuration keyboard-configuration/layout select English (US)" | sudo debconf-set-selections && \
    sudo dpkg-reconfigure -f noninteractive keyboard-configuration

# Start Chrome Remote Desktop with the specified user name
CMD ["/bin/bash", "-c", "/opt/google/chrome-remote-desktop/start-host --user-name=myuser --code=\"$CRP\" --pin=\"$PIN\" --redirect-url=\"https://remotedesktop.google.com/_/oauthredirect\""]

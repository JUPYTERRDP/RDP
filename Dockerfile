# Use a base image with Python installed
FROM python:3.9

# Install required dependencies
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

# Create and configure the user
ARG USERNAME=user
ARG PASSWORD=root
ARG CRP="DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AeaYSHDVKDuiOGt0z9lAiZKgalDrk4C3mtr7tXQXSDXIvWMd-85SLDv2h90CqTLQX63qLg" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)"
ARG PIN=123456
ARG AUTOSTART=True

RUN useradd -m $USERNAME && \
    adduser $USERNAME sudo && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd && \
    mkdir -p /home/$USERNAME/.config/chrome-remote-desktop && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.config/chrome-remote-desktop && \
    chmod -R 700 /home/$USERNAME/.config/chrome-remote-desktop

# Set up autostart for Colab
RUN if [ "$AUTOSTART" = "True" ]; then \
        mkdir -p /home/$USERNAME/.config/autostart && \
        echo "[Desktop Entry]\n\
Type=Application\n\
Name=Colab\n\
Exec=sh -c \"sensible-browser https://youtu.be/d9ui27vVePY?si=TfVDVQOd0VHjUt_b\"\n\
Icon=\n\
Comment=Open a predefined notebook at session signin.\n\
X-GNOME-Autostart-enabled=true" > /home/$USERNAME/.config/autostart/colab.desktop && \
        chmod +x /home/$USERNAME/.config/autostart/colab.desktop && \
        chown $USERNAME:$USERNAME /home/$USERNAME/.config; \
    fi

# Set up Chrome Remote Desktop
RUN adduser $USERNAME chrome-remote-desktop && \
    service chrome-remote-desktop start

# Expose Chrome Remote Desktop port
EXPOSE 3389

# Start Chrome Remote Desktop
CMD ["/bin/bash", "-c", "/opt/google/chrome-remote-desktop/start-host --code=\"$CRP\" --pin=\"$PIN\" --redirect-url=\"https://remotedesktop.google.com/_/oauthredirect\""]

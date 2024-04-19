# Use a base image with Python installed
FROM python:3.9

# Set environment variables
ENV USERNAME=user
ENV PASSWORD=root
ENV CRP="DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AeaYSHA58VIAXIsEPh8RjjBiESTC6LxrSqrw4Og-W2NDPC1rzBA4jbNqpzMzbnDDc0iUrA" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)"
ENV PIN=123456
ENV AUTOSTART=True

# Install required dependencies
RUN apt-get update && \
    apt-get install -y wget sudo xfce4 desktop-base xfce4-terminal xscreensaver xdg-utils

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb && \
    apt-get install -y --fix-broken

# Install Chrome Remote Desktop
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    dpkg -i chrome-remote-desktop_current_amd64.deb && \
    apt-get install -y --fix-broken

# Create and configure the user
RUN useradd -m $USERNAME && \
    adduser $USERNAME sudo && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd

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
CMD ["sh", "-c", "/opt/google/chrome-remote-desktop/start-host --code=\"$CRP\" --pin=\"$PIN\" --redirect-url=\"https://remotedesktop.google.com/_/oauthredirect\""]

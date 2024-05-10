# Use an Ubuntu base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xrdp \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/local/bin

# Download and extract ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip -O ngrok.zip \
    && unzip ngrok.zip \
    && rm ngrok.zip

# Set ngrok authtoken
RUN /usr/local/bin/ngrok authtoken 2fifZRLDDdDi4ZtjdROj0c0hRdd_7vfT5CYY1UW6B8Fi2xWWn

# Enable Terminal Services (TS)
RUN sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5

# Enable Remote Desktop
RUN systemctl enable xrdp

# Set User Authentication
RUN sed -i 's/^#*X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config && systemctl restart sshd

# Set Password for User
RUN echo 'runneradmin:P@ssw0rd!' | chpasswd

# Expose ngrok port
EXPOSE 3389

# Command to create ngrok tunnel
CMD ["ngrok", "tcp", "3389"]

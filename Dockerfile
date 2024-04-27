# Use the official Ubuntu image as the base
FROM ubuntu:latest

# Install necessary dependencies and SSH server
RUN apt-get update && \
    apt-get install -y wget unzip openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Expose port for SSH and RDP
EXPOSE 22
EXPOSE 3389

# Download ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip -O ngrok.zip && \
    unzip ngrok.zip && \
    rm ngrok.zip

# Copy the ngrok.yml configuration file into the container
COPY ngrok.yml /ngrok.yml

# Copy the start_ngrok.sh script into the container
COPY start_ngrok.sh /start_ngrok.sh

# Grant execute permissions to the start_ngrok.sh script
RUN chmod +x /start_ngrok.sh

# Start SSH service
RUN service ssh start

# Ensure SSH server is configured to allow root login and password authentication for debugging
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    service ssh restart

# Verify SSH service status
RUN service ssh status

# Execute the start_ngrok.sh script as the entrypoint
ENTRYPOINT ["/start_ngrok.sh"]

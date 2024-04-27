# Use the official Ubuntu image as the base
FROM ubuntu:latest

# Install necessary dependencies and SSH server
RUN apt-get update && \
    apt-get install -y wget unzip openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Expose port for SSH and RDP
EXPOSE 22
EXPOSE 3389

# Copy the ngrok.yml configuration file into the container
COPY ngrok.yml /ngrok.yml

# Copy the start_ngrok.sh script into the container
COPY start_ngrok.sh /start_ngrok.sh

# Grant execute permissions to the start_ngrok.sh script
RUN chmod +x /start_ngrok.sh

# Start SSH service
RUN service ssh start

# Execute the start_ngrok.sh script as the entrypoint
ENTRYPOINT ["/start_ngrok.sh"]

# Use the official Ubuntu image as the base
FROM ubuntu:latest

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Download ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip -O ngrok.zip

# Extract ngrok
RUN unzip ngrok.zip && \
    rm ngrok.zip

# Copy the ngrok.yml configuration file into the container
COPY ngrok.yml /ngrok.yml

# Expose ports for ngrok tunnels
EXPOSE 22
EXPOSE 3389

# Copy the start_ngrok.sh script into the container
COPY start_ngrok.sh /start_ngrok.sh

# Grant execute permissions to the start_ngrok.sh script
RUN chmod +x /start_ngrok.sh

# Execute the start_ngrok.sh script as the entrypoint
ENTRYPOINT ["/start_ngrok.sh"]

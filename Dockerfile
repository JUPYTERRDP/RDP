# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set environment variables
ENV USERNAME user
ENV PASSWORD root
ENV CRP DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AeaYSHB60mhZB9u5zfL0nZR8VqzjQl0-Wljdmofma6mVuurzh_sk_vvWS1zkv40wssOfVA" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)
ENV PIN 123456
ENV AUTOSTART True

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Run setup_rdp.py when the container launches
CMD ["python", "./setup_rdp.py"]

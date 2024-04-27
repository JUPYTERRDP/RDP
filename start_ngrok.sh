#!/bin/bash

# Set ngrok authentication token
./ngrok authtoken 2fImcTPq1NnyclnXZePhudATr9y_6VQ6fcAAxUVpXtjcK6jvr

# Start ngrok TCP tunnel
./ngrok tcp 3389

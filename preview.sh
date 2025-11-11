#!/bin/bash

# Preview Hugo site locally
echo "Starting Hugo development server..."
hugo server -D --bind 0.0.0.0 --port 1313

# Site will be available at http://localhost:1313

#!/bin/bash

# Navigate to the project directory
# cd instance-code/process-calling || exit 1

# Install dependencies
pip install -r requirements.txt

# Determine port based on branch (passed from GitHub Actions)
case "$DEPLOY_ENV" in
  "develop")
    PORT=8002
    ;;
  "stage")
    PORT=8001
    ;;
  "main")
    PORT=8000
    ;;
  *)
    echo "Invalid branch/environment. Exiting."
    exit 1
    ;;
esac

# Run the FastAPI app
# Run FastAPI app in the background with nohup
nohup uvicorn main:app --host 0.0.0.0 --port "$PORT" > server.log 2>&1 &

echo "FastAPI app started on port $PORT"

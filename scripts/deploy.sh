#!/bin/bash

set -x

# Handle termination signals
_term() {
	echo "Received termination signal!"
	kill -TERM "$redis_process" 2>/dev/null
	kill -TERM "$serge_process" 2>/dev/null
}

# Install python bindings
pip install llama-cpp-python==0.1.78 || {
	echo 'Failed to install llama-cpp-python'
	exit 1
}

echo "Starting Redis instance..."
# Start Redis instance
redis-server /etc/redis/redis.conf &
redis_process=$!
echo "Redis instance started."

echo "Starting the API..."
# Start the API
cd /usr/src/app/api || exit 1
uvicorn src.serge.main:app --host 0.0.0.0 --port 8008 || {
	echo 'Failed to start main app'
	exit 1
} &
serge_process=$!
echo "API started."

# Set up a signal trap and wait for processes to finish
trap _term TERM
wait $redis_process $serge_process

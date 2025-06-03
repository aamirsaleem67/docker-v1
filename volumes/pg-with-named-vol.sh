#!/bin/bash

echo "🚀 Starting PostgreSQL Container Management Script"
echo "=================================================="

CONTAINER_NAME="pg-with-vol"
POSTGRES_PASSWORD="mysecretpassword"
PORT="5432"
VOLUME_NAME="pgvol"

# Function to check if container exists
check_container() {
    if docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        return 0  # Container exists
    else
        return 1  # Container doesn't exist
    fi
}

# Step 0: Clean up any existing container
echo ""
echo "🧹 Step 0: Cleaning up any existing container '${CONTAINER_NAME}'"
if check_container; then
    echo "🔍 Found existing container '${CONTAINER_NAME}', removing it..."
    docker stop ${CONTAINER_NAME} 2>/dev/null
    docker rm ${CONTAINER_NAME} 2>/dev/null
    echo "✅ Existing container removed"
    echo "⏳ Container created. Press Enter when ready to check status..."
    read -r
else
    echo "✅ No existing container found, starting fresh"
fi

# Step 1: Create container
echo ""
echo "📦 Step 1: Creating PostgreSQL container '${CONTAINER_NAME}'"
docker run -d --name ${CONTAINER_NAME} \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -p ${PORT}:5432 \
    -v ${VOLUME_NAME}:/var/lib/postgresql/data \
    postgres

if [ $? -eq 0 ]; then
    echo "✅ Container '${CONTAINER_NAME}' created successfully"
else
    echo "❌ Failed to create container '${CONTAINER_NAME}'"
    exit 1
fi

# Show running containers
echo ""
echo "📋 Current running containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Verify our specific container is running
echo ""
echo "🔍 Verifying our container '${CONTAINER_NAME}':"
if docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -q "${CONTAINER_NAME}"; then
    echo "✅ Container '${CONTAINER_NAME}' is running"
    docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo "❌ Container '${CONTAINER_NAME}' is not running"
    echo "📋 Checking all containers (including stopped):"
    docker ps -a --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
fi

# Step 2: Stop and delete container
echo ""
echo "🛑 Step 2: Stopping and deleting container '${CONTAINER_NAME}'"
docker stop ${CONTAINER_NAME} 2>/dev/null
docker rm ${CONTAINER_NAME} 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Container '${CONTAINER_NAME}' stopped and deleted successfully"
else
    echo "❌ Failed to stop/delete container '${CONTAINER_NAME}'"
fi

# Step 3: Prove container doesn't exist
echo ""
echo "🔍 Step 3: Proving container '${CONTAINER_NAME}' doesn't exist"
if check_container; then
    echo "❌ ERROR: Container '${CONTAINER_NAME}' still exists!"
    docker ps -a --filter "name=${CONTAINER_NAME}"
else
    echo "✅ PROOF: Container '${CONTAINER_NAME}' does NOT exist"
    echo "📋 All containers (should not show '${CONTAINER_NAME}'):"
    if [ $(docker ps -a --format "{{.Names}}" | wc -l) -eq 0 ]; then
        echo "No containers found"
    else
        docker ps -a --format "table {{.Names}}\t{{.Status}}" | head -10
    fi
fi

# Step 4: Create container again
echo ""
echo "🔄 Step 4: Creating PostgreSQL container '${CONTAINER_NAME}' again"
docker run -d --name ${CONTAINER_NAME} \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -p ${PORT}:5432 \
    -v ${VOLUME_NAME}:/var/lib/postgresql/data \
    postgres

if [ $? -eq 0 ]; then
    echo "✅ Container '${CONTAINER_NAME}' created successfully (again)"
else
    echo "❌ Failed to create container '${CONTAINER_NAME}' (again)"
    exit 1
fi

# Wait a moment for container to start
echo "⏳ Container recreated. Press Enter when ready to check final status..."
read -r

# Final status
echo ""
echo "🎯 Final Status:"
echo "==============="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=${CONTAINER_NAME}"

# Check if container is healthy
echo ""
echo "🏥 Health Check:"
if docker exec ${CONTAINER_NAME} pg_isready -U postgres >/dev/null 2>&1; then
    echo "✅ PostgreSQL is ready and accepting connections"
    echo "🔗 Connection: postgresql://postgres:${POSTGRES_PASSWORD}@localhost:${PORT}/postgres"
else
    echo "⚠️  PostgreSQL is starting up... (may take a few more seconds)"
fi

echo ""
echo "🎉 Script completed successfully!"
echo "📝 Container '${CONTAINER_NAME}' is running on port ${PORT}"
echo "🛑 To stop: docker stop ${CONTAINER_NAME}"
echo "🗑️  To remove: docker rm ${CONTAINER_NAME}"

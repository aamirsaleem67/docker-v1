#!/bin/bash

echo "🚀 Database seeder starting..."
echo "⏳ Waiting for PostgreSQL to be ready..."

# Function to check if PostgreSQL is ready
wait_for_postgres() {
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "🔍 Attempt $attempt/$max_attempts: Checking PostgreSQL connection..."
        
        if pg_isready -h database -p 5432 -U postgres; then
            echo "✅ PostgreSQL is ready!"
            return 0
        fi
        
        echo "⏳ PostgreSQL not ready yet, waiting 2 seconds..."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "❌ PostgreSQL failed to become ready after $max_attempts attempts"
    exit 1
}

# Wait for PostgreSQL to be ready
wait_for_postgres

# Additional wait to ensure PostgreSQL is fully initialized
echo "⏳ Waiting additional 5 seconds for PostgreSQL full initialization..."
sleep 5

# Set PostgreSQL password for non-interactive mode
export PGPASSWORD=mysecretpassword

# Execute the database creation and seeding script
echo "🗄️ Executing database creation and seeding..."
chmod +x /scripts/CreateDBAndSeed.sh
/scripts/CreateDBAndSeed.sh

if [ $? -eq 0 ]; then
    echo "🎉 Database seeding completed successfully!"
else
    echo "❌ Database seeding failed!"
    exit 1
fi

echo "✅ Database seeder finished. Container will now exit." 
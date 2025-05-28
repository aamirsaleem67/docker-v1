FROM postgres:15-alpine

# Install additional tools if needed
RUN apk add --no-cache bash

# Set environment variables
ENV PGPASSWORD=mysecretpassword

# Copy the scripts
COPY db.sh /scripts/db.sh
COPY CreateDBAndSeed.sh /scripts/CreateDBAndSeed.sh

# Make scripts executable
RUN chmod +x /scripts/db.sh /scripts/CreateDBAndSeed.sh

# Set working directory
WORKDIR /scripts

# Run the main script
CMD ["/scripts/db.sh"] 
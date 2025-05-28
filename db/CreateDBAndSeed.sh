#!/bin/bash

echo "🗄️ Starting database creation and seeding..."

# Create the database
echo "📝 Creating database 'bookstore'..."
psql -h database -U postgres -c "CREATE DATABASE bookstore;" 2>/dev/null || echo "Database 'bookstore' already exists"

# Connect to the bookstore database and create table + seed data
echo "📚 Creating books table and inserting seed data..."
psql -h database -U postgres -d bookstore << EOF
-- Create books table
CREATE TABLE IF NOT EXISTS books (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255)
);

-- Clear existing data (optional, remove if you want to preserve data)
TRUNCATE TABLE books RESTART IDENTITY CASCADE;

-- Insert seed data
INSERT INTO books (id, title) VALUES
    (1, 'The Great Gatsby'),
    (2, 'To Kill a Mockingbird'),
    (3, '1984'),
    (4, 'Pride and Prejudice'),
    (5, 'The Catcher in the Rye'),
    (6, 'Lord of the Flies'),
    (7, 'Animal Farm'),
    (8, 'Brave New World'),
    (9, 'The Lord of the Rings')
ON CONFLICT (id) DO NOTHING;

-- Verify the data
SELECT COUNT(*) as total_books FROM books;
SELECT * FROM books LIMIT 5;
EOF

echo "✅ Database seeding completed successfully!" 
#!/bin/sh

# Docker startup script for AirBnb app
# This script handles MongoDB replica set connectivity and database initialization

echo "🚀 Starting AirBnb application..."

# Set Prisma engine types to avoid OpenSSL detection issues
export PRISMA_CLI_QUERY_ENGINE_TYPE=binary
export PRISMA_CLIENT_ENGINE_TYPE=binary

echo "⏳ Waiting for MongoDB to be ready..."
until nc -z mongodb 27017; do
  echo "   Waiting for MongoDB to start..."
  sleep 2
done

echo "⏳ Waiting for MongoDB replica set to be ready..."
# Give extra time for replica set initialization
sleep 10

echo "✅ MongoDB should be ready!"

echo "🔧 Generating Prisma client..."
npx prisma generate

echo "📦 Pushing database schema..."
npx prisma db push --accept-data-loss

echo "🎯 Starting Next.js development server..."
npm run dev


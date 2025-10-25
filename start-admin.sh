#!/bin/bash

echo "🚀 Starting Hotel Admin Portal..."
echo ""

# Check if node_modules exists
if [ ! -d "admin-portal/node_modules" ]; then
    echo "📦 Installing dependencies..."
    cd admin-portal
    npm install
    cd ..
    echo "✅ Dependencies installed!"
    echo ""
fi

# Start the React app
echo "🎨 Starting React Admin Portal on http://localhost:5173"
echo "📝 Make sure Spring Boot backend is running on http://localhost:8080"
echo ""
echo "Demo Credentials:"
echo "  Admin: admin@hotel.com / admin123 (Role: ADMIN)"
echo "  User:  user@hotel.com / user123 (Role: USER)"
echo ""

cd admin-portal
npm run dev

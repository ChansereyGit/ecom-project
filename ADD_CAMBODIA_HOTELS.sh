#!/bin/bash

# Script to add Cambodia hotels to the database
# This handles different PostgreSQL connection scenarios

echo "🇰🇭 Adding Cambodia Hotels to Database..."
echo ""

# Try different connection methods
if psql -U postgres -d hotelbooker -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ Connected to PostgreSQL"
    echo "📥 Inserting Cambodia hotels..."
    psql -U postgres -d hotelbooker -f backend/CAMBODIA_HOTELS.sql
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ SUCCESS! Cambodia hotels added."
        echo ""
        echo "Verifying..."
        psql -U postgres -d hotelbooker -c "SELECT COUNT(*) as cambodia_hotels FROM hotels WHERE country='Cambodia';"
        echo ""
        echo "🎉 Done! You can now search for:"
        echo "   - Siem Reap"
        echo "   - Phnom Penh"
        echo "   - Preah Sihanouk"
        echo "   - Kampot"
    else
        echo ""
        echo "❌ Error inserting data. See error above."
        echo ""
        echo "💡 Try manually:"
        echo "   psql -U postgres -d hotelbooker"
        echo "   \\i backend/CAMBODIA_HOTELS.sql"
    fi
elif psql -U root -d hotelbooker -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ Connected to PostgreSQL (using root user)"
    echo "📥 Inserting Cambodia hotels..."
    psql -U root -d hotelbooker -f backend/CAMBODIA_HOTELS.sql
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ SUCCESS! Cambodia hotels added."
        psql -U root -d hotelbooker -c "SELECT COUNT(*) as cambodia_hotels FROM hotels WHERE country='Cambodia';"
    fi
else
    echo "❌ Cannot connect to PostgreSQL"
    echo ""
    echo "Please run manually:"
    echo ""
    echo "1. Connect to your database:"
    echo "   psql -U YOUR_USERNAME -d hotelbooker"
    echo ""
    echo "2. Run the SQL file:"
    echo "   \\i backend/CAMBODIA_HOTELS.sql"
    echo ""
    echo "3. Verify:"
    echo "   SELECT COUNT(*) FROM hotels WHERE country='Cambodia';"
    echo "   (Should show 12)"
fi

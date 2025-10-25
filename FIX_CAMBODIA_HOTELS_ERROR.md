# Fix Cambodia Hotels Database Error

## Error Explanation

The error you're seeing:
```
ERROR: insert or update on table "hotel_amenities" violates foreign key constraint
Key (hotel_id)=(550e8400-e29b-41d4-a716-446655440010) is not present in table "hotels"
```

This means the hotel insert failed, but the script continued trying to insert amenities for a hotel that doesn't exist.

## Solution: Run SQL in Correct Order

### Option 1: Using Database GUI (Easiest)

If you're using a database GUI (like pgAdmin, DBeaver, or TablePlus):

1. Open your database tool
2. Connect to `hotelbooker` database
3. Open `backend/CAMBODIA_HOTELS.sql`
4. Run the entire file
5. Check for errors in the output

### Option 2: Using psql Command Line

#### Step 1: Find Your Database Connection

Try these commands to find which works:

```bash
# Try with postgres user
psql -U postgres -d hotelbooker

# Try with root user (your config shows this)
psql -U root -d hotelbooker

# Try with your system user
psql -d hotelbooker
```

#### Step 2: Once Connected, Run the SQL

```sql
-- Inside psql, run:
\i backend/CAMBODIA_HOTELS.sql

-- Check if it worked:
SELECT COUNT(*) FROM hotels WHERE country='Cambodia';
-- Should show: 12

-- See the hotels:
SELECT name, city, price_per_night FROM hotels WHERE country='Cambodia';
```

### Option 3: Using the Script

```bash
# Make it executable (already done)
chmod +x ADD_CAMBODIA_HOTELS.sh

# Run it
./ADD_CAMBODIA_HOTELS.sh
```

### Option 4: Manual SQL Execution

If all else fails, copy and paste the SQL directly:

1. Open `backend/CAMBODIA_HOTELS.sql`
2. Copy ALL the content
3. Connect to your database
4. Paste and execute

## Verify It Worked

After running the SQL, verify:

```sql
-- Check hotel count
SELECT COUNT(*) FROM hotels WHERE country='Cambodia';
-- Expected: 12

-- Check by city
SELECT city, COUNT(*) as hotel_count 
FROM hotels 
WHERE country='Cambodia' 
GROUP BY city;
-- Expected:
-- Siem Reap: 3
-- Phnom Penh: 3
-- Preah Sihanouk: 3
-- Kampot: 3

-- Check rooms were added
SELECT COUNT(*) FROM rooms 
WHERE hotel_id IN (SELECT id FROM hotels WHERE country='Cambodia');
-- Expected: 17 rooms
```

## Common Issues & Fixes

### Issue 1: "relation does not exist"
**Problem**: Tables haven't been created yet
**Fix**: Start the backend first, it will create tables automatically
```bash
cd backend
./mvnw spring-boot:run
# Wait for it to start, then stop it (Ctrl+C)
# Then run the SQL
```

### Issue 2: "duplicate key value"
**Problem**: Hotels already exist with those IDs
**Fix**: The updated SQL file now deletes existing Cambodia hotels first

### Issue 3: "permission denied"
**Problem**: User doesn't have insert permissions
**Fix**: Use a superuser account or grant permissions:
```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO your_username;
```

### Issue 4: Foreign key constraint error
**Problem**: SQL statements running out of order
**Fix**: Run the ENTIRE file at once, not line by line

## Alternative: Use Different IDs

If you keep having conflicts, I can generate a new SQL file with different UUIDs. Let me know!

## Quick Test After Adding

1. **Restart Backend:**
   ```bash
   cd backend
   ./mvnw spring-boot:run
   ```

2. **Test in Flutter:**
   - Search "Siem Reap"
   - Should see 3 hotels
   - Search "Phnom Penh"
   - Should see 3 hotels

## Need Help?

If you're still stuck, tell me:
1. How do you normally connect to your database?
2. What database tool are you using?
3. What's your PostgreSQL username?

I can provide more specific instructions!

---

**Quick Fix Summary:**
1. Connect to database: `psql -U root -d hotelbooker`
2. Run SQL: `\i backend/CAMBODIA_HOTELS.sql`
3. Verify: `SELECT COUNT(*) FROM hotels WHERE country='Cambodia';`
4. Should show: **12**

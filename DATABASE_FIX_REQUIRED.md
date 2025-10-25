# Database Fix Required - Payment Table

## Issue
The `payments` table has a `NOT NULL` constraint on `booking_id` column, but we need to create payments BEFORE bookings exist.

## Quick Fix

### Option 1: Run SQL Script (Recommended)
Open your database client (pgAdmin, DBeaver, or psql) and run:

```sql
ALTER TABLE payments ALTER COLUMN booking_id DROP NOT NULL;
```

Or run the provided script:
```bash
psql -U postgres -d hotelbooker -f backend/FIX_PAYMENT_TABLE.sql
```

### Option 2: Drop and Recreate Table
If the table is empty or you don't mind losing test data:

```sql
DROP TABLE IF EXISTS payments CASCADE;

CREATE TABLE payments (
    id VARCHAR(255) PRIMARY KEY,
    booking_id VARCHAR(255),  -- Now nullable
    user_id VARCHAR(255) NOT NULL,
    stripe_payment_intent_id VARCHAR(255) UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    status VARCHAR(50) NOT NULL,
    payment_method VARCHAR(50),
    failure_reason TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP
);
```

### Option 3: Let Hibernate Update (Easiest)
Since you have `ddl-auto: update` in application.yml:

1. Stop the backend
2. Delete the payments table:
   ```sql
   DROP TABLE IF EXISTS payments CASCADE;
   ```
3. Restart the backend
4. Hibernate will recreate the table with the correct schema

## Why This is Needed

**Payment Flow:**
1. User clicks "Complete Booking"
2. **Create Payment Intent** → Payment record created with `booking_id = null`
3. User enters card in Stripe
4. Payment succeeds
5. **Create Booking** → Booking record created
6. Update payment with booking_id

The payment is created BEFORE the booking, so `booking_id` must be nullable.

## After Fixing

1. Restart the backend
2. Try the payment again in the Flutter app
3. The Stripe Payment Sheet should appear
4. Enter test card: **4242 4242 4242 4242**
5. Success! ✅

## Quick Commands

### Check if table exists:
```sql
SELECT column_name, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'payments';
```

### Fix the constraint:
```sql
ALTER TABLE payments ALTER COLUMN booking_id DROP NOT NULL;
```

### Verify the fix:
```sql
\d payments;
```

You should see `booking_id` with `nullable: YES`

## Status

- ✅ Backend code is correct
- ✅ Stripe integration is complete
- ✅ Flutter app is ready
- ⚠️ Database schema needs update

**Just run the SQL command above and you're ready to test!** 🚀

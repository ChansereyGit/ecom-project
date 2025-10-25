# Fix Git History - Remove Stripe Keys

## Problem
GitHub blocked the push because Stripe API keys were committed in previous commits.

## Solution Options

### Option 1: Force Push (Easiest - if you're the only one working on this)

```bash
# Reset to before the Stripe commits
git reset --soft HEAD~3

# Re-commit without the keys
git add -A
git commit -m "Add Stripe integration with environment variables"

# Force push
git push --force origin main
```

### Option 2: Interactive Rebase (More Control)

```bash
# Start interactive rebase for last 3 commits
git rebase -i HEAD~3

# In the editor, change 'pick' to 'edit' for commits with keys
# Save and close

# For each commit:
git add -A
git commit --amend --no-edit
git rebase --continue

# Force push
git push --force origin main
```

### Option 3: Use GitHub's Allow Secret Feature (Quick Fix)

GitHub provided a URL to allow the secret:
```
https://github.com/ChansereyGit/hotelBooker/security/secret-scanning/unblock-secret/34GU2nWJB83pxSiHJxiRY8qPBuX
```

**Steps:**
1. Click the URL above
2. Click "Allow secret"
3. Push again: `git push origin main`

**⚠️ Warning:** This is NOT recommended for production. Only use for:
- Test keys (which these are)
- Educational projects
- Keys you plan to rotate immediately

### Option 4: Create New Repository (Nuclear Option)

If the above doesn't work:

```bash
# 1. Create a new repo on GitHub
# 2. Remove old remote
git remote remove origin

# 3. Add new remote
git remote add origin https://github.com/YOUR_USERNAME/NEW_REPO.git

# 4. Push
git push -u origin main
```

## Recommended Approach

Since these are **test keys** for an educational project:

1. **Use Option 3** (Allow the secret) to unblock the push
2. **Immediately roll the keys** in Stripe Dashboard:
   - Go to: https://dashboard.stripe.com/test/apikeys
   - Click "Roll key" for both keys
   - Update your local `.env` file with new keys
3. **Never commit keys again** (they're now in environment variables)

## After Fixing

1. Set up your environment variables:
```bash
# Create .env file
cp backend/.env.example backend/.env

# Edit and add your NEW keys
nano backend/.env
```

2. Update Flutter config:
```dart
// flutter/lib/config/stripe_config.dart
static const String publishableKey = 'pk_test_YOUR_NEW_KEY';
```

3. Test everything still works:
```bash
cd backend && ./mvnw spring-boot:run
cd flutter && flutter run
```

## Prevention

✅ Keys are now in environment variables
✅ `.env` is in `.gitignore`
✅ Config files use `${STRIPE_SECRET_KEY:default}` syntax
✅ Documentation updated with security notes

## Need Help?

See `STRIPE_KEYS_SETUP.md` for detailed setup instructions.

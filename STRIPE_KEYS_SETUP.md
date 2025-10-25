# Stripe Keys Setup Guide

## 🔐 Security First!

Your Stripe keys have been removed from the repository for security. Here's how to set them up locally:

## Option 1: Environment Variables (Recommended)

### macOS/Linux:
```bash
# Add to your ~/.zshrc or ~/.bashrc
export STRIPE_SECRET_KEY="sk_test_YOUR_SECRET_KEY_HERE"
export STRIPE_PUBLISHABLE_KEY="pk_test_YOUR_PUBLISHABLE_KEY_HERE"

# Reload shell
source ~/.zshrc  # or source ~/.bashrc
```

### Windows:
```cmd
# Set environment variables
setx STRIPE_SECRET_KEY "sk_test_YOUR_SECRET_KEY_HERE"
setx STRIPE_PUBLISHABLE_KEY "pk_test_YOUR_PUBLISHABLE_KEY_HERE"
```

## Option 2: Create .env File

1. Copy the example file:
```bash
cp backend/.env.example backend/.env
```

2. Edit `backend/.env` and add your actual keys:
```properties
STRIPE_SECRET_KEY=sk_test_51SJbplRUcv8iFfZ9...
STRIPE_PUBLISHABLE_KEY=pk_test_51SJbplRUcv8iFfZ9...
```

3. The `.env` file is already in `.gitignore` so it won't be committed

## Option 3: Direct Configuration (Not Recommended)

Edit the config files directly (but don't commit them):
- `backend/src/main/resources/application.yml`
- `backend/src/main/resources/application-dev.yml`

## 🔑 Get Your Stripe Keys

1. Go to: https://dashboard.stripe.com/test/apikeys
2. Copy your **Publishable key** (starts with `pk_test_`)
3. Copy your **Secret key** (starts with `sk_test_`)

## 📱 Flutter Configuration

Edit `flutter/lib/config/stripe_config.dart`:
```dart
static const String publishableKey = 'pk_test_YOUR_KEY_HERE';
```

## ✅ Verify Setup

Start the backend and check logs:
```bash
cd backend
./mvnw spring-boot:run
```

You should see:
```
Stripe API initialized successfully
```

## 🚨 Important Security Notes

1. **Never commit** actual API keys to Git
2. **Never share** your secret key publicly
3. **Use test keys** for development (start with `sk_test_` or `pk_test_`)
4. **Use environment variables** in production
5. **Rotate keys** if accidentally exposed

## 🔄 If Keys Were Exposed

If you accidentally committed keys to Git:

1. **Roll the keys** in Stripe Dashboard:
   - Go to: https://dashboard.stripe.com/test/apikeys
   - Click "Roll key" next to the exposed key
   - Update your local configuration

2. **Remove from Git history** (if needed):
```bash
# This is complex - consider creating a new repo if needed
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch backend/src/main/resources/application.yml" \
  --prune-empty --tag-name-filter cat -- --all
```

## 📚 More Information

- [Stripe API Keys Documentation](https://stripe.com/docs/keys)
- [Best Practices for API Keys](https://stripe.com/docs/keys#safe-keys)

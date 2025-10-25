# Git Setup Guide

## 🚀 Quick Push to GitHub (Without Doc Files)

### Step 1: Remove Cached MD Files
```bash
# Remove all tracked MD files from git (but keep them locally)
git rm --cached *_GUIDE.md
git rm --cached *_IMPLEMENTATION.md
git rm --cached *_COMPLETE.md
git rm --cached *_SUMMARY.md
git rm --cached *_FIX.md
git rm --cached *_PLAN.md
git rm --cached *_CHECKLIST.md
git rm --cached *_DIAGRAM.md
git rm --cached *_INTEGRATION.md
git rm --cached *_ANALYSIS.md
git rm --cached *_REVIEW.md
git rm --cached *_PROMPT.md
git rm --cached *_REFERENCE.md
git rm --cached *_STRATEGY.md
git rm --cached WHAT_WE_BUILT.md
git rm --cached START_HERE.md
git rm --cached QUICK_START.md

# Or remove all at once
git rm --cached *.md
git add README.md  # Add back README
```

### Step 2: Initialize Git (if not already)
```bash
git init
git add .
git commit -m "Initial commit: Hotel booking system"
```

### Step 3: Create GitHub Repository
1. Go to github.com
2. Click "New repository"
3. Name: `hotel-booking-system`
4. Don't initialize with README (you have one)
5. Click "Create repository"

### Step 4: Push to GitHub
```bash
# Add remote
git remote add origin https://github.com/YOUR_USERNAME/hotel-booking-system.git

# Push
git branch -M main
git push -u origin main
```

---

## 📝 What Gets Pushed vs Ignored

### ✅ PUSHED (Important Code):
```
✅ backend/src/          # Java code
✅ admin-portal/src/     # React code
✅ flutter/lib/          # Flutter code
✅ docker-compose.yml    # Docker config
✅ Dockerfile           # Docker files
✅ README.md            # Main readme
✅ .gitignore           # Git ignore
```

### ❌ IGNORED (Documentation):
```
❌ *_GUIDE.md
❌ *_IMPLEMENTATION.md
❌ *_COMPLETE.md
❌ *_SUMMARY.md
❌ All other MD files (except README)
```

### ❌ IGNORED (Build/Env):
```
❌ backend/target/
❌ admin-portal/node_modules/
❌ flutter/build/
❌ .env files
❌ IDE files (.idea, .vscode)
```

---

## 🔄 Daily Git Workflow

### Make Changes
```bash
# Check status
git status

# Add changes
git add .

# Commit
git commit -m "Add booking management feature"

# Push
git push
```

### Pull Latest
```bash
git pull origin main
```

---

## 🎯 Clean Repository

### Remove All Untracked Files
```bash
# See what will be removed
git clean -n

# Remove untracked files
git clean -f

# Remove untracked directories
git clean -fd
```

### Remove All MD Files from Git
```bash
# Remove from git but keep locally
find . -name "*.md" ! -name "README.md" -exec git rm --cached {} \;

# Commit the removal
git commit -m "Remove documentation files from git"
git push
```

---

## 📦 Repository Size

### Before (with all MD files):
```
~50MB (with docs)
```

### After (without MD files):
```
~20MB (clean code only)
```

---

## 🎓 Best Practices

### 1. Keep README.md
```bash
# Always keep main README
git add README.md
```

### 2. Never Commit Secrets
```bash
# Already in .gitignore:
.env
backend/.env
admin-portal/.env
*.pem
*.key
```

### 3. Commit Messages
```bash
# Good
git commit -m "Add user authentication"
git commit -m "Fix booking date validation"
git commit -m "Update admin dashboard UI"

# Bad
git commit -m "update"
git commit -m "fix"
git commit -m "changes"
```

### 4. Branch Strategy
```bash
# Main branch (production)
main

# Development branch
git checkout -b develop

# Feature branches
git checkout -b feature/booking-system
git checkout -b feature/payment-integration
git checkout -b fix/date-validation
```

---

## 🚀 Quick Commands

### First Time Setup
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/hotel-booking-system.git
git push -u origin main
```

### Daily Use
```bash
git add .
git commit -m "Your message"
git push
```

### Undo Last Commit (not pushed)
```bash
git reset --soft HEAD~1
```

### Undo Changes (not committed)
```bash
git checkout -- .
```

---

## ✅ Verification

### Check What Will Be Pushed
```bash
git status
git diff --cached
```

### Check Remote
```bash
git remote -v
```

### Check Ignored Files
```bash
git status --ignored
```

---

Your repository is now clean and ready to push! 🎉

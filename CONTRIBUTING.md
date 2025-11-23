# Contributing to RAFEEQ

This guide explains how team members can collaborate on the RAFEEQ project.

## Table of Contents
- [Setting Up](#setting-up)
- [Git Workflow](#git-workflow)
- [Branch Strategy](#branch-strategy)
- [Making Changes](#making-changes)
- [Pull Requests](#pull-requests)
- [Best Practices](#best-practices)

## Setting Up

### For Repository Owner (You)

1. **Add Collaborators to GitHub:**
   - Go to your repository on GitHub
   - Click on **Settings** tab
   - Click on **Collaborators** (or **Manage access**)
   - Click **Add people**
   - Enter the GitHub usernames or emails of your team members
   - They will receive an invitation email

### For Team Members

1. **Accept the Invitation:**
   - Check your email for the GitHub invitation
   - Click "Accept invitation"
   - Or go to: https://github.com/YOUR_USERNAME/rafeeq/invitations

2. **Clone the Repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/rafeeq.git
   cd rafeeq
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Configure Git (if not already done):**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## Git Workflow

### Basic Workflow for Team Members

1. **Always start with the latest code:**
   ```bash
   git pull origin main
   ```

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   # Example: git checkout -b feature/add-payment-gateway
   ```

3. **Make your changes:**
   - Edit files in your IDE
   - Test your changes

4. **Stage your changes:**
   ```bash
   git add .
   # Or add specific files: git add lib/screens/home.dart
   ```

5. **Commit your changes:**
   ```bash
   git commit -m "Description of what you changed"
   # Example: git commit -m "Add payment gateway integration"
   ```

6. **Push your branch:**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request on GitHub:**
   - Go to your repository on GitHub
   - Click "Pull requests" → "New pull request"
   - Select your feature branch
   - Add description of changes
   - Request review from team members
   - Click "Create pull request"

8. **After review and approval, merge the PR:**
   - Team member reviews the code
   - If approved, merge the pull request
   - Delete the feature branch after merging

9. **Update your local main branch:**
   ```bash
   git checkout main
   git pull origin main
   ```

## Branch Strategy

### Branch Naming Convention

Use descriptive branch names with prefixes:

- `feature/` - New features
  - Example: `feature/user-profile-page`
  - Example: `feature/chat-notifications`

- `fix/` - Bug fixes
  - Example: `fix/login-error`
  - Example: `fix/wallet-balance-display`

- `refactor/` - Code refactoring
  - Example: `refactor/auth-provider`

- `docs/` - Documentation updates
  - Example: `docs/update-readme`

### Main Branches

- `main` - Production-ready code (protected)
  - Never commit directly to main
  - Always use pull requests

## Making Changes

### Daily Workflow

```bash
# 1. Start your day - get latest changes
git checkout main
git pull origin main

# 2. Create a new branch for your work
git checkout -b feature/my-new-feature

# 3. Make changes, test, commit
git add .
git commit -m "Add new feature"

# 4. Push to GitHub
git push origin feature/my-new-feature

# 5. Create Pull Request on GitHub
# 6. After PR is merged, update local main
git checkout main
git pull origin main
```

### Handling Conflicts

If someone else pushed changes while you were working:

```bash
# Switch to main and update
git checkout main
git pull origin main

# Switch back to your branch
git checkout feature/your-feature

# Merge main into your branch
git merge main

# Resolve conflicts in your IDE
# Then commit the merge
git add .
git commit -m "Merge main into feature branch"

# Push updated branch
git push origin feature/your-feature
```

## Pull Requests

### Creating a Good Pull Request

1. **Clear Title:**
   - Example: "Add user profile editing functionality"

2. **Description should include:**
   - What changes were made
   - Why the changes were needed
   - How to test the changes
   - Screenshots (if UI changes)

3. **Example PR Description:**
   ```
   ## Changes
   - Added user profile editing screen
   - Implemented profile photo upload
   - Added validation for profile fields
   
   ## Testing
   - Navigate to Profile → Edit
   - Update name, email, and photo
   - Verify changes are saved
   
   ## Screenshots
   [Add screenshots here]
   ```

### Review Process

1. Team member creates PR
2. Other team members review the code
3. Request changes if needed
4. Author makes requested changes
5. Re-request review
6. Once approved, merge the PR

## Best Practices

### Commit Messages

Write clear, descriptive commit messages:

✅ **Good:**
```
git commit -m "Add dark mode toggle in settings"
git commit -m "Fix wallet balance not updating after payment"
git commit -m "Refactor authentication provider for better error handling"
```

❌ **Bad:**
```
git commit -m "fix"
git commit -m "update"
git commit -m "changes"
```

### Code Quality

- Run `flutter analyze` before committing
- Test your changes before pushing
- Follow existing code style
- Add comments for complex logic

### Communication

- Use GitHub Issues for bugs and feature requests
- Discuss major changes before implementing
- Update team on progress
- Ask for help when stuck

### File Organization

- Keep related files together
- Follow the existing project structure
- Don't create unnecessary folders

## Quick Reference Commands

```bash
# Check current status
git status

# See what branch you're on
git branch

# See all branches (local and remote)
git branch -a

# Switch branches
git checkout branch-name

# Create and switch to new branch
git checkout -b new-branch-name

# See commit history
git log

# Discard local changes (be careful!)
git checkout -- filename

# Update from remote
git pull origin main

# Push to remote
git push origin branch-name
```

## Troubleshooting

### "Your branch is behind 'origin/main'"
```bash
git pull origin main
```

### "Permission denied"
- Make sure you've accepted the GitHub invitation
- Check you have write access to the repository

### "Merge conflict"
- Open the conflicted files
- Look for `<<<<<<<`, `=======`, `>>>>>>>` markers
- Choose which code to keep
- Remove the conflict markers
- Stage and commit: `git add . && git commit -m "Resolve conflicts"`

## Need Help?

- Check GitHub documentation: https://docs.github.com
- Ask team members
- Review this guide again

---

**Remember:** Always work on feature branches, never directly on `main`!


#!/data/data/com.termux/files/usr/bin/bash

CRED_FILE="$HOME/.termux-lock/creds.txt"
BYPASS_FILE="$HOME/.termux-lock/bypass.txt"
mkdir -p "$HOME/.termux-lock"

echo "=== 🔐 New Password Setup ==="
read -p "Username: " username
read -s -p "Password: " password; echo
read -s -p "Confirm Password: " password2; echo

if [ "$password" != "$password2" ]; then
    echo "❌ Passwords do not match!"
    exit 1
fi

pass_hash=$(echo -n "$password" | openssl dgst -sha256 | awk '{print $2}')
echo "$username" > "$CRED_FILE"
echo "$pass_hash" >> "$CRED_FILE"

echo
echo "=== 🗝️  Emergency Recovery Code ==="
read -p "Secret recovery username: " secret_user
secret_hash=$(echo -n "$secret_user" | openssl dgst -sha256 | awk '{print $2}')
echo "$secret_hash" > "$BYPASS_FILE"

echo
echo "✅ Setup complete!"
echo "⚠️  Remember your recovery username. Store it somewhere safe."

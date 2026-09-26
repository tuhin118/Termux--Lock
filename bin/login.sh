#!/data/data/com.termux/files/usr/bin/bash

CRED_FILE="$HOME/.termux-lock/creds.txt"
BYPASS_FILE="$HOME/.termux-lock/bypass.txt"

# If no credentials exist, skip login
[ ! -f "$CRED_FILE" ] && exec bash --login

# Disable Ctrl+C and Ctrl+Z
trap '' SIGINT SIGTSTP

# Infinite loop until correct password or recovery code
while true; do
    clear
    figlet -f small "Termux Lock" 2>/dev/null || echo "=== TERMUX LOCK ==="
    echo

    # Ask for username (if Ctrl+D is pressed, continue loop)
    read -p "Username: " input_user || continue

    # Check emergency recovery code
    if [ -f "$BYPASS_FILE" ]; then
        secret_hash=$(cat "$BYPASS_FILE")
        input_hash=$(echo -n "$input_user" | openssl dgst -sha256 | awk '{print $2}')
        if [ "$input_hash" = "$secret_hash" ]; then
            echo "🔓 Recovery code accepted!"
            sleep 1
            exec bash --login
        fi
    fi

    # Ask for password
    read -s -p "Password: " input_pass || continue
    echo

    # Load saved credentials
    saved_user=$(sed -n '1p' "$CRED_FILE")
    saved_hash=$(sed -n '2p' "$CRED_FILE")
    input_hash=$(echo -n "$input_pass" | openssl dgst -sha256 | awk '{print $2}')

    # Verify
    if [ "$input_user" = "$saved_user" ] && [ "$input_hash" = "$saved_hash" ]; then
        echo "✅ Login successful!"
        sleep 1
        exec bash --login
    else
        echo "❌ Invalid username or password!"
        sleep 2
        # Loop restarts, screen clears, asks again
    fi
done

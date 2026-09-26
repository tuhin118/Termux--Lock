#!/data/data/com.termux/files/usr/bin/bash

echo "🗑️  Uninstalling Termux-Lock..."

# Remove hook from .bashrc
if [ -f "$HOME/.bashrc" ]; then
    sed -i '/termux-lock\/bin\/login.sh/d' "$HOME/.bashrc"
    echo "✅ Hook removed from .bashrc"
fi

# Remove install directory
if [ -d "$HOME/.termux-lock" ]; then
    rm -rf "$HOME/.termux-lock"
    echo "✅ ~/.termux-lock deleted"
fi

# Remove command
if [ -f "$PREFIX/bin/termux-lock" ]; then
    rm -f "$PREFIX/bin/termux-lock"
    echo "✅ termux-lock command removed"
fi

echo
echo "✅ Uninstall complete!"
echo "⚠️  Restart Termux. The login screen will no longer appear."

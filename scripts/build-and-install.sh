#!/usr/bin/env bash
# Build and install hegel and mirror binaries to ~/.cargo/bin

set -e

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WORKSPACE_ROOT"

echo "🔨 Building hegel workspace (release mode)..."
echo ""

# Check if submodules are initialized
if [ ! -f "hegel-cli/Cargo.toml" ] || [ ! -f "hegel-mirror/Cargo.toml" ]; then
    echo "⚠️  Submodules not initialized. Running git submodule update..."
    git submodule update --init --recursive
    echo ""
fi

# Check if egui-twemoji vendor directory exists
if [ ! -f "hegel-mirror/vendor/egui-twemoji/Cargo.toml" ]; then
    echo "⚠️  Missing hegel-mirror/vendor/egui-twemoji/"
    echo ""
    echo "This vendored dependency is not tracked in git."
    echo "Please copy it from your local hegel-mirror repo:"
    echo ""
    echo "  cp -r /path/to/local/hegel-mirror/vendor/egui-twemoji hegel-mirror/vendor/"
    echo ""
    echo "Or clone it fresh:"
    echo ""
    echo "  cd hegel-mirror/vendor"
    echo "  git clone https://github.com/lassade/egui-twemoji.git egui-twemoji"
    echo ""
    exit 1
fi

# Build workspace
cargo build --release

echo ""
echo "📦 Installing binaries to ~/.cargo/bin..."

# Install both binaries
cargo install --path hegel-cli --locked
cargo install --path hegel-mirror --locked

echo ""
echo "✅ Installation complete!"
echo ""
echo "Installed:"
echo "  hegel  → $(which hegel 2>/dev/null || echo 'NOT IN PATH')"
echo "  mirror → $(which mirror 2>/dev/null || echo 'NOT IN PATH')"
echo ""
echo "Versions:"
hegel --version 2>/dev/null || echo "  hegel: (not found)"
mirror --help 2>&1 | head -1 || echo "  mirror: (not found)"
echo ""
echo "✨ Done! Run 'hegel --help' to get started."

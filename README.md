# Hegel Workspace

**Unified workspace for Hegel CLI and Mirror review UI**

[![Built with DDD](https://img.shields.io/badge/built_with-DDD-blue)](https://github.com/dialecticianai/ddd-book/)

This workspace bundles both `hegel-cli` and `hegel-mirror` as git submodules, allowing a single build command to compile and install both binaries.

---

## What is Hegel?

**Hegel** is a Dialectic-Driven Development (DDD) workflow orchestrator for human-AI collaboration. It provides:
- Structured workflows (Research, Discovery, Execution modes)
- Embedded guides (SPEC writing, PLAN writing, LEARNINGS capture)
- State tracking and phase transitions
- Git guardrails and rules engine

**Mirror** is the companion GUI for reviewing Markdown documents (SPEC.md, PLAN.md, etc.) with inline commenting.

Together, they enable iterative, learning-focused development with clear documentation artifacts.

See:
- [hegel-cli](https://github.com/dialecticianai/hegel-cli) - CLI workflow orchestrator
- [hegel-mirror](https://github.com/dialecticianai/hegel-mirror) - Markdown review UI
- [ddd-book](https://github.com/dialecticianai/ddd-book) - DDD methodology reference

---

## Quick Start

### Prerequisites

- Rust stable toolchain (`rustup`)
- Git with submodule support

### Install

```bash
# Clone with submodules
git clone --recursive https://github.com/dialecticianai/hegel-workspace.git
cd hegel-workspace

# Build and install both binaries
./scripts/build-and-install.sh
```

This installs:
- `hegel` → `~/.cargo/bin/hegel`
- `mirror` → `~/.cargo/bin/mirror`

Verify:
```bash
hegel --version
mirror --help
```

---

## Development

### Building

```bash
# Build both binaries (debug)
cargo build

# Build both binaries (release)
cargo build --release
```

### Updating Submodules

```bash
# Pull latest changes for both submodules
git submodule update --remote

# Or update individually
cd hegel-cli && git pull origin main && cd ..
cd hegel-mirror && git pull origin main && cd ..
```

### Working on Submodules

Each submodule is a full git repository. You can work inside them normally:

```bash
cd hegel-cli
git checkout -b my-feature
# ... make changes ...
git commit -m "feat: add new feature"
git push origin my-feature
cd ..

# Update workspace to track new commit
git add hegel-cli
git commit -m "chore: update hegel-cli submodule"
```

---

## Workspace Structure

```
hegel-workspace/
├── Cargo.toml              # Workspace manifest
├── hegel-cli/              # CLI submodule
├── hegel-mirror/           # Mirror GUI submodule
│   └── vendor/
│       └── egui-twemoji/   # Vendored emoji library (not in git)
└── scripts/
    └── build-and-install.sh
```

**Note**: `hegel-mirror/vendor/egui-twemoji/` is not tracked in git (vendored dependency). The build script copies it from the local hegel-mirror repo during setup.

---

## How It Works

### Cargo Workspace

This repo uses Cargo's workspace feature to build multiple crates together:

```toml
[workspace]
members = ["hegel-cli", "hegel-mirror"]
resolver = "2"
```

Benefits:
- Shared dependency compilation (faster builds)
- Single `cargo build` command for both binaries
- Unified release profile optimization

### Submodules

Both `hegel-cli` and `hegel-mirror` are git submodules pointing to their respective repos. This allows:
- Independent development in each repo
- Version pinning in the workspace
- Easy updates via `git submodule update`

### Installation

`cargo install --path .` builds both workspace members and installs binaries to `~/.cargo/bin/`.

---

## Homebrew Distribution (Future)

This workspace will be the source for the Homebrew formula:

```ruby
# Future: homebrew-core/Formula/hegel.rb
class Hegel < Formula
  desc "Dialectic-Driven Development workflow orchestrator"
  homepage "https://github.com/dialecticianai/hegel-workspace"
  url "https://github.com/dialecticianai/hegel-workspace/archive/v0.1.0.tar.gz"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end
end
```

Users will run:
```bash
brew install hegel
```

And get both `hegel` and `mirror` installed automatically.

---

## Troubleshooting

### Submodules not initialized

```bash
git submodule update --init --recursive
```

### Missing egui-twemoji vendor directory

The `hegel-mirror` submodule requires `vendor/egui-twemoji/`. If missing:

```bash
# Assuming you have hegel-mirror cloned elsewhere with vendor populated
cp -r /path/to/local/hegel-mirror/vendor/egui-twemoji hegel-mirror/vendor/
```

Or clone it fresh:
```bash
cd hegel-mirror/vendor
git clone https://github.com/lassade/egui-twemoji.git egui-twemoji
cd ../..
```

### Build fails with missing dependencies

```bash
# Update Rust toolchain
rustup update stable

# Clean build
cargo clean
cargo build --release
```

---

## License

Both `hegel-cli` and `hegel-mirror` are licensed under the Server Side Public License v1 (SSPL).

See individual submodule repos for full license text.

---

## Contributing

Development happens in the individual repos:
- [hegel-cli issues](https://github.com/dialecticianai/hegel-cli/issues)
- [hegel-mirror issues](https://github.com/dialecticianai/hegel-mirror/issues)

For workspace-specific issues (build scripts, submodule coordination), open an issue here.

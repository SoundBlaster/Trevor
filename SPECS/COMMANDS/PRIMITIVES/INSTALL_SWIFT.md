# INSTALL_SWIFT — Install Swift Toolchain (Trevor)

**Version:** 2.0.0
**Project:** Trevor Mouse Tremor Filter (macOS phases P0-P6)

## Purpose

Install Swift compiler and toolchain required for building and testing Trevor macOS implementation (FilterCore, Event Pipeline, UI, Safety, QA phases). This is a prerequisite for EXECUTE command when working on P0-P6 tasks.

**Note:** Not needed for W0 (Web Tools) tasks, which use Node.js/npm instead.

---

## Prerequisites

- Linux (Ubuntu/Debian-based)
- Internet connection
- Sudo access (for system-wide installation)

---

## Quick Installation (Recommended)

Use the **verified development snapshot** method (tested with Hyperprompt):

```bash
# 1. Install dependencies
sudo apt update
sudo apt install -y \
    binutils git gnupg2 libc6-dev libcurl4-openssl-dev \
    libedit2 libgcc-9-dev libpython3.8 libsqlite3-0 \
    libstdc++-9-dev libxml2-dev libz3-dev pkg-config \
    tzdata unzip zlib1g-dev

# 2. Download Swift development snapshot
cd /tmp
curl -L -o swift.tar.gz "https://download.swift.org/development/ubuntu2004/swift-DEVELOPMENT-SNAPSHOT-2025-08-27-a/swift-DEVELOPMENT-SNAPSHOT-2025-08-27-a-ubuntu20.04.tar.gz"

# 3. Extract and install to /opt/swift (avoids conflicts)
tar zxf swift.tar.gz
sudo mkdir -p /opt/swift
sudo mv swift-DEVELOPMENT-SNAPSHOT-2025-08-27-a-ubuntu20.04 /opt/swift/current

# 4. Fix linker symlink (Swift toolchain has lld but clang expects ld)
cd /opt/swift/current/usr/bin
sudo ln -s lld ld

# 5. Add to PATH (add to ~/.bashrc for persistence)
export PATH="/opt/swift/current/usr/bin:$PATH"
echo 'export PATH="/opt/swift/current/usr/bin:$PATH"' >> ~/.bashrc

# 6. Verify installation
swift --version
```

**Expected output:**
```
Swift version 6.2-dev (LLVM ..., Swift ...)
Target: x86_64-unknown-linux-gnu
```

---

## Alternative: Official Release

For production use, install official Swift release:

```bash
# 1. Download Swift 6.0.3 (adjust URL for your Ubuntu version)
cd /tmp
curl -L -o swift.tar.gz https://download.swift.org/swift-6.0.3-release/ubuntu2404/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE-ubuntu24.04.tar.gz

# 2. Extract
tar -xzf swift.tar.gz

# 3. Install system-wide
sudo mv swift-6.0.3-RELEASE-ubuntu24.04 /usr/share/swift

# 4. Fix linker symlink (Swift toolchain has lld but clang expects ld)
cd /usr/share/swift/usr/bin
sudo ln -s lld ld

# 5. Add to PATH (add to ~/.bashrc)
export PATH="/usr/share/swift/usr/bin:$PATH"
source ~/.bashrc

# 6. Verify
swift --version
```

---

## Verification

Test Swift installation with Trevor:

```bash
cd /Users/egor/Development/GitHub/Trevor

# Build project
swift build

# Run tests (P0-P6 implementation tests)
swift test

# Expected: All tests pass (will vary by phase)
# P1: 23+ unit tests (FilterCore tests)
# P2: 12+ event pipeline tests
# P3-P6: UI, safety, export, QA tests
```

**Quick check if Swift is ready for EXECUTE:**
```bash
swift --version
# Should show: Swift version X.Y (or DEVELOPMENT-SNAPSHOT)

# Then run from Trevor root:
swift test
# If all tests pass, Swift is ready
```

---

## Troubleshooting

**"swift: command not found"**
- Check PATH: `echo $PATH`
- Re-source profile: `source ~/.bashrc`

**"Executable 'ld' doesn't exist" during swift test**
- Swift toolchain includes `lld` but clang expects `ld`
- Fix: `cd /opt/swift/current/usr/bin && sudo ln -s lld ld`
- This symlink is required for running tests and compiling Package.swift manifests

**Missing dependencies**
- Install: `sudo apt install libpython3.8 libcurl4 libxml2`

**Build failures**
- Clean and rebuild: `swift package clean && swift build`

---

## Reference

Full installation guide: [`DOCS/RULES/02_Swift_Installation.md`](../../RULES/02_Swift_Installation.md)

---

## Notes

- **Recommended:** Development snapshot (verified with 130/130 tests passing)
- **Linker symlink required:** Swift toolchain includes LLVM linker (`lld`) but clang searches for `ld` by default. The symlink `ld → lld` enables `swift test` and Package.swift manifest compilation.
- Installation takes ~2-5 minutes
- Requires ~1.5 GB disk space
- One-time setup per development environment

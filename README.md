# Mozart Downloader

A collection of shell scripts for downloading Windows virtual instrument installers (VSTs), sample library installation tools, DAW setups, and audio software launchers for use with **Wine on Linux**.

## 🎯 Purpose

Running Windows audio software, DAWs, and plugin management tools on Linux via **Wine** / **Cheapwine** often requires acquiring original Windows `.exe`, `.rar`, and `.zip` installers. These scripts automate fetching and downloading these Windows installers to specified target paths on Linux.

## 📦 Shell Scripts

All scripts accept an optional target path or directory as their first argument (`$1`). If no target is specified, files are saved in the current working directory.

### 1. Native Access 1.14.1 Installer (`download_native_access.sh`)
Downloads the legacy **Native Access 1.14.1 PC Setup** executable from Archive.org.

```bash
# Download to current directory
./download_native_access.sh

# Download to a specific directory or custom target path
./download_native_access.sh /path/to/downloads/
```

### 2. Orchestral Tools SINE Player (`download_sine.sh`)
Fetches and downloads the latest Windows installer (`.exe`) for **Orchestral Tools SINE Player**.

```bash
# Download to current directory
./download_sine.sh

# Download to a specific target directory
./download_sine.sh /path/to/installers/
```

### 3. EastWest Installation Center (`download_eastwest.sh`)
Downloads the latest **EastWest Installation Center** Windows package (`IC_latest_Win.zip`).

```bash
# Download to current directory
./download_eastwest.sh

# Download to a specific target directory
./download_eastwest.sh /path/to/downloads/
```

### 4. EDIROL Orchestral VST (`download_edirol.sh`)
Downloads the **EDIROL Orchestral VST** archive (`edirol_orchestral.rar`) from Google Drive as referenced in `maestro-plus-ew.sh`.

```bash
# Download to current directory
./download_edirol.sh

# Download to a specific target directory
./download_edirol.sh /path/to/downloads/
```

### 5. FL Studio Windows Installer (`download_flstudio.sh`)
Downloads the latest official 64-bit **FL Studio Windows Installer** (`flstudio_win64.exe`) from Image-Line as referenced in `maestro-plus-ew.sh`.

```bash
# Download to current directory
./download_flstudio.sh

# Download to a specific target directory
./download_flstudio.sh /path/to/downloads/
```

---

## ⚡ Features

- **Designed for Wine on Linux**: Streamlines obtaining Windows audio installer executables on Linux systems.
- **Resumable Downloads**: Uses `curl -C -` (or `wget -c` / `gdown`) to safely download and resume interrupted downloads.
- **Flexible Target Paths**: Supports downloading into specific directories (automatically creating them with `mkdir -p`) or custom filenames.
- **Tool Fallback**: Prefers `curl` with a progress bar and falls back to `gdown` or `wget` if needed.

---

## 🚀 Quick Start

1. Make the shell scripts executable:
   ```bash
   chmod +x *.sh
   ```
2. Execute any downloader script followed by your desired target directory or file path:
   ```bash
   ./download_flstudio.sh ~/wine_installers/
   ```

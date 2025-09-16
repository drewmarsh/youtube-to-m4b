<p align="center">
  Convert YouTube audiobooks to chapterized M4B files with metadata preservation. This script downloads audio from YouTube videos, extracts chapter information, and converts to AAC format in a single command.
  <br><br><a href="https://github.com/drewmarsh/youtube-to-m4b">
    <img src="youtube_to_m4b_banner.png" width="500" alt="Banner">
  </a>
</p>

## Features

- 🎧 Preserves chapters and metadata from YouTube videos
- ⚙️ Configurable audio quality (64kbps-256kbps)
- 📚 Outputs M4B audiobook format
- 💻 Interactive mode or direct command execution
- 📊 Final conversion report with duration and bitrate

## Installing Dependencies

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** (Latest version)
- **[FFmpeg](https://ffmpeg.org/)** (v4.4+ with AAC encoder support)

```bash
# Debian/Ubuntu
sudo apt update && sudo apt install -y ffmpeg python3-pip
sudo pip3 install yt-dlp
```

```bash
# macOS (Homebrew)
brew install ffmpeg yt-dlp
```

## Script Installation

```bash
git clone https://github.com/drewmarsh/youtube-to-m4b.git
cd youtube-to-m4b

chmod +x youtube-to-m4b.sh
```

## Interactive Mode Usage

```bash
./youtube-to-m4b.sh
```

#### The script will prompt you for:
- YouTube URL
- Quality level (1-5)
- Output filename (optional)

## Direct Command Execution
```bash
./youtube-to-m4b.sh "YOUTUBE_URL" QUALITY_LEVEL "OUTPUT_NAME"
```

#### Parameters:
- YOUTUBE_URL - Full URL to the YouTube video or playlist
- QUALITY_LEVEL - Audio quality setting (1-5)
- OUTPUT_NAME (optional) - Custom filename without extension

#### Examples:
```bash
# Basic conversion with recommended quality
./youtube-to-m4b.sh "https://youtu.be/dQw4w9WgXcQ" 3

# High quality with custom filename
./youtube-to-m4b.sh "https://youtu.be/dQw4w9WgXcQ" 4 "My Audiobook Title"

# Minimal file size conversion
./youtube-to-m4b.sh "https://youtu.be/dQw4w9WgXcQ" 1 "Compact Version"
```

#!/bin/bash

# Function to validate quality input
validate_quality() {
  [[ "$1" =~ ^[1-5]$ ]] || {
    echo "Invalid quality. Please enter a number between 1-5."
    return 1
  }
}

# Function to validate URL
validate_url() {
  [[ -z "$1" ]] && {
    echo "URL cannot be empty."
    return 1
  }
}

# Function to validate filename
validate_filename() {
  [[ -z "$1" ]] && {
    echo "Filename cannot be empty."
    return 1
  }
}

# Function to get user input with validation
get_input() {
  local prompt="$1"
  local validator="$2"
  local default="$3"
  local input=""
  
  while true; do
    read -p "$prompt" input
    [[ -z "$input" && -n "$default" ]] && input="$default"
    $validator "$input" && break
  done
  echo "$input"
}

# Main script
if [ $# -ge 2 ]; then
  url="$1"
  quality="$2"
  output_name="${3:-audiobook}"
  
  validate_quality "$quality" || exit 1
elif [ $# -eq 0 ]; then
  echo "======================================================"
  echo "       YouTube URL to .m4b Audiobook Converter"
  echo "======================================================"
  echo "Quality Levels:"
  echo "1. 64 kbps   (Smallest file size)"
  echo "2. 96 kbps   (Good balance)"
  echo "3. 128 kbps  (Recommended)"
  echo "4. 192 kbps  (High quality)"
  echo "5. 256 kbps  (Best quality)"
  echo ""
  
  url=$(get_input "Enter YouTube URL: " validate_url)
  quality=$(get_input "Select audio quality (1-5): " validate_quality)
  output_name=$(get_input "Enter output name [default: audiobook]: " validate_filename "audiobook")
else
  echo "Usage: $0 \"[URL]\" [QUALITY] \"[OUTPUT_NAME]\""
  echo "Examples:"
  echo "  Interactive mode: $0"
  echo "  Direct mode: $0 \"https://youtube.com/watch?v=...\" 3 \"Neverwhere (1996)\""
  exit 1
fi

# Map quality levels to bitrate targets
declare -A bitrate_map=(
  [1]="64k"
  [2]="96k"
  [3]="128k"
  [4]="192k"
  [5]="256k"
)

bitrate="${bitrate_map[$quality]}"
output_file="${output_name}.m4b"

echo "Starting conversion:"
echo "  URL: $url"
echo "  Quality: Level $quality ($bitrate)"
echo "  Output: $output_file"
echo ""

# Download audio
echo "Downloading audio from YouTube..."
yt-dlp -f "bestaudio" \
       --embed-metadata \
       --embed-chapters \
       -o "temp_audio.%(ext)s" \
       "$url" || exit 1

# Find downloaded file
downloaded_file=$(find . -maxdepth 1 -name 'temp_audio.*' -print -quit)
[[ -z "$downloaded_file" ]] && {
  echo "Error: Audio download failed"
  exit 1
}

# Convert to M4B
echo "Converting to M4B format..."
ffmpeg -i "$downloaded_file" -f ffmetadata ffmetadata.txt

ffmpeg -i "$downloaded_file" -i ffmetadata.txt \
       -map_metadata 1 \
       -c:a aac -b:a "$bitrate" \
       -movflags +faststart \
       -vn -dn "$output_file"

# Cleanup
rm -f "$downloaded_file" ffmetadata.txt
echo ""
echo "======================================================"
echo "Conversion complete!"
echo "Output file: $output_file"

# Get duration in human-readable format
duration_seconds=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file")
duration_formatted=$(awk -v t=$duration_seconds 'BEGIN{t=int(t*1000)/1000; printf "%dh %02dm %02ds\n", t/3600, t/60%60, t%60}')

# Get actual bitrate
actual_bitrate=$(ffprobe -v error -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$output_file" | awk 'NR==1{printf "%.0f kbps", $1/1000}')

echo "Duration: $duration_formatted"
echo "Bitrate: $actual_bitrate"
echo "======================================================"
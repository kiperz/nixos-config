#!/usr/bin/env bash
# Toggle screen recording with gpu-screen-recorder (NVENC)

RECORDINGS_DIR="$HOME/Videos/Recordings"
PIDFILE="/tmp/gpu-screen-recorder.pid"

mkdir -p "$RECORDINGS_DIR"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  # Stop recording
  kill "$(cat "$PIDFILE")"
  rm -f "$PIDFILE"
  notify-send "Recording" "Screen recording saved to $RECORDINGS_DIR" --icon=media-record
else
  # Start recording
  FILENAME="$RECORDINGS_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
  gpu-screen-recorder -w screen -f 60 -a default_output -o "$FILENAME" &
  echo $! > "$PIDFILE"
  notify-send "Recording" "Screen recording started..." --icon=media-record
fi

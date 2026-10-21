#!/usr/bin/env python3
"""Trim the raw simulator recording to the app tour and compress it for the repository.

The recording starts long before the app is on screen (home screen, test runner launch,
white launch screen) and keeps running after the test tears the app down. The UI test
prints `TOUR_START <epoch>` / `TOUR_END <epoch>`; together with the wall-clock time the
recording started, they give rough cut points. The start is then snapped to the end of the
white launch screen, found with ffmpeg's blackdetect on the inverted video.

usage: trim_video.py RAW_VIDEO XCODEBUILD_LOG RECORDING_START_EPOCH OUTPUT
"""

import re
import subprocess
import sys

raw, log_path, rec_start, output = sys.argv[1], sys.argv[2], float(sys.argv[3]), sys.argv[4]


def marker(name, log):
    match = re.search(rf"{name} (\d+(?:\.\d+)?)", log)
    return float(match.group(1)) - rec_start if match else None


def duration(path):
    out = subprocess.check_output(["ffprobe", "-v", "error", "-show_entries", "format=duration",
                                   "-of", "default=nw=1:nk=1", path], text=True)
    return float(out)


def white_screens(path):
    """(start, end) of every stretch where the screen is almost entirely white."""
    result = subprocess.run(
        ["ffmpeg", "-hide_banner", "-i", path, "-an",
         "-vf", "scale=-2:480,negate,blackdetect=d=0.3:pix_th=0.12:pic_th=0.97", "-f", "null", "-"],
        capture_output=True, text=True)
    return [(float(a), float(b)) for a, b in re.findall(r"black_start:([\d.]+) black_end:([\d.]+)", result.stderr)]


log = open(log_path, encoding="utf-8", errors="replace").read()
length = duration(raw)
tour_start, tour_end = marker("TOUR_START", log), marker("TOUR_END", log)
print(f"recording {length:.1f}s, markers start={tour_start} end={tour_end}")

start = 0.0
if tour_start is not None:
    start = max(tour_start - 1.0, 0.0)
    # The launch screen ends a moment before the test sees the hero image.
    launch_ends = [end for _, end in white_screens(raw) if tour_start - 15 <= end <= tour_start + 2]
    if launch_ends:
        start = max(launch_ends) + 0.05
end = min(tour_end + 0.3, length) if tour_end is not None else length
if end <= start:
    start, end = 0.0, length
print(f"keeping {start:.2f}s – {end:.2f}s")

subprocess.run(
    ["ffmpeg", "-y", "-loglevel", "error", "-ss", f"{start:.2f}", "-to", f"{end:.2f}", "-i", raw,
     "-vf", "scale=-2:1920,fps=30", "-c:v", "libx264", "-preset", "slow", "-crf", "26",
     "-pix_fmt", "yuv420p", "-movflags", "+faststart", "-an", output],
    check=True)

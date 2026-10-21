#!/usr/bin/env python3
"""Print the UDID of an available simulator with the given name (newest iOS runtime wins)."""

import json
import subprocess
import sys

name = sys.argv[1] if len(sys.argv) > 1 else "iPhone 18 Pro Max"
devices = json.loads(subprocess.check_output(["xcrun", "simctl", "list", "devices", "available", "-j"]))["devices"]


def runtime_version(runtime):
    # com.apple.CoreSimulator.SimRuntime.iOS-27-0 -> (27, 0)
    parts = runtime.rsplit(".", 1)[-1].split("-")[1:]
    return tuple(int(p) for p in parts if p.isdigit())


candidates = [
    (runtime_version(runtime), device["udid"], runtime)
    for runtime, items in devices.items()
    if ".iOS-" in runtime
    for device in items
    if device["name"] == name
]
if not candidates:
    sys.exit(f"No available simulator named {name!r}")

version, udid, runtime = max(candidates)
print(f"Using {name} on {runtime} ({udid})", file=sys.stderr)
print(udid)

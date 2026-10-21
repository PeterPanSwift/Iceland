#!/usr/bin/env python3
"""Search Wikimedia Commons for Iceland landmark photos and bundle them into the app.

Runs in CI before the Xcode project is generated. For every photo id it tries a
list of searches (featured pictures first, then quality images, then anything)
and keeps the first landscape JPEG that is large enough. Attribution for every
downloaded file is written to credits.json, which the app shows on its About tab.
"""

import html
import json
import re
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

API = "https://commons.wikimedia.org/w/api.php"
USER_AGENT = "IcelandSwiftUIDemo/1.0 (https://github.com/PeterPanSwift/Iceland; GitHub Actions)"
OUT_DIR = Path(__file__).resolve().parent.parent / "Iceland" / "Resources" / "Photos"
THUMB_WIDTH = 1280

# photo id -> Commons search terms
PHOTOS = {
    "aurora": "Aurora borealis Iceland",
    "reykjavik": "Reykjavik Hallgrimskirkja city view",
    "blue-lagoon": "Blue Lagoon Iceland",
    "gullfoss": "Gullfoss",
    "geysir": "Strokkur eruption",
    "thingvellir": "Þingvellir",
    "seljalandsfoss": "Seljalandsfoss",
    "skogafoss": "Skógafoss",
    "reynisfjara": "Reynisfjara",
    "jokulsarlon": "Jökulsárlón",
    "kirkjufell": "Kirkjufell",
    "hallgrimskirkja": "Hallgrímskirkja",
    "dettifoss": "Dettifoss",
    "myvatn": "Mývatn",
}

CATEGORY_FILTERS = [
    'incategory:"Featured pictures of Iceland"',
    'incategory:"Quality images of Iceland"',
    "",
]


def get_json(params):
    url = API + "?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.load(resp)


def download(url, dest):
    for attempt in range(4):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
            with urllib.request.urlopen(req, timeout=60) as resp:
                dest.write_bytes(resp.read())
            return True
        except Exception as exc:  # noqa: BLE001 - retry on any network error
            print(f"    download failed ({exc}), retrying", file=sys.stderr)
            time.sleep(2 ** attempt)
    return False


def strip_html(text):
    return html.unescape(re.sub(r"<[^>]+>", "", text or "")).strip()


def search(terms):
    data = get_json({
        "action": "query",
        "format": "json",
        "generator": "search",
        "gsrnamespace": "6",
        "gsrsearch": f"{terms} filetype:bitmap",
        "gsrlimit": "25",
        "prop": "imageinfo",
        "iiprop": "url|size|mime|extmetadata",
        "iiurlwidth": str(THUMB_WIDTH),
        "iiextmetadatafilter": "Artist|LicenseShortName",
    })
    pages = sorted(data.get("query", {}).get("pages", {}).values(), key=lambda p: p.get("index", 0))
    for page in pages:
        info = (page.get("imageinfo") or [{}])[0]
        width, height = info.get("width", 0), info.get("height", 0)
        if info.get("mime") != "image/jpeg" or height == 0:
            continue
        if width < 1800 or not 1.2 <= width / height <= 2.2:
            continue
        meta = info.get("extmetadata", {})
        return {
            "title": page["title"],
            "thumb": info.get("thumburl") or info["url"],
            "page": info.get("descriptionurl", ""),
            "artist": strip_html(meta.get("Artist", {}).get("value")) or "Unknown",
            "license": strip_html(meta.get("LicenseShortName", {}).get("value")) or "See Commons",
        }
    return None


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    credits = []
    for photo_id, query in PHOTOS.items():
        choice = None
        for category in CATEGORY_FILTERS:
            try:
                choice = search(f"{query} {category}".strip())
            except Exception as exc:  # noqa: BLE001
                print(f"  search error for {photo_id}: {exc}", file=sys.stderr)
            if choice:
                break
            time.sleep(0.5)
        if not choice:
            print(f"✗ {photo_id}: no suitable photo found")
            continue
        dest = OUT_DIR / f"{photo_id}.jpg"
        if download(choice["thumb"], dest):
            print(f"✓ {photo_id}: {choice['title']} — {choice['artist']} ({choice['license']})")
            credits.append({"id": photo_id, **{k: choice[k] for k in ("title", "page", "artist", "license")}})
        time.sleep(0.5)

    (OUT_DIR / "credits.json").write_text(json.dumps(credits, ensure_ascii=False, indent=2))
    print(f"Downloaded {len(credits)}/{len(PHOTOS)} photos into {OUT_DIR}")
    if len(credits) < len(PHOTOS) // 2:
        sys.exit("Too many photos missing")


if __name__ == "__main__":
    main()

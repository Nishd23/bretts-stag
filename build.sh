#!/bin/sh
# Builds the standalone GitHub Pages site in docs/ from index.html (the artifact page).
# index.html has no <html>/<head>/<body> of its own, so this wraps it: everything
# before the hero header goes in <head>, the rest in <body>.
set -e
cd "$(dirname "$0")"

SITE_URL="https://bretts-stag.vercel.app"

rm -rf docs
mkdir -p docs
cp -R img docs/img
touch docs/.nojekyll

python3 -I - "$SITE_URL" <<'EOF'
import pathlib, sys
site = sys.argv[1]
src = pathlib.Path("index.html").read_text()
split = src.index('<header class="hero">')
head, body = src[:split], src[split:]
page = f'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="robots" content="noindex, nofollow">
<meta name="description" content="Brett's stag weekend in Melbourne: Boxing Day Test at the MCG, then bowls, a Fitzroy pub crawl, karaoke and Crown.">
<meta property="og:title" content="Brett's Stag Weekend">
<meta property="og:description" content="Boxing Day Test, bowls, a Fitzroy pub crawl, karaoke and Crown. 26–27 Dec 2026.">
<meta property="og:image" content="{site}/img/mcg.jpg">
<meta property="og:url" content="{site}/">
<style>
:root {{ color-scheme: light; padding-top: env(safe-area-inset-top, 0px); padding-bottom: env(safe-area-inset-bottom, 0px); }}
body {{ margin: 0; font: 14px system-ui, -apple-system, "Segoe UI", sans-serif; }}
img {{ max-width: 100%; }}
[hidden] {{ display: none !important; }}
</style>
{head.strip()}
</head>
<body>
{body.strip()}
</body>
</html>
'''
pathlib.Path("docs/index.html").write_text(page)
EOF

echo "Built docs/ for $SITE_URL"

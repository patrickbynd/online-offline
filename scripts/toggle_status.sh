#!/usr/bin/env bash
set -eo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_DIR="${ROOT_DIR}/status"
STATUS_FILE="${STATUS_DIR}/state.txt"

mkdir -p "${STATUS_DIR}"

CURRENT_STATE="offline"
if [ -f "${STATUS_FILE}" ]; then
  CURRENT_STATE="$(cat "${STATUS_FILE}")"
fi

if [ "${CURRENT_STATE}" = "online" ]; then
  NEXT_STATE="offline"
else
  NEXT_STATE="online"
fi

echo "${NEXT_STATE}" > "${STATUS_FILE}"

for PAGE in index about contact; do
  cp "${ROOT_DIR}/templates/${NEXT_STATE}/${PAGE}.html" "${ROOT_DIR}/${PAGE}.html"
done

DEFAULT_BASE_URL="https://example.github.io/beacon-tests"
if [ -n "${GITHUB_REPOSITORY}" ]; then
  OWNER="${GITHUB_REPOSITORY%%/*}"
  REPO="${GITHUB_REPOSITORY##*/}"
  BASE_URL="https://${OWNER}.github.io/${REPO}"
else
  BASE_URL="${DEFAULT_BASE_URL}"
fi

cat > "${ROOT_DIR}/sitemap.xml" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>${BASE_URL}/index.html</loc>
    <changefreq>always</changefreq>
  </url>
  <url>
    <loc>${BASE_URL}/about.html</loc>
    <changefreq>always</changefreq>
  </url>
  <url>
    <loc>${BASE_URL}/contact.html</loc>
    <changefreq>always</changefreq>
  </url>
</urlset>
EOF

if [ -n "${GITHUB_ENV}" ]; then
  echo "next_state=${NEXT_STATE}" >> "${GITHUB_ENV}"
fi

echo "Site switched from ${CURRENT_STATE} to ${NEXT_STATE}."


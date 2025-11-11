# Plain Three-Page Site

This repository contains an extremely simple static website with three pages (`index.html`, `about.html`, and `contact.html`) plus a generated `sitemap.xml`.  A scheduled GitHub Actions workflow toggles the site between an “online” and “offline” set of pages every five minutes.

## How it works

- The `templates/online` and `templates/offline` directories hold the two versions of each page.
- The `scripts/toggle_status.sh` script copies the appropriate template set into the repository root, writes the current state to `status/state.txt`, and regenerates `sitemap.xml`.
- `.github/workflows/toggle-site.yml` runs the toggle script on a cron schedule (`*/5 * * * *`) and commits the resulting changes back to the default branch. The workflow also supports manual triggering through the **Run workflow** button.

## Getting started

1. Create a new repository on GitHub and push this project’s contents to it.
2. In the repository settings, enable GitHub Pages:
   - Navigate to **Settings → Pages**.
   - Choose the **Deploy from a branch** option and select the default branch (usually `main`) at the root (`/`) folder.
3. Commit and push any changes (the initial `index.html`, `about.html`, `contact.html`, and `sitemap.xml` files are already in the repository root). GitHub Pages will publish the site automatically.

## Scheduled online/offline toggling

- The workflow uses the default `GITHUB_TOKEN` with `contents: write` permissions to commit the updated pages.
- Every five minutes the workflow switches between the online and offline templates. You can run it immediately under **Actions → Toggle Site Availability → Run workflow**.
- When the workflow runs on GitHub, the sitemap’s base URL is set automatically from the repository owner and name (`https://OWNER.github.io/REPO`). The fallback value inside the script (`https://example.github.io/beacon-tests`) only appears if the script is executed outside GitHub Actions.

## Customization tips

- Edit the HTML in `templates/online` and `templates/offline` to change the content served in each state.
- Update `scripts/toggle_status.sh` if you want to add more pages—just add the filenames to the loop that copies templates.
- Adjust the cron expression inside `.github/workflows/toggle-site.yml` to change how frequently the site flips between states.
- If you prefer a different default sitemap domain for local runs, change the `DEFAULT_BASE_URL` value in `scripts/toggle_status.sh`.


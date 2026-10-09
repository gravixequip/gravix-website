# Gravix Equipment Solutions LLP — GitHub Pages Version

This package is the static GitHub Pages version of the Gravix website. It does **not** require Netlify, Netlify Functions, or the old Express backend.

## What changed

- Removed Netlify/server API dependencies.
- RFQ form sends the inquiry to `gravixequip@gmail.com` using FormSubmit.
- Catalogue requests are also sent by email.
- Removed the insecure/non-persistent admin backend from the deployable package.
- Added a GitHub Pages deployment workflow.
- Updated canonical, Open Graph, robots, sitemap and structured-data URLs to `https://gravixequip.github.io/gravix-website/`.
- Added `.nojekyll` for static hosting.

## Publish

1. Replace the files in the `gravixequip/gravix-website` repository with these files and push to the `main` branch.
2. In GitHub: **Settings → Pages → Build and deployment → Source → Deploy from a branch (main / root)**.
3. The site URL is `https://gravixequip.github.io/gravix-website/`.

## Important: FormSubmit activation

On the first real form submission, FormSubmit may send an activation/confirmation email to `gravixequip@gmail.com`. Open that email and confirm it so future RFQ and catalogue messages are delivered.

## Custom domain later

When you purchase the domain, configure it in **GitHub repository Settings → Pages → Custom domain**. Then update the canonical URL, Open Graph URL/image, Schema.org URL, `robots.txt`, and `sitemap.xml` to the new domain.

## Hosting limitation

GitHub Pages is static hosting. It cannot securely run a private admin API or permanently store customer leads by itself. In this version, leads are delivered by email instead of being stored in a public/static admin database. If a real admin dashboard is needed later, connect a separate backend/database service.

# Deployment — Railway

Both services (Next.js + Flutter Web) are hosted on Railway.
Auto-deploys on every push to `main`.

---

## Step 1 — Push code to GitHub

```bash
git add .
git commit -m "add deployment config"
git push origin main
```

---

## Step 2 — Deploy Flutter service

1. Go to https://railway.app → **New Project** → **Deploy from GitHub repo** → `COINPILOT`
2. In service settings → **Source** → set **Root Directory** to `flutter-app`
3. Railway detects the Dockerfile automatically → click **Deploy**
4. **Settings → Networking → Generate Domain**
5. Copy the URL (e.g. `flutter-xxxx.up.railway.app`)

---

## Step 3 — Deploy Next.js service

1. In the same Railway project → **Add Service** → **GitHub Repo** → `COINPILOT`
2. In service settings → **Source** → set **Root Directory** to `nextjs-app`
3. Go to service **Variables** and add:

| Variable | Value |
|----------|-------|
| `NEXT_PUBLIC_FLUTTER_DASHBOARD_URL` | `https://flutter-xxxx.up.railway.app/dashboard` |
| `FLUTTER_APP_URL` | `https://flutter-xxxx.up.railway.app` |
| `NODE_ENV` | `production` |

4. **Settings → Networking → Generate Domain** → click **Deploy**

---

## Result

| | URL |
|-|-----|
| Landing / Auth / Blog | `https://nextjs-xxxx.up.railway.app` |
| Dashboard | `https://flutter-xxxx.up.railway.app/dashboard` |

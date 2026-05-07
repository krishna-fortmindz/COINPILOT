/**
 * Local dev proxy — mirrors the production nginx config.
 * Runs on :8080 and routes:
 *   /dashboard, /analysis, /charts, /memory, /sentiment,
 *   /listings, /risk, /journal, /chat, /alerts, /profile
 *   + all Flutter static assets  →  Flutter (:5001)
 *
 *   everything else               →  Next.js (:3000)
 *
 * Referer-based routing: any asset requested from a Flutter page
 * is also routed to Flutter, covering unpredictable DDC filenames.
 */

const http = require("http");
const httpProxy = require("http-proxy");

const NEXTJS_URL = "http://localhost:3000";
const FLUTTER_URL = "http://localhost:5001";
const PROXY_PORT = 8080;

// Routes that belong to the Flutter dashboard
const FLUTTER_APP_ROUTES = [
  "/dashboard",
  "/analysis",
  "/charts",
  "/memory",
  "/sentiment",
  "/listings",
  "/risk",
  "/journal",
  "/chat",
  "/alerts",
  "/profile",
];

// Known Flutter static asset patterns (fallback for direct asset requests)
const FLUTTER_ASSET_PATTERNS = [
  /^\/main\.dart\.js/,
  /^\/flutter\.js/,
  /^\/flutter_bootstrap\.js/,
  /^\/flutter_service_worker\.js/,
  /^\/canvaskit\//,
  /^\/assets\//,
  /^\/icons\//,
  /^\/version\.json/,
  /^\/stack_trace_mapper\.js/,
  /^\/ddc_module_loader\.js/,
  /^\/dart_sdk\.js/,
  /^\/[^/]+\.ddc\.js/,
  /^\/[^/]+\.dart\.lib\.js/,
  /^\/[^/]+\.bootstrap\.js/,
  /^\/favicon\.png/,
  /^\/manifest\.json/,
  /^\/site\.webmanifest/,
];

function isFlutterRoute(pathname) {
  return FLUTTER_APP_ROUTES.some(
    (r) => pathname === r || pathname.startsWith(r + "/")
  );
}

function isFlutterRequest(url, referer) {
  // Direct Flutter route
  if (isFlutterRoute(url)) return true;

  // Known Flutter asset pattern
  if (FLUTTER_ASSET_PATTERNS.some((re) => re.test(url))) return true;

  // Referer-based: asset requested from inside a Flutter page
  if (referer) {
    try {
      const refPath = new URL(referer).pathname;
      if (isFlutterRoute(refPath)) return true;
    } catch (_) {}
  }

  return false;
}

const proxy = httpProxy.createProxyServer({ ws: true });

proxy.on("error", (err, req, res) => {
  console.error(`[proxy error] ${req.url} →`, err.message);
  if (res && !res.headersSent) {
    res.writeHead(502, { "Content-Type": "text/plain" });
    res.end(`Proxy error: ${err.message}`);
  }
});

const server = http.createServer((req, res) => {
  const referer = req.headers["referer"] || req.headers["referrer"];
  if (isFlutterRequest(req.url, referer)) {
    // Rewrite app routes to / — Flutter's web server only serves index.html at root.
    // GoRouter handles deep-link routing client-side.
    if (isFlutterRoute(req.url)) req.url = "/";
    proxy.web(req, res, { target: FLUTTER_URL });
  } else {
    proxy.web(req, res, { target: NEXTJS_URL });
  }
});

// Forward WebSocket upgrades (Next.js HMR, Flutter hot-reload)
server.on("upgrade", (req, socket, head) => {
  const referer = req.headers["referer"] || req.headers["referrer"];
  const target = isFlutterRequest(req.url, referer) ? FLUTTER_URL : NEXTJS_URL;
  proxy.ws(req, socket, head, { target });
  // Note: WS upgrades are always asset/HMR paths, no route rewrite needed
});

server.listen(PROXY_PORT, () => {
  console.log("\n┌─────────────────────────────────────────────┐");
  console.log("│   AI Trading Copilot — Dev Proxy            │");
  console.log("├─────────────────────────────────────────────┤");
  console.log(`│   Proxy   →  http://localhost:${PROXY_PORT}          │`);
  console.log(`│   Next.js →  http://localhost:3000           │`);
  console.log(`│   Flutter →  http://localhost:5001           │`);
  console.log("└─────────────────────────────────────────────┘\n");
  console.log("  Open  http://localhost:8080  in your browser.\n");
});

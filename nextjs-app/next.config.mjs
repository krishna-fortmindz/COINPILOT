/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    optimizePackageImports: ["lucide-react", "framer-motion"],
    serverComponentsExternalPackages: ["socket.io-client", "engine.io-client"],
  },

  images: {
    remotePatterns: [
      { protocol: "https", hostname: "assets.coingecko.com" },
      { protocol: "https", hostname: "cryptologos.cc" },
      { protocol: "https", hostname: "coin-images.coingecko.com" },
    ],
  },

  async rewrites() {
    // In dev: proxy /app/* to local Flutter dev server
    if (process.env.NODE_ENV !== "production") {
      return [
        {
          source: "/app/:path*",
          destination: "http://localhost:5001/app/:path*",
        },
        {
          source: "/dashboard/:path*",
          destination: "http://localhost:5001/dashboard/:path*",
        },
        {
          source: "/analysis/:path*",
          destination: "http://localhost:5001/analysis/:path*",
        },
        {
          source: "/charts/:path*",
          destination: "http://localhost:5001/charts/:path*",
        },
        {
          source: "/chat/:path*",
          destination: "http://localhost:5001/chat/:path*",
        },
      ];
    }

    // In production: Flutter is embedded in public/app/ as static files.
    // Only rewrite /app and /app/ to serve Flutter's index.html.
    // All other /app/* requests (JS, WASM, assets) are served directly
    // from public/app/ by Next.js static file serving.
    return [
      { source: "/app", destination: "/app/index.html" },
      { source: "/app/", destination: "/app/index.html" },
      { source: "/app/:path*", destination: "/app/index.html" },
    ];
  },

  async headers() {
    return [
      {
        source: "/(.*)",
        headers: [
          { key: "X-Frame-Options", value: "DENY" },
          { key: "X-Content-Type-Options", value: "nosniff" },
          {
            key: "Referrer-Policy",
            value: "strict-origin-when-cross-origin",
          },
        ],
      },
    ];
  },
};

export default nextConfig;
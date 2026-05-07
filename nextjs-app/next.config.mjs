/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "standalone",
  experimental: {
    optimizePackageImports: ["lucide-react", "framer-motion"],
  },

  images: {
    remotePatterns: [
      { protocol: "https", hostname: "assets.coingecko.com" },
      { protocol: "https", hostname: "cryptologos.cc" },
      { protocol: "https", hostname: "coin-images.coingecko.com" },
    ],
  },

  async rewrites() {
    return [
      {
        source: "/dashboard/:path*",
        destination: process.env.FLUTTER_APP_URL
          ? `${process.env.FLUTTER_APP_URL}/dashboard/:path*`
          : "http://localhost:5001/dashboard/:path*",
      },

      {
        source: "/app/:path*",
        destination: process.env.FLUTTER_APP_URL
          ? `${process.env.FLUTTER_APP_URL}/app/:path*`
          : "http://localhost:5001/app/:path*",
      },

      {
        source: "/analysis/:path*",
        destination: process.env.FLUTTER_APP_URL
          ? `${process.env.FLUTTER_APP_URL}/analysis/:path*`
          : "http://localhost:5001/analysis/:path*",
      },

      {
        source: "/charts/:path*",
        destination: process.env.FLUTTER_APP_URL
          ? `${process.env.FLUTTER_APP_URL}/charts/:path*`
          : "http://localhost:5001/charts/:path*",
      },

      {
        source: "/chat/:path*",
        destination: process.env.FLUTTER_APP_URL
          ? `${process.env.FLUTTER_APP_URL}/chat/:path*`
          : "http://localhost:5001/chat/:path*",
      },
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
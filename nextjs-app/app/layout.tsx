import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_APP_URL || "https://aitradingcopilot.com"),
  title: {
    default: "AI Trading Copilot — Smarter Crypto Intelligence",
    template: "%s | AI Trading Copilot",
  },
  description:
    "AI-powered crypto trading intelligence platform. Analyze market conditions, detect patterns, manage risk, and make smarter trading decisions with cutting-edge AI.",
  keywords: [
    "crypto trading AI",
    "bitcoin analysis",
    "crypto intelligence",
    "trading copilot",
    "market sentiment",
    "risk management crypto",
    "AI trading assistant",
    "crypto pattern recognition",
  ],
  authors: [{ name: "AI Trading Copilot" }],
  creator: "AI Trading Copilot",
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "/",
    siteName: "AI Trading Copilot",
    title: "AI Trading Copilot — Smarter Crypto Intelligence",
    description:
      "The AI copilot that helps crypto traders analyze markets, detect patterns, and manage risk intelligently.",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "AI Trading Copilot Dashboard",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "AI Trading Copilot",
    description: "AI-powered crypto trading intelligence for smarter decisions.",
    images: ["/og-image.png"],
    creator: "@aitradingcopilot",
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  manifest: "/site.webmanifest",
  icons: {
    icon: "/favicon.ico",
    shortcut: "/favicon-16x16.png",
    apple: "/apple-touch-icon.png",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link
          rel="preconnect"
          href="https://fonts.gstatic.com"
          crossOrigin="anonymous"
        />
        <link
          href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=JetBrains+Mono:wght@400;500;600&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="bg-bg-primary text-white antialiased overflow-x-hidden">
        {children}
      </body>
    </html>
  );
}

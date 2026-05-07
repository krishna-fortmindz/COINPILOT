import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        bg: {
          primary: "#0a0b0f",
          secondary: "#0f1117",
          tertiary: "#13151d",
          card: "#141720",
          hover: "#1a1d28",
        },
        brand: {
          green: "#00ff88",
          "green-dim": "#00cc6a",
          "green-glow": "rgba(0,255,136,0.15)",
          red: "#ff3366",
          "red-dim": "#cc2952",
          blue: "#3b82f6",
          purple: "#8b5cf6",
          cyan: "#06b6d4",
        },
        border: {
          subtle: "rgba(255,255,255,0.06)",
          default: "rgba(255,255,255,0.10)",
          bright: "rgba(0,255,136,0.25)",
        },
      },
      fontFamily: {
        sans: ["var(--font-inter)", "system-ui", "sans-serif"],
        mono: ["var(--font-jetbrains)", "monospace"],
      },
      backgroundImage: {
        "gradient-radial": "radial-gradient(var(--tw-gradient-stops))",
        "gradient-hero":
          "radial-gradient(ellipse 80% 60% at 50% -20%, rgba(0,255,136,0.12) 0%, transparent 60%), radial-gradient(ellipse 60% 40% at 80% 80%, rgba(139,92,246,0.08) 0%, transparent 50%)",
        "gradient-card":
          "linear-gradient(135deg, rgba(255,255,255,0.04) 0%, rgba(255,255,255,0.01) 100%)",
        "glow-green":
          "radial-gradient(circle, rgba(0,255,136,0.25) 0%, transparent 70%)",
        "glow-purple":
          "radial-gradient(circle, rgba(139,92,246,0.2) 0%, transparent 70%)",
      },
      boxShadow: {
        "glow-green": "0 0 30px rgba(0,255,136,0.2), 0 0 60px rgba(0,255,136,0.08)",
        "glow-purple": "0 0 30px rgba(139,92,246,0.2)",
        "glow-blue": "0 0 30px rgba(59,130,246,0.2)",
        card: "0 1px 0 rgba(255,255,255,0.05), inset 0 1px 0 rgba(255,255,255,0.04)",
        "card-hover": "0 8px 32px rgba(0,0,0,0.4), 0 1px 0 rgba(255,255,255,0.08)",
      },
      animation: {
        "pulse-slow": "pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite",
        "float": "float 6s ease-in-out infinite",
        "glow-pulse": "glow-pulse 2s ease-in-out infinite",
        "slide-up": "slide-up 0.6s ease-out",
        "fade-in": "fade-in 0.8s ease-out",
        "ticker": "ticker 30s linear infinite",
        "spin-slow": "spin 8s linear infinite",
      },
      keyframes: {
        float: {
          "0%, 100%": { transform: "translateY(0px)" },
          "50%": { transform: "translateY(-12px)" },
        },
        "glow-pulse": {
          "0%, 100%": { opacity: "0.6" },
          "50%": { opacity: "1" },
        },
        "slide-up": {
          from: { opacity: "0", transform: "translateY(24px)" },
          to: { opacity: "1", transform: "translateY(0)" },
        },
        "fade-in": {
          from: { opacity: "0" },
          to: { opacity: "1" },
        },
        ticker: {
          "0%": { transform: "translateX(0)" },
          "100%": { transform: "translateX(-50%)" },
        },
      },
      backdropBlur: {
        xs: "2px",
      },
    },
  },
  plugins: [],
};

export default config;

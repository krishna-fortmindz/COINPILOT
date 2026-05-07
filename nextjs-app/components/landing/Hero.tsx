"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { ArrowRight, Play, TrendingUp, TrendingDown, Zap, Activity } from "lucide-react";

const CHART_POINTS = [
  42, 45, 43, 48, 52, 49, 55, 58, 54, 60, 64, 61, 58, 62, 68, 72, 69, 74, 78, 75,
  80, 77, 82, 85, 88, 84, 79, 83, 87, 91, 88, 93, 97, 94, 99, 102, 98, 104, 108, 105,
];

function MiniChart({ positive = true }: { positive?: boolean }) {
  const width = 120;
  const height = 40;
  const points = CHART_POINTS.slice(-20);
  const min = Math.min(...points);
  const max = Math.max(...points);
  const normalize = (v: number) => height - ((v - min) / (max - min)) * height;
  const pathD = points
    .map((v, i) => `${i === 0 ? "M" : "L"} ${(i / (points.length - 1)) * width} ${normalize(v)}`)
    .join(" ");

  const color = positive ? "#00ff88" : "#ff3366";
  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`}>
      <defs>
        <linearGradient id={`grad-${positive}`} x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={color} stopOpacity="0.3" />
          <stop offset="100%" stopColor={color} stopOpacity="0" />
        </linearGradient>
      </defs>
      <path
        d={`${pathD} L ${width} ${height} L 0 ${height} Z`}
        fill={`url(#grad-${positive})`}
      />
      <path d={pathD} fill="none" stroke={color} strokeWidth="1.5" strokeLinecap="round" />
    </svg>
  );
}

const tickerItems = [
  { symbol: "BTC", price: "$97,420", change: "+2.4%", up: true },
  { symbol: "ETH", price: "$3,842", change: "+1.8%", up: true },
  { symbol: "SOL", price: "$184", change: "-0.9%", up: false },
  { symbol: "BNB", price: "$612", change: "+3.1%", up: true },
  { symbol: "ARB", price: "$1.24", change: "+5.6%", up: true },
  { symbol: "AVAX", price: "$38.20", change: "-1.4%", up: false },
  { symbol: "LINK", price: "$18.60", change: "+2.2%", up: true },
  { symbol: "INJ", price: "$28.40", change: "+4.3%", up: true },
];

export default function Hero() {
  const [aiText, setAiText] = useState("");
  const fullText =
    "BTC is showing strong bullish momentum. RSI at 67 — not yet overbought. Key resistance at $98.4K. Funding rates neutral. Consider scaling positions on pullbacks to $95K support.";

  useEffect(() => {
    let i = 0;
    const interval = setInterval(() => {
      if (i <= fullText.length) {
        setAiText(fullText.slice(0, i));
        i++;
      } else {
        clearInterval(interval);
      }
    }, 25);
    return () => clearInterval(interval);
  }, []);

  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center overflow-hidden pt-16">
      {/* Background layers */}
      <div className="absolute inset-0 grid-bg opacity-60" />
      <div className="absolute inset-0 bg-gradient-hero" />
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 w-[600px] h-[600px] rounded-full"
        style={{ background: "radial-gradient(circle, rgba(0,255,136,0.06) 0%, transparent 70%)" }} />

      {/* Ticker tape */}
      <div className="absolute top-16 left-0 right-0 overflow-hidden py-3 border-b border-white/5"
        style={{ background: "rgba(10,11,15,0.8)" }}>
        <div className="flex">
          <div className="ticker-tape">
            {[...tickerItems, ...tickerItems].map((item, i) => (
              <div key={i} className="flex items-center gap-2 whitespace-nowrap">
                <span className="text-xs font-mono font-semibold text-white/70">{item.symbol}</span>
                <span className="text-xs font-mono font-bold text-white">{item.price}</span>
                <span className={`text-xs font-mono font-semibold ${item.up ? "text-[#00ff88]" : "text-[#ff3366]"}`}>
                  {item.change}
                </span>
                <span className="text-white/10 mx-2">|</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-16 pb-8">
        {/* Badge */}
        <div className="flex justify-center mb-8">
          <div className="badge-green animate-pulse-slow">
            <Activity className="w-3 h-3" />
            <span>AI Market Analysis Live</span>
          </div>
        </div>

        {/* Headline */}
        <div className="text-center max-w-4xl mx-auto mb-8">
          <h1 className="text-5xl sm:text-6xl lg:text-7xl font-black tracking-tight leading-[1.05] mb-6">
            <span className="gradient-text">Your AI Trading</span>
            <br />
            <span className="gradient-text-green">Copilot</span>{" "}
            <span className="gradient-text">for Smarter</span>
            <br />
            <span className="gradient-text">Crypto Decisions</span>
          </h1>
          <p className="text-lg sm:text-xl text-white/50 max-w-2xl mx-auto leading-relaxed">
            Not a bot that promises 100% wins. An AI intelligence layer that helps you{" "}
            <span className="text-white/80 font-medium">analyze markets</span>,{" "}
            <span className="text-white/80 font-medium">detect patterns</span>, and{" "}
            <span className="text-white/80 font-medium">manage risk</span> like a professional trader.
          </p>
        </div>

        {/* CTAs */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-16">
          <Link href="/auth/signup" className="btn-primary group text-base px-8 py-4">
            Start Free — No Card Needed
            <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
          </Link>
          <a
            href={process.env.NEXT_PUBLIC_FLUTTER_DASHBOARD_URL ?? "http://localhost:8080/dashboard"}
            className="btn-secondary text-base px-8 py-4 group"
          >
            Open Dashboard
            <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
          </a>
          <button className="flex items-center gap-2.5 text-sm text-white/50 hover:text-white/80 transition-colors group">
            <div className="w-9 h-9 rounded-full border border-white/10 flex items-center justify-center group-hover:border-white/20 transition-colors">
              <Play className="w-3.5 h-3.5 ml-0.5" />
            </div>
            Watch Demo
          </button>
        </div>

        {/* Dashboard Preview Cards */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 max-w-5xl mx-auto">
          {/* AI Analysis Card */}
          <div className="lg:col-span-2 glass-card p-5 relative overflow-hidden group hover:border-white/10 transition-all duration-300">
            <div className="absolute top-0 right-0 w-32 h-32 rounded-full -mr-16 -mt-16"
              style={{ background: "radial-gradient(circle, rgba(0,255,136,0.06) 0%, transparent 70%)" }} />
            <div className="flex items-center gap-2 mb-4">
              <div className="w-2 h-2 rounded-full bg-[#00ff88] animate-pulse" />
              <span className="text-xs text-white/40 font-mono uppercase tracking-wider">AI Market Summary</span>
            </div>
            <div className="flex items-start gap-3">
              <div className="w-8 h-8 rounded-lg flex-shrink-0 flex items-center justify-center"
                style={{ background: "linear-gradient(135deg, #00ff88, #00cc6a)" }}>
                <Zap className="w-4 h-4 text-black" />
              </div>
              <p className="text-sm text-white/80 leading-relaxed font-mono">
                {aiText}
                <span className="inline-block w-0.5 h-3.5 bg-[#00ff88] ml-0.5 animate-pulse" />
              </p>
            </div>
            <div className="mt-4 flex items-center gap-4 pt-4 border-t border-white/5">
              <div className="flex items-center gap-1.5">
                <span className="text-xs text-white/30">Sentiment</span>
                <span className="badge-green text-[10px]">Bullish 74%</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="text-xs text-white/30">Confidence</span>
                <span className="text-xs font-mono font-semibold text-white/70">High</span>
              </div>
            </div>
          </div>

          {/* Market Cards Column */}
          <div className="flex flex-col gap-4">
            {/* BTC Card */}
            <div className="glass-card p-4 hover:border-white/10 transition-all duration-300">
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-2">
                  <div className="w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold"
                    style={{ background: "linear-gradient(135deg, #f7931a, #e8820a)" }}>
                    ₿
                  </div>
                  <div>
                    <div className="text-xs font-semibold text-white">BTC</div>
                    <div className="text-[10px] text-white/30">Bitcoin</div>
                  </div>
                </div>
                <span className="badge-green text-[10px]">+2.4%</span>
              </div>
              <div className="flex items-end justify-between">
                <span className="text-lg font-bold font-mono text-white">$97,420</span>
                <MiniChart positive />
              </div>
            </div>

            {/* Fear & Greed */}
            <div className="glass-card p-4 hover:border-white/10 transition-all duration-300">
              <div className="text-[10px] text-white/30 uppercase tracking-wider mb-2">Fear & Greed</div>
              <div className="flex items-center gap-3">
                <div className="relative w-12 h-12">
                  <svg viewBox="0 0 36 36" className="w-12 h-12 -rotate-90">
                    <circle cx="18" cy="18" r="15.9" fill="none" stroke="rgba(255,255,255,0.05)" strokeWidth="3" />
                    <circle cx="18" cy="18" r="15.9" fill="none" stroke="#00ff88" strokeWidth="3"
                      strokeDasharray="72 28" strokeLinecap="round" />
                  </svg>
                  <div className="absolute inset-0 flex items-center justify-center">
                    <span className="text-xs font-bold text-[#00ff88]">72</span>
                  </div>
                </div>
                <div>
                  <div className="text-sm font-semibold text-white">Greed</div>
                  <div className="text-xs text-white/40">Market is greedy</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Social proof */}
        <div className="flex flex-wrap items-center justify-center gap-6 mt-12 text-sm text-white/30">
          <span>Trusted by</span>
          <span className="font-semibold text-white/60">12,000+ traders</span>
          <span className="w-1 h-1 rounded-full bg-white/20" />
          <span>$2.4B+ analyzed daily</span>
          <span className="w-1 h-1 rounded-full bg-white/20" />
          <span>99.9% uptime</span>
          <span className="w-1 h-1 rounded-full bg-white/20" />
          <span>Real-time data</span>
        </div>
      </div>
    </section>
  );
}

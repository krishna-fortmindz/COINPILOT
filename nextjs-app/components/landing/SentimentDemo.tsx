"use client";

import { Twitter, MessageSquare, TrendingUp, TrendingDown, Activity } from "lucide-react";

const sentimentSources = [
  { label: "Twitter/X", value: 68, positive: true, icon: Twitter, color: "#1d9bf0", count: "124K posts" },
  { label: "Reddit", value: 71, positive: true, icon: MessageSquare, color: "#ff4500", count: "18.2K comments" },
  { label: "Whale Activity", value: 82, positive: true, icon: Activity, color: "#00ff88", count: "14 large txns" },
];

const newsItems = [
  { title: "BlackRock Bitcoin ETF records 3rd largest inflow day", sentiment: "bullish", ago: "2h ago" },
  { title: "Fed signals potential rate pause in Q2 2026", sentiment: "bullish", ago: "4h ago" },
  { title: "Crypto exchange sees $400M in open interest added", sentiment: "neutral", ago: "5h ago" },
  { title: "BTC miner selling pressure near 5-year low", sentiment: "bullish", ago: "7h ago" },
];

export default function SentimentDemo() {
  const overallSentiment = 72;

  return (
    <section className="py-24 relative overflow-hidden">
      <div className="absolute inset-0 grid-bg opacity-30" />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <div className="badge-green inline-flex mb-4">
            <Activity className="w-3 h-3" />
            <span>Sentiment Intelligence</span>
          </div>
          <h2 className="section-heading mb-4">
            Know what the market{" "}
            <span className="gradient-text-green">is feeling</span>
          </h2>
          <p className="section-subheading max-w-xl mx-auto">
            Aggregate sentiment from social, on-chain, and institutional signals into one clear picture.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Overall Meter */}
          <div className="glass-card p-6 flex flex-col items-center text-center">
            <div className="text-xs text-white/30 uppercase tracking-wider font-mono mb-6">Overall Sentiment</div>
            <div className="relative w-36 h-36 mb-6">
              <svg viewBox="0 0 100 100" className="w-full h-full -rotate-90">
                <circle cx="50" cy="50" r="42" fill="none" stroke="rgba(255,255,255,0.05)" strokeWidth="8" />
                <circle
                  cx="50" cy="50" r="42" fill="none"
                  stroke="url(#sentimentGrad)" strokeWidth="8"
                  strokeLinecap="round"
                  strokeDasharray={`${overallSentiment * 2.64} ${264 - overallSentiment * 2.64}`}
                />
                <defs>
                  <linearGradient id="sentimentGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                    <stop offset="0%" stopColor="#00ff88" />
                    <stop offset="100%" stopColor="#00cc6a" />
                  </linearGradient>
                </defs>
              </svg>
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <span className="text-3xl font-black text-white">{overallSentiment}</span>
                <span className="text-[10px] text-white/30 uppercase tracking-wider">Bullish</span>
              </div>
            </div>
            <div className="w-full space-y-2">
              {["Extreme Fear", "Fear", "Neutral", "Greed", "Extreme Greed"].map((label, i) => {
                const active = i === 3;
                return (
                  <div key={i} className={`flex items-center justify-between text-xs px-3 py-1.5 rounded-lg transition-all ${
                    active ? "bg-[#00ff88]/10 text-[#00ff88]" : "text-white/30"
                  }`}>
                    <span>{label}</span>
                    {active && <div className="w-1.5 h-1.5 rounded-full bg-[#00ff88] animate-pulse" />}
                  </div>
                );
              })}
            </div>
          </div>

          {/* Source Breakdown */}
          <div className="glass-card p-6">
            <div className="text-xs text-white/30 uppercase tracking-wider font-mono mb-5">Source Breakdown</div>
            <div className="space-y-5">
              {sentimentSources.map((source, i) => {
                const Icon = source.icon;
                return (
                  <div key={i}>
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <Icon className="w-3.5 h-3.5" style={{ color: source.color }} />
                        <span className="text-sm font-medium text-white">{source.label}</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-white/30">{source.count}</span>
                        <span className="text-sm font-mono font-bold" style={{ color: source.color }}>
                          {source.value}%
                        </span>
                      </div>
                    </div>
                    <div className="h-1.5 bg-white/5 rounded-full overflow-hidden">
                      <div
                        className="h-full rounded-full transition-all duration-1000"
                        style={{ width: `${source.value}%`, background: source.color }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>

            <div className="mt-6 pt-5 border-t border-white/5">
              <div className="flex items-center justify-between mb-3">
                <span className="text-xs text-white/30 uppercase tracking-wider">Sentiment Timeline</span>
              </div>
              <div className="flex items-end gap-1 h-14">
                {[35, 42, 55, 60, 58, 65, 71, 68, 72, 75, 72, 74, 78, 72].map((val, i) => (
                  <div
                    key={i}
                    className="flex-1 rounded-sm transition-all"
                    style={{
                      height: `${val}%`,
                      background: val > 65 ? "#00ff88" : val > 50 ? "#f59e0b" : "#ff3366",
                      opacity: i === 13 ? 1 : 0.4 + i * 0.04,
                    }}
                  />
                ))}
              </div>
            </div>
          </div>

          {/* News Feed */}
          <div className="glass-card p-6">
            <div className="flex items-center justify-between mb-5">
              <div className="text-xs text-white/30 uppercase tracking-wider font-mono">AI News Digest</div>
              <div className="w-2 h-2 rounded-full bg-[#00ff88] animate-pulse" />
            </div>
            <div className="space-y-3">
              {newsItems.map((item, i) => (
                <div
                  key={i}
                  className="p-3 rounded-xl border border-white/5 hover:border-white/10 transition-all cursor-pointer group"
                >
                  <div className="flex items-start justify-between gap-2 mb-1.5">
                    <span
                      className={`text-[10px] font-semibold uppercase tracking-wider px-1.5 py-0.5 rounded ${
                        item.sentiment === "bullish"
                          ? "bg-[#00ff88]/10 text-[#00ff88]"
                          : "bg-white/5 text-white/40"
                      }`}
                    >
                      {item.sentiment}
                    </span>
                    <span className="text-[10px] text-white/20 flex-shrink-0">{item.ago}</span>
                  </div>
                  <p className="text-xs text-white/60 leading-relaxed group-hover:text-white/80 transition-colors">
                    {item.title}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

"use client";

import { Brain, TrendingUp, Shield, BookOpen, Bell, BarChart3, Zap, Globe, Clock } from "lucide-react";

const features = [
  {
    icon: Brain,
    title: "AI Market Analysis",
    description:
      "GPT-powered market explanations. Understand bullish/bearish reasoning, support/resistance levels, and volatility with plain-English insights.",
    color: "#00ff88",
    glow: "rgba(0,255,136,0.15)",
    badge: "Core",
  },
  {
    icon: Clock,
    title: "Market Memory Engine",
    description:
      "RAG-powered historical pattern matching. Find similar past market structures and get AI commentary on what happened next.",
    color: "#8b5cf6",
    glow: "rgba(139,92,246,0.15)",
    badge: "Unique",
  },
  {
    icon: TrendingUp,
    title: "New Listings Intel",
    description:
      "Spot newly listed coins on Binance/Bybit before the crowd. AI scores momentum, social sentiment, and whale accumulation.",
    color: "#06b6d4",
    glow: "rgba(6,182,212,0.15)",
    badge: "Hot",
  },
  {
    icon: Shield,
    title: "Risk Management",
    description:
      "Position sizing calculator, leverage risk meter, and liquidation price alerts. AI warns you before you over-leverage.",
    color: "#f59e0b",
    glow: "rgba(245,158,11,0.15)",
    badge: "Safety",
  },
  {
    icon: Globe,
    title: "Sentiment Intelligence",
    description:
      "Aggregate Twitter/X, Reddit, and on-chain signals into a single sentiment score. See what the market is feeling in real time.",
    color: "#3b82f6",
    glow: "rgba(59,130,246,0.15)",
    badge: "Live",
  },
  {
    icon: BookOpen,
    title: "AI Trade Journal",
    description:
      "Log trades with emotion tracking. AI detects revenge trading patterns and gives psychology-focused performance insights.",
    color: "#ec4899",
    glow: "rgba(236,72,153,0.15)",
    badge: "Psychology",
  },
  {
    icon: BarChart3,
    title: "Advanced Charts",
    description:
      "TradingView-style candlestick charts with RSI, MACD, EMA, and AI analysis overlays. Historical similarity engine built in.",
    color: "#00ff88",
    glow: "rgba(0,255,136,0.12)",
    badge: "Pro",
  },
  {
    icon: Bell,
    title: "Smart Alert Center",
    description:
      "Funding rate spikes, whale movements, volatility bursts, and new listing alerts — delivered instantly via push notifications.",
    color: "#f97316",
    glow: "rgba(249,115,22,0.15)",
    badge: "Real-time",
  },
  {
    icon: Zap,
    title: "AI Chat Assistant",
    description:
      "Ask anything about the market. Context-aware, RAG-powered responses that know current news, prices, and historical patterns.",
    color: "#8b5cf6",
    glow: "rgba(139,92,246,0.12)",
    badge: "GPT-4",
  },
];

export default function Features() {
  return (
    <section id="features" className="py-24 relative overflow-hidden">
      <div className="absolute inset-0 dot-bg opacity-40" />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <div className="badge-purple inline-flex mb-4">
            <Zap className="w-3 h-3" />
            <span>Platform Features</span>
          </div>
          <h2 className="section-heading mb-4">
            Everything a serious trader{" "}
            <span className="gradient-text-green">needs to win</span>
          </h2>
          <p className="section-subheading max-w-2xl mx-auto">
            Not a signal bot. A complete AI intelligence layer that enhances every aspect of your
            trading — from analysis to psychology.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {features.map((feature, i) => {
            const Icon = feature.icon;
            return (
              <div
                key={i}
                className="glass-card-hover p-6 group cursor-default"
                style={{ animationDelay: `${i * 50}ms` }}
              >
                <div className="flex items-start justify-between mb-4">
                  <div
                    className="w-10 h-10 rounded-xl flex items-center justify-center transition-all duration-300 group-hover:scale-110"
                    style={{
                      background: feature.glow,
                      border: `1px solid ${feature.color}22`,
                    }}
                  >
                    <Icon className="w-5 h-5" style={{ color: feature.color }} />
                  </div>
                  <span
                    className="text-[10px] font-semibold px-2 py-1 rounded-full"
                    style={{
                      background: `${feature.color}15`,
                      color: feature.color,
                      border: `1px solid ${feature.color}25`,
                    }}
                  >
                    {feature.badge}
                  </span>
                </div>
                <h3 className="text-base font-semibold text-white mb-2 group-hover:text-white transition-colors">
                  {feature.title}
                </h3>
                <p className="text-sm text-white/45 leading-relaxed group-hover:text-white/60 transition-colors">
                  {feature.description}
                </p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

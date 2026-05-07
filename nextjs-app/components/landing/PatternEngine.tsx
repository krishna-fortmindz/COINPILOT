"use client";

import { Brain, TrendingUp, ArrowRight, Cpu, Clock } from "lucide-react";

const similarEvents = [
  {
    date: "Oct 2024",
    title: "BTC Breakout Phase",
    similarity: 87,
    outcome: "+34% over 45 days",
    positive: true,
    description: "RSI breakout from 55 zone, ETF inflows surge, funding neutral.",
  },
  {
    date: "Mar 2024",
    title: "Pre-Halving Accumulation",
    similarity: 71,
    outcome: "+28% over 30 days",
    positive: true,
    description: "Low funding rates, whale accumulation, exchange outflows increasing.",
  },
  {
    date: "Jan 2023",
    title: "Recovery Rally",
    similarity: 63,
    outcome: "+18% over 21 days",
    positive: true,
    description: "Bottom formation after capitulation, sentiment shifting from extreme fear.",
  },
];

export default function PatternEngine() {
  return (
    <section id="memory-engine" className="py-24 relative overflow-hidden">
      <div className="absolute inset-0"
        style={{ background: "radial-gradient(ellipse 80% 50% at 50% 50%, rgba(139,92,246,0.06) 0%, transparent 70%)" }} />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
          {/* Left content */}
          <div>
            <div className="badge-purple inline-flex mb-6">
              <Cpu className="w-3 h-3" />
              <span>Market Memory Engine</span>
            </div>
            <h2 className="text-4xl md:text-5xl font-bold tracking-tight mb-6">
              <span className="gradient-text">AI remembers</span>
              <br />
              <span className="gradient-text-green">every market cycle</span>
            </h2>
            <p className="text-lg text-white/50 leading-relaxed mb-8">
              Our RAG-powered engine analyzes the current market structure and finds historically
              similar patterns — giving you context that even seasoned traders miss.
            </p>
            <ul className="space-y-4 mb-8">
              {[
                "Semantic similarity matching across 10+ years of price data",
                "AI-generated explanation of what happened next",
                "Confidence scores and outcome probabilities",
                "Multi-timeframe pattern recognition",
              ].map((item, i) => (
                <li key={i} className="flex items-start gap-3">
                  <div className="w-1.5 h-1.5 rounded-full mt-2 flex-shrink-0" style={{ background: "#00ff88" }} />
                  <span className="text-sm text-white/60">{item}</span>
                </li>
              ))}
            </ul>
            <a href="#" className="btn-primary inline-flex group">
              Try Market Memory
              <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
            </a>
          </div>

          {/* Right: Pattern cards */}
          <div className="space-y-4">
            {/* Current state card */}
            <div className="glass-card p-5 neon-border-green">
              <div className="flex items-center gap-2 mb-3">
                <div className="w-2 h-2 rounded-full bg-[#00ff88] animate-pulse" />
                <span className="text-xs font-mono text-white/40 uppercase tracking-wider">Current Market State</span>
              </div>
              <div className="flex items-center gap-3">
                <Brain className="w-5 h-5 text-[#00ff88]" />
                <p className="text-sm text-white/80 leading-relaxed">
                  BTC at $97,420 · RSI 67 · Funding +0.02% · ETF inflows positive · Whale accumulation detected
                </p>
              </div>
            </div>

            <div className="flex items-center gap-3 px-2">
              <div className="flex-1 h-px bg-white/5" />
              <span className="text-xs text-white/30 font-mono">Similar historical patterns found</span>
              <div className="flex-1 h-px bg-white/5" />
            </div>

            {/* Historical matches */}
            {similarEvents.map((event, i) => (
              <div
                key={i}
                className="glass-card-hover p-5 group"
                style={{ opacity: 1 - i * 0.12 }}
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-2">
                    <Clock className="w-3.5 h-3.5 text-white/30" />
                    <span className="text-xs text-white/30 font-mono">{event.date}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="h-1.5 rounded-full overflow-hidden w-16 bg-white/5">
                      <div
                        className="h-full rounded-full"
                        style={{ width: `${event.similarity}%`, background: "#8b5cf6" }}
                      />
                    </div>
                    <span className="text-xs font-mono font-bold text-purple-400">{event.similarity}%</span>
                  </div>
                </div>
                <h4 className="text-sm font-semibold text-white mb-1">{event.title}</h4>
                <p className="text-xs text-white/40 mb-3">{event.description}</p>
                <div className="flex items-center gap-2">
                  <TrendingUp className="w-3.5 h-3.5 text-[#00ff88]" />
                  <span className="text-xs font-mono font-semibold text-[#00ff88]">
                    Outcome: {event.outcome}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

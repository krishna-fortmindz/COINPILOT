"use client";

import Link from "next/link";
import { ArrowRight, Clock, Tag } from "lucide-react";

const posts = [
  {
    slug: "bitcoin-market-memory-oct-2024",
    title: "How the Market Memory Engine Predicted the October 2024 BTC Breakout",
    excerpt:
      "We detected an 87% structural match to the 2020 halving cycle accumulation phase 3 weeks before BTC broke $70K. Here's the full analysis.",
    category: "Market Analysis",
    readTime: "8 min read",
    date: "Apr 28, 2026",
    featured: true,
  },
  {
    slug: "crypto-sentiment-trading-guide",
    title: "Why Sentiment Data Beats Price Action for Entry Timing",
    excerpt:
      "A deep dive into how aggregated social and on-chain sentiment consistently leads price by 12–48 hours — and how to trade it.",
    category: "Education",
    readTime: "6 min read",
    date: "Apr 15, 2026",
    featured: false,
  },
  {
    slug: "revenge-trading-ai-journal",
    title: "The Psychology Trap: How AI Caught My Revenge Trading Pattern",
    excerpt:
      "A personal account of how the AI Trade Journal identified a costly emotional pattern — and what changed after.",
    category: "Psychology",
    readTime: "5 min read",
    date: "Apr 3, 2026",
    featured: false,
  },
];

const categoryColors: Record<string, string> = {
  "Market Analysis": "#00ff88",
  Education: "#8b5cf6",
  Psychology: "#ec4899",
};

export default function BlogPreview() {
  return (
    <section className="py-24 relative overflow-hidden">
      <div className="absolute inset-0 grid-bg opacity-25" />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between mb-12">
          <div>
            <h2 className="text-3xl font-bold text-white mb-2">
              From the{" "}
              <span className="gradient-text-green">intelligence desk</span>
            </h2>
            <p className="text-white/40 text-sm">
              Market analysis, education, and trading psychology — powered by AI.
            </p>
          </div>
          <Link
            href="/blog"
            className="hidden md:flex items-center gap-2 text-sm text-white/40 hover:text-white transition-colors group"
          >
            View all articles
            <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
          </Link>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
          {posts.map((post, i) => {
            const color = categoryColors[post.category] || "#00ff88";
            return (
              <Link
                key={i}
                href={`/blog/${post.slug}`}
                className={`glass-card-hover p-6 flex flex-col gap-4 group cursor-pointer ${
                  post.featured ? "lg:col-span-1 lg:row-span-1" : ""
                }`}
              >
                <div className="flex items-center justify-between">
                  <span
                    className="text-[10px] font-semibold uppercase tracking-wider px-2 py-1 rounded-full flex items-center gap-1"
                    style={{
                      background: `${color}15`,
                      color,
                      border: `1px solid ${color}25`,
                    }}
                  >
                    <Tag className="w-2.5 h-2.5" />
                    {post.category}
                  </span>
                  <div className="flex items-center gap-1 text-xs text-white/25">
                    <Clock className="w-3 h-3" />
                    {post.readTime}
                  </div>
                </div>

                <div className="flex-1">
                  <h3 className="text-base font-semibold text-white mb-2 leading-snug group-hover:text-[#00ff88] transition-colors">
                    {post.title}
                  </h3>
                  <p className="text-sm text-white/40 leading-relaxed">{post.excerpt}</p>
                </div>

                <div className="flex items-center justify-between pt-3 border-t border-white/5">
                  <span className="text-xs text-white/25">{post.date}</span>
                  <ArrowRight className="w-3.5 h-3.5 text-white/20 group-hover:text-[#00ff88] group-hover:translate-x-1 transition-all" />
                </div>
              </Link>
            );
          })}
        </div>

        <div className="text-center mt-8 md:hidden">
          <Link href="/blog" className="btn-secondary text-sm">
            View all articles <ArrowRight className="w-4 h-4" />
          </Link>
        </div>
      </div>
    </section>
  );
}

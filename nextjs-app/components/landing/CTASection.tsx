import Link from "next/link";
import { ArrowRight, Zap } from "lucide-react";

export default function CTASection() {
  return (
    <section className="py-24 relative overflow-hidden">
      <div className="absolute inset-0"
        style={{ background: "radial-gradient(ellipse 80% 60% at 50% 50%, rgba(0,255,136,0.06) 0%, transparent 70%)" }} />
      <div className="absolute inset-0 grid-bg opacity-30" />

      <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl mb-8"
          style={{ background: "linear-gradient(135deg, #00ff88, #00cc6a)", boxShadow: "0 0 40px rgba(0,255,136,0.3)" }}>
          <Zap className="w-8 h-8 text-black" strokeWidth={2.5} />
        </div>

        <h2 className="text-4xl md:text-5xl font-black tracking-tight mb-6">
          <span className="gradient-text">Ready to trade smarter?</span>
          <br />
          <span className="gradient-text-green">Start free today.</span>
        </h2>

        <p className="text-lg text-white/45 max-w-xl mx-auto mb-10 leading-relaxed">
          Join 12,000+ traders using AI intelligence to navigate crypto markets.
          No credit card required for the free plan.
        </p>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
          <Link href="/auth/signup" className="btn-primary text-base px-10 py-4 group">
            Start Free — No Card Needed
            <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
          </Link>
          <Link href="/auth/login" className="btn-secondary text-base px-8 py-4">
            Already have an account? Log in
          </Link>
        </div>

        <p className="mt-6 text-xs text-white/20">
          Free plan includes 3 AI market summaries/day. Upgrade anytime. Cancel anytime.
        </p>
      </div>
    </section>
  );
}

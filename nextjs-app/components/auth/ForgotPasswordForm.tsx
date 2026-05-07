"use client";

import { useState } from "react";
import Link from "next/link";
import { Mail, ArrowRight, Loader2, CheckCircle, ArrowLeft } from "lucide-react";

export default function ForgotPasswordForm() {
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [sent, setSent] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    await new Promise((r) => setTimeout(r, 1500));
    setSent(true);
    setLoading(false);
  };

  if (sent) {
    return (
      <div className="text-center space-y-4">
        <div className="w-12 h-12 rounded-full mx-auto flex items-center justify-center"
          style={{ background: "rgba(0,255,136,0.1)" }}>
          <CheckCircle className="w-6 h-6 text-[#00ff88]" />
        </div>
        <p className="text-sm text-white/60 leading-relaxed">
          If an account exists for <span className="text-white font-medium">{email}</span>,
          we've sent a password reset link. Check your inbox.
        </p>
        <Link href="/auth/login" className="btn-secondary w-full text-sm py-3 flex items-center justify-center gap-2">
          <ArrowLeft className="w-4 h-4" /> Back to sign in
        </Link>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label className="block text-xs font-medium text-white/50 mb-1.5 uppercase tracking-wider">Email address</label>
        <div className="relative">
          <Mail className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-white/25" />
          <input
            type="email" value={email} onChange={(e) => setEmail(e.target.value)}
            placeholder="you@example.com" required
            className="w-full bg-white/4 border border-white/8 rounded-xl pl-10 pr-4 py-3 text-sm text-white placeholder-white/20 focus:outline-none focus:border-[#00ff88]/30 focus:bg-white/6 transition-all"
          />
        </div>
      </div>

      <button type="submit" disabled={loading} className="btn-primary w-full py-3.5 text-sm disabled:opacity-60">
        {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <>Send reset link <ArrowRight className="w-4 h-4" /></>}
      </button>

      <Link href="/auth/login" className="flex items-center justify-center gap-2 text-sm text-white/30 hover:text-white/60 transition-colors">
        <ArrowLeft className="w-3.5 h-3.5" /> Back to sign in
      </Link>
    </form>
  );
}

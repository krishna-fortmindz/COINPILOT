"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Menu, X, Zap, ChevronDown } from "lucide-react";

const DASHBOARD_URL =
  process.env.NEXT_PUBLIC_FLUTTER_DASHBOARD_URL ?? "http://localhost:8080/dashboard";

const navLinks = [
  { label: "Features", href: "#features" },
  { label: "Market Memory", href: "#memory-engine" },
  { label: "Pricing", href: "#pricing" },
  { label: "Blog", href: "/blog" },
];

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const handler = () => setScrolled(window.scrollY > 20);
    window.addEventListener("scroll", handler, { passive: true });
    return () => window.removeEventListener("scroll", handler);
  }, []);

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled
          ? "bg-[#0a0b0f]/90 backdrop-blur-xl border-b border-white/5 shadow-[0_4px_24px_rgba(0,0,0,0.4)]"
          : "bg-transparent"
      }`}
    >
      <nav className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2.5 group">
            <div className="w-8 h-8 rounded-lg flex items-center justify-center relative overflow-hidden"
              style={{ background: "linear-gradient(135deg, #00ff88, #00cc6a)" }}>
              <Zap className="w-4.5 h-4.5 text-black" strokeWidth={2.5} />
              <div className="absolute inset-0 bg-white/20 opacity-0 group-hover:opacity-100 transition-opacity" />
            </div>
            <div>
              <span className="text-sm font-bold text-white tracking-tight">AI Trading</span>
              <span className="text-sm font-bold tracking-tight ml-1" style={{ color: "#00ff88" }}>Copilot</span>
            </div>
          </Link>

          {/* Desktop Nav */}
          <div className="hidden md:flex items-center gap-1">
            {navLinks.map((link) => (
              <Link
                key={link.label}
                href={link.href}
                className="px-4 py-2 text-sm text-white/60 hover:text-white rounded-lg hover:bg-white/5 transition-all duration-150 font-medium"
              >
                {link.label}
              </Link>
            ))}
          </div>

          {/* Desktop CTAs */}
          <div className="hidden md:flex items-center gap-3">
            <Link
              href="/auth/login"
              className="px-4 py-2 text-sm font-medium text-white/70 hover:text-white transition-colors"
            >
              Log in
            </Link>
            <a href={DASHBOARD_URL} className="btn-secondary text-sm px-4 py-2.5">
              Dashboard
            </a>
            <Link href="/auth/signup" className="btn-primary text-sm px-5 py-2.5">
              Start Free
              <span className="text-black/60 text-xs font-normal">— No card needed</span>
            </Link>
          </div>

          {/* Mobile menu toggle */}
          <button
            className="md:hidden p-2 rounded-lg text-white/60 hover:text-white hover:bg-white/5 transition-all"
            onClick={() => setMobileOpen(!mobileOpen)}
            aria-label="Toggle menu"
          >
            {mobileOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
          </button>
        </div>
      </nav>

      {/* Mobile menu */}
      {mobileOpen && (
        <div className="md:hidden bg-[#0f1117]/95 backdrop-blur-xl border-b border-white/5">
          <div className="max-w-7xl mx-auto px-4 py-4 space-y-1">
            {navLinks.map((link) => (
              <Link
                key={link.label}
                href={link.href}
                className="block px-4 py-3 text-sm text-white/70 hover:text-white hover:bg-white/5 rounded-xl transition-all"
                onClick={() => setMobileOpen(false)}
              >
                {link.label}
              </Link>
            ))}
            <div className="pt-3 space-y-2 border-t border-white/5">
              <Link href="/auth/login" className="block px-4 py-3 text-sm text-center text-white/70 hover:text-white">
                Log in
              </Link>
              <Link href="/auth/signup" className="btn-primary block text-center text-sm">
                Start Free — No card needed
              </Link>
            </div>
          </div>
        </div>
      )}
    </header>
  );
}

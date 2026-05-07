import type { Metadata } from "next";
import Navbar from "@/components/landing/Navbar";
import Hero from "@/components/landing/Hero";
import Features from "@/components/landing/Features";
import SentimentDemo from "@/components/landing/SentimentDemo";
import PatternEngine from "@/components/landing/PatternEngine";
import Testimonials from "@/components/landing/Testimonials";
import Pricing from "@/components/landing/Pricing";
import FAQ from "@/components/landing/FAQ";
import BlogPreview from "@/components/landing/BlogPreview";
import Footer from "@/components/landing/Footer";
import RiskDemo from "@/components/landing/RiskDemo";
import CTASection from "@/components/landing/CTASection";

export const metadata: Metadata = {
  title: "AI Trading Copilot — AI-Powered Crypto Intelligence Platform",
  description:
    "Analyze crypto markets, detect historical patterns, manage risk, and make smarter trading decisions with AI. Not a bot — a trading intelligence layer.",
};

export default function LandingPage() {
  return (
    <main className="min-h-screen bg-[#0a0b0f] overflow-x-hidden">
      <Navbar />
      <Hero />
      <Features />
      <PatternEngine />
      <SentimentDemo />
      <RiskDemo />
      <Testimonials />
      <Pricing />
      <FAQ />
      <BlogPreview />
      <CTASection />
      <Footer />
    </main>
  );
}

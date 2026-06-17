import type { Metadata } from "next";
import Navbar from "@/components/landing/Navbar";
import LandingPageClient from "@/components/landing/LandingPageClient";
import Features from "@/components/landing/Features";
import PatternEngine from "@/components/landing/PatternEngine";
import SentimentDemo from "@/components/landing/SentimentDemo";
import Testimonials from "@/components/landing/Testimonials";
import FAQ from "@/components/landing/FAQ";
import BlogPreview from "@/components/landing/BlogPreview";
import CTASection from "@/components/landing/CTASection";
import Footer from "@/components/landing/Footer";

export const metadata: Metadata = {
  title: "Coinastra — AI-Powered Crypto Trading Intelligence",
  description:
    "Real-time AI analysis, live market data, sentiment signals, whale alerts and risk management for serious crypto traders.",
};

export default function LandingPage() {
  return (
    <main className="min-h-screen bg-[#0a0b0f] overflow-x-hidden">
      <Navbar />
      <LandingPageClient />
      <Features />
      <PatternEngine />
      <SentimentDemo />
      <Testimonials />
      <FAQ />
      <BlogPreview />
      <CTASection />
      <Footer />
    </main>
  );
}

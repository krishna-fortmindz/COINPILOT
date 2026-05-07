import Link from "next/link";
import { Zap } from "lucide-react";

interface AuthLayoutProps {
  children: React.ReactNode;
  title: string;
  subtitle: string;
}

export default function AuthLayout({ children, title, subtitle }: AuthLayoutProps) {
  return (
    <div className="min-h-screen bg-[#0a0b0f] flex flex-col">
      {/* Ambient background */}
      <div className="fixed inset-0 grid-bg opacity-40 pointer-events-none" />
      <div className="fixed inset-0 pointer-events-none"
        style={{ background: "radial-gradient(ellipse 60% 40% at 50% 0%, rgba(0,255,136,0.06) 0%, transparent 60%)" }} />

      {/* Navbar */}
      <nav className="relative z-10 flex items-center justify-between px-6 py-4 max-w-7xl mx-auto w-full">
        <Link href="/" className="flex items-center gap-2.5">
          <div className="w-7 h-7 rounded-lg flex items-center justify-center"
            style={{ background: "linear-gradient(135deg, #00ff88, #00cc6a)" }}>
            <Zap className="w-3.5 h-3.5 text-black" strokeWidth={2.5} />
          </div>
          <span className="text-sm font-bold text-white">
            AI Trading <span style={{ color: "#00ff88" }}>Copilot</span>
          </span>
        </Link>
      </nav>

      {/* Card */}
      <div className="relative z-10 flex-1 flex items-center justify-center px-4 py-12">
        <div className="w-full max-w-md">
          <div className="glass-card p-8">
            <div className="mb-8 text-center">
              <h1 className="text-2xl font-bold text-white mb-2">{title}</h1>
              <p className="text-sm text-white/40">{subtitle}</p>
            </div>
            {children}
          </div>
        </div>
      </div>
    </div>
  );
}

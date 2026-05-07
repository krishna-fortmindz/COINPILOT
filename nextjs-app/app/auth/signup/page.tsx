import type { Metadata } from "next";
import AuthLayout from "@/components/auth/AuthLayout";
import SignupForm from "@/components/auth/SignupForm";

export const metadata: Metadata = {
  title: "Create Account",
  description: "Start your free AI Trading Copilot account.",
  robots: { index: false, follow: false },
};

export default function SignupPage() {
  return (
    <AuthLayout
      title="Start free today"
      subtitle="Create your account — no credit card required"
    >
      <SignupForm />
    </AuthLayout>
  );
}

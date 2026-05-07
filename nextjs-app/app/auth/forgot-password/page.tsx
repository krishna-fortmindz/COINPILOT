import type { Metadata } from "next";
import AuthLayout from "@/components/auth/AuthLayout";
import ForgotPasswordForm from "@/components/auth/ForgotPasswordForm";

export const metadata: Metadata = {
  title: "Reset Password",
  robots: { index: false, follow: false },
};

export default function ForgotPasswordPage() {
  return (
    <AuthLayout title="Reset your password" subtitle="We'll send a reset link to your email">
      <ForgotPasswordForm />
    </AuthLayout>
  );
}

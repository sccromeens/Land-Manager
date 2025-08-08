"use client";
import { supabase } from "@/lib/supabaseClient";
import { useState } from "react";
import { Button } from "@/components/ui/button";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [sent, setSent] = useState(false);

  const sendMagicLink = async () => {
    const { error } = await supabase.auth.signInWithOtp({ email, options: { emailRedirectTo: window.location.origin } });
    if (!error) setSent(true);
    else alert(error.message);
  };

  return (
    <div className="max-w-md mx-auto">
      <h1 className="text-2xl font-semibold mb-2">Login</h1>
      <p className="text-sm text-gray-600 mb-4">Enter your email and we’ll send you a magic link.</p>
      <input
        className="w-full border rounded px-3 py-2 mb-3"
        placeholder="you@example.com"
        value={email}
        onChange={(e)=>setEmail(e.target.value)}
      />
      <Button onClick={sendMagicLink}>Send magic link</Button>
      {sent && <p className="text-green-700 mt-3">Check your email for the link.</p>}
    </div>
  );
}

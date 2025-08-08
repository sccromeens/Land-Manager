import { NextRequest, NextResponse } from "next/server";

export async function POST(req: NextRequest) {
  const body = await req.json().catch(() => ({}));
  if (!process.env.OPENAI_API_KEY) {
    return NextResponse.json({ ok: false, message: "OPENAI_API_KEY not set. Add it in your environment variables." }, { status: 400 });
  }
  // Placeholder: in a real implementation, parse file text and map to runsheet rows
  return NextResponse.json({ ok: true, received: body, note: "AI ingest stub. Wire to Supabase runsheets table later." });
}

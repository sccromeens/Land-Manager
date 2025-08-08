"use client";

import { Button } from "@/components/ui/button";
import { Card, CardTitle } from "@/components/ui/card";
import { useRouter } from "next/navigation";

export default function Page() {
  const router = useRouter();
  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <Card>
        <CardTitle>My Tasks</CardTitle>
        <p className="text-sm text-gray-600 mb-3">Personal queue of assignments.</p>
        <Button onClick={() => router.push("/crm")}>Open</Button>
      </Card>
      <Card>
        <CardTitle>Project Progress</CardTitle>
        <div className="space-y-2">
          {["North Area", "Central Area", "South Area"].map((name, i) => (
            <div key={i}>
              <div className="flex justify-between text-sm"><span>{name}</span><span>{[72,48,23][i]}%</span></div>
              <div className="h-2 rounded bg-gray-200"><div className="h-2 rounded bg-brand" style={{width: `${[72,48,23][i]}%`}}/></div>
            </div>
          ))}
        </div>
      </Card>
      <Card>
        <CardTitle>Upload Mileage/Files</CardTitle>
        <p className="text-sm text-gray-600 mb-3">Drag & drop or click to upload.</p>
        <Button onClick={() => alert("This is a placeholder. Connect Supabase Storage later.")}>Upload</Button>
      </Card>
      <Card>
        <CardTitle>Quick Search</CardTitle>
        <p className="text-sm text-gray-600 mb-3">Find lessors, landmen, tracts fast.</p>
        <Button onClick={() => alert("Search placeholder. Wired to DB once Supabase is connected.")}>Search</Button>
      </Card>
      <Card>
        <CardTitle>Guided Tutorial</CardTitle>
        <p className="text-sm text-gray-600 mb-3">First-time walkthrough for new users.</p>
        <Button onClick={() => alert("Tutorial placeholder. We can add a proper tour library later.")}>Start Tour</Button>
      </Card>
      <Card>
        <CardTitle>AI Assistant</CardTitle>
        <p className="text-sm text-gray-600 mb-3">“Add this lease doc to runsheet.”</p>
        <Button onClick={() => alert("AI not connected. Add your OPENAI_API_KEY and we'll wire it.")}>Open Chat</Button>
      </Card>
    </div>
  );
}

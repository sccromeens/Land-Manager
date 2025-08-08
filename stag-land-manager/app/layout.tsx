import "./globals.css";
import Image from "next/image";
import Link from "next/link";

export const metadata = {
  title: "Stag Land Manager",
  description: "Dashboard tool for land management teams",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <header className="border-b">
          <div className="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Image src="/logo.svg" alt="logo" width={28} height={28} />
              <span className="font-bold">Stag Land Manager</span>
            </div>
            <nav className="text-sm">
              <Link href="/" className="mr-4">Dashboard</Link>
              <Link href="/crm" className="mr-4">CRM</Link>
              <Link href="/runsheets" className="mr-4">Runsheets</Link>
              <Link href="/files" className="mr-4">Files</Link>
              <Link href="/invoicing" className="mr-4">Invoicing</Link>
              <Link href="/login">Login</Link>
            </nav>
          </div>
        </header>
        <main className="max-w-6xl mx-auto px-4 py-6">{children}</main>
      </body>
    </html>
  );
}

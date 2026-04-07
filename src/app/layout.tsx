import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { AuthProvider } from '@/lib/auth-context'
import { AppShell } from '@/components/layout/app-shell'
import { Toaster } from 'sonner'

const inter = Inter({ subsets: ['latin'], variable: '--font-sans' })

export const metadata: Metadata = {
  title: 'Squarecana Talent Hub Manager',
  description: 'Manage global talent hubs, contracts, and operations',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={`${inter.className} antialiased`}>
        <AuthProvider>
          <AppShell>{children}</AppShell>
          <Toaster richColors position="top-right" />
        </AuthProvider>
      </body>
    </html>
  )
}

'use client'

import { useAuth } from '@/lib/auth-context'
import { usePathname, useRouter } from 'next/navigation'
import { useEffect } from 'react'
import { Sidebar } from './sidebar'
import { DemoBanner } from './demo-banner'

export function AppShell({ children }: { children: React.ReactNode }) {
  const { loading, profile, user } = useAuth()
  const pathname = usePathname()
  const router = useRouter()
  const isAuthPage = pathname.startsWith('/auth')

  useEffect(() => {
    if (loading) return
    // Not logged in and not on auth page -> redirect to login
    if (!user && !isAuthPage) {
      router.push('/auth/login')
    }
  }, [loading, user, isAuthPage, router])

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-100">
        <div className="text-center">
          <div className="h-12 w-12 rounded-lg bg-[#0F2952] flex items-center justify-center mx-auto mb-4">
            <span className="text-white font-bold text-lg">SQ</span>
          </div>
          <p className="text-gray-500 text-sm">Loading...</p>
        </div>
      </div>
    )
  }

  // Auth pages render without shell
  if (isAuthPage) {
    return <>{children}</>
  }

  // Not logged in — show nothing while redirecting
  if (!user) {
    return null
  }

  // Logged in but no profile or not active — show without shell
  if (!profile || profile.status !== 'active') {
    return <>{children}</>
  }

  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar />
      <div className="flex-1 flex flex-col min-w-0">
        <DemoBanner />
        <main className="flex-1 p-4 lg:p-8">
          {children}
        </main>
      </div>
    </div>
  )
}

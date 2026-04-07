'use client'

import { useAuth } from '@/lib/auth-context'
import { Sidebar } from './sidebar'
import { DemoBanner } from './demo-banner'
import { Skeleton } from '@/components/ui/skeleton'

export function AppShell({ children }: { children: React.ReactNode }) {
  const { loading, profile } = useAuth()

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-50">
        <div className="space-y-4 w-64">
          <Skeleton className="h-8 w-full" />
          <Skeleton className="h-4 w-3/4" />
          <Skeleton className="h-4 w-1/2" />
        </div>
      </div>
    )
  }

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

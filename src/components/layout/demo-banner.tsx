'use client'

import { useAuth } from '@/lib/auth-context'
import { AlertTriangle } from 'lucide-react'

export function DemoBanner() {
  const { demoMode } = useAuth()

  if (!demoMode) return null

  return (
    <div className="bg-amber-500 text-white px-4 py-2 text-center text-sm font-medium flex items-center justify-center gap-2">
      <AlertTriangle className="h-4 w-4" />
      Demo Mode Active — Showing sample data only
    </div>
  )
}

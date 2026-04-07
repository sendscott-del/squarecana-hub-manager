'use client'

import { useEffect } from 'react'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    console.error('App error:', error)
  }, [error])

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50 p-8">
      <div className="max-w-lg text-center">
        <h2 className="text-xl font-bold text-red-600 mb-4">Something went wrong</h2>
        <pre className="text-left text-xs bg-gray-100 p-4 rounded overflow-auto max-h-64 mb-4">
          {error.message}
          {'\n\n'}
          {error.stack}
        </pre>
        <button
          onClick={reset}
          className="px-4 py-2 bg-[#0F2952] text-white rounded hover:bg-[#0F2952]/90"
        >
          Try again
        </button>
      </div>
    </div>
  )
}

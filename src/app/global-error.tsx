'use client'

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <html>
      <body style={{ fontFamily: 'sans-serif', padding: '2rem' }}>
        <h2 style={{ color: 'red' }}>Application Error</h2>
        <pre style={{ background: '#f5f5f5', padding: '1rem', overflow: 'auto', fontSize: '12px' }}>
          {error.message}
          {'\n\n'}
          {error.stack}
        </pre>
        <button onClick={reset} style={{ padding: '8px 16px', marginTop: '1rem', cursor: 'pointer' }}>
          Try again
        </button>
      </body>
    </html>
  )
}

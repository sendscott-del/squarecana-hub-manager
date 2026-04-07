import { NextResponse, type NextRequest } from 'next/server'

export async function updateSession(request: NextRequest) {
  // Simple middleware — just pass through all requests.
  // Auth is handled client-side by the AuthProvider.
  return NextResponse.next()
}

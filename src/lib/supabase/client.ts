import { createClient as createSupabaseClient } from '@supabase/supabase-js'

let client: ReturnType<typeof createSupabaseClient> | null = null

export function createClient() {
  if (client) return client

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL || ''
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || ''

  console.log('[supabase] url:', url)
  console.log('[supabase] key present:', !!key, 'length:', key.length)

  client = createSupabaseClient(url, key)
  return client
}

'use client'

import { createContext, useContext, useEffect, useState, ReactNode } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { AppUser } from '@/lib/types'
import type { User } from '@supabase/supabase-js'

interface AuthContextType {
  user: User | null
  profile: AppUser | null
  loading: boolean
  demoMode: boolean
  refreshProfile: () => Promise<void>
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  profile: null,
  loading: true,
  demoMode: false,
  refreshProfile: async () => {},
  signOut: async () => {},
})

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || ''
const SUPABASE_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || ''

async function fetchFromSupabase(path: string, token?: string) {
  const headers: Record<string, string> = {
    'apikey': SUPABASE_KEY,
    'Content-Type': 'application/json',
  }
  if (token) {
    headers['Authorization'] = `Bearer ${token}`
  }
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, { headers })
  if (!res.ok) return null
  return res.json()
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [profile, setProfile] = useState<AppUser | null>(null)
  const [loading, setLoading] = useState(true)
  const [demoMode, setDemoMode] = useState(false)

  const loadUserData = async (authUser: User, token: string) => {
    try {
      const profiles = await fetchFromSupabase(
        `sq_users?id=eq.${authUser.id}&select=*`,
        token
      )
      if (profiles && profiles.length > 0) {
        setProfile(profiles[0])
      }

      const settings = await fetchFromSupabase(
        `sq_settings?key=eq.demo_mode&select=value`,
        token
      )
      if (settings && settings.length > 0) {
        setDemoMode(settings[0].value === 'true')
      }
    } catch (e) {
      console.error('[auth] load data error:', e)
    }
  }

  const refreshProfile = async () => {
    const supabase = createClient()
    const { data: { session } } = await supabase.auth.getSession()
    if (session?.user && session.access_token) {
      await loadUserData(session.user, session.access_token)
    }
  }

  const signOut = async () => {
    const supabase = createClient()
    await supabase.auth.signOut()
    setUser(null)
    setProfile(null)
    window.location.href = '/auth/login'
  }

  useEffect(() => {
    const supabase = createClient()

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        const authUser = session?.user ?? null
        setUser(authUser)

        if (authUser && session?.access_token) {
          await loadUserData(authUser, session.access_token)
        } else {
          setProfile(null)
        }

        setLoading(false)
      }
    )

    const timeout = setTimeout(() => {
      setLoading(false)
    }, 3000)

    return () => {
      clearTimeout(timeout)
      subscription.unsubscribe()
    }
  }, [])

  return (
    <AuthContext.Provider value={{ user, profile, loading, demoMode, refreshProfile, signOut }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)

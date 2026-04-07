'use client'

import { createContext, useContext, useEffect, useState, ReactNode, useCallback } from 'react'
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

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [profile, setProfile] = useState<AppUser | null>(null)
  const [loading, setLoading] = useState(true)
  const [demoMode, setDemoMode] = useState(false)

  const loadProfile = useCallback(async (userId: string) => {
    try {
      const supabase = createClient()
      const { data } = await supabase
        .from('sq_users')
        .select('*')
        .eq('id', userId)
        .single()
      if (data) setProfile(data)
    } catch (e) {
      console.error('[auth] profile error:', e)
    }
  }, [])

  const loadDemoMode = useCallback(async () => {
    try {
      const supabase = createClient()
      const { data } = await supabase
        .from('sq_settings')
        .select('value')
        .eq('key', 'demo_mode')
        .maybeSingle()
      setDemoMode(data?.value === 'true')
    } catch (e) {
      console.error('[auth] demo mode error:', e)
    }
  }, [])

  const refreshProfile = async () => {
    if (user) await loadProfile(user.id)
    await loadDemoMode()
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

    // Listen for auth changes (sign in, sign out, token refresh)
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        console.log('[auth] state change:', event, session?.user?.email)
        const authUser = session?.user ?? null
        setUser(authUser)

        if (authUser) {
          await loadProfile(authUser.id)
          await loadDemoMode()
        } else {
          setProfile(null)
        }

        setLoading(false)
      }
    )

    // Also check for existing session without blocking
    supabase.auth.getSession().then(({ data: { session } }) => {
      console.log('[auth] initial session:', session?.user?.email ?? 'none')
      if (session?.user) {
        setUser(session.user)
        loadProfile(session.user.id)
        loadDemoMode()
      }
      setLoading(false)
    }).catch(() => {
      console.log('[auth] getSession failed, continuing without session')
      setLoading(false)
    })

    // Safety timeout
    const timeout = setTimeout(() => {
      console.log('[auth] timeout — forcing loading=false')
      setLoading(false)
    }, 3000)

    return () => {
      clearTimeout(timeout)
      subscription.unsubscribe()
    }
  }, [loadProfile, loadDemoMode])

  return (
    <AuthContext.Provider value={{ user, profile, loading, demoMode, refreshProfile, signOut }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)

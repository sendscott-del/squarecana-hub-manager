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

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [profile, setProfile] = useState<AppUser | null>(null)
  const [loading, setLoading] = useState(true)
  const [demoMode, setDemoMode] = useState(false)

  const fetchProfile = async (supabase: ReturnType<typeof createClient>, userId: string) => {
    const { data, error } = await supabase
      .from('sq_users')
      .select('*')
      .eq('id', userId)
      .single()
    console.log('[auth] profile fetch:', { data: !!data, error: error?.message })
    if (data) setProfile(data)
  }

  const fetchDemoMode = async (supabase: ReturnType<typeof createClient>) => {
    const { data, error } = await supabase
      .from('sq_settings')
      .select('value')
      .eq('key', 'demo_mode')
      .single()
    console.log('[auth] demo mode fetch:', { data: data?.value, error: error?.message })
    setDemoMode(data?.value === 'true')
  }

  const refreshProfile = async () => {
    const supabase = createClient()
    if (user) await fetchProfile(supabase, user.id)
    await fetchDemoMode(supabase)
  }

  const signOut = async () => {
    const supabase = createClient()
    await supabase.auth.signOut()
    setUser(null)
    setProfile(null)
    window.location.href = '/auth/login'
  }

  useEffect(() => {
    console.log('[auth] useEffect fired')
    const supabase = createClient()

    // Safety timeout — never hang on loading forever
    const timeout = setTimeout(() => {
      console.log('[auth] timeout — forcing loading=false')
      setLoading(false)
    }, 5000)

    const init = async () => {
      try {
        console.log('[auth] calling getUser...')
        const { data: { user: authUser }, error: authError } = await supabase.auth.getUser()
        console.log('[auth] getUser result:', { user: authUser?.email, error: authError?.message })
        setUser(authUser)

        if (authUser) {
          await fetchProfile(supabase, authUser.id)
        }
        await fetchDemoMode(supabase)
      } catch (e) {
        console.error('[auth] init error:', e)
      } finally {
        clearTimeout(timeout)
        console.log('[auth] setting loading=false')
        setLoading(false)
      }
    }
    init()

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (_event, session) => {
        setUser(session?.user ?? null)
        if (session?.user) {
          await fetchProfile(supabase, session.user.id)
        } else {
          setProfile(null)
        }
      }
    )

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

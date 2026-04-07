'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { cn } from '@/lib/utils'
import { useAuth } from '@/lib/auth-context'
import { NAV_ITEMS } from '@/lib/constants'
import {
  LayoutDashboard, Building2, FileEdit, FileText, Receipt,
  BookOpen, Settings, LogOut, ChevronLeft, Menu, X
} from 'lucide-react'
import { useState } from 'react'

const iconMap: Record<string, React.ComponentType<{ className?: string }>> = {
  LayoutDashboard, Building2, FileEdit, FileText, Receipt, BookOpen, Settings,
}

export function Sidebar() {
  const pathname = usePathname()
  const { profile, signOut } = useAuth()
  const [collapsed, setCollapsed] = useState(false)
  const [mobileOpen, setMobileOpen] = useState(false)

  const filteredNav = NAV_ITEMS.filter(item => {
    if (item.adminOnly && !profile?.is_admin) return false
    return true
  })

  const NavContent = () => (
    <div className="flex flex-col h-full">
      <div className={cn("flex items-center gap-3 px-4 py-5 border-b border-white/10", collapsed && "justify-center px-2")}>
        <div className="h-9 w-9 rounded-lg bg-white/10 flex items-center justify-center flex-shrink-0">
          <span className="text-white font-bold text-sm">SQ</span>
        </div>
        {!collapsed && (
          <div className="min-w-0">
            <h1 className="text-white font-semibold text-sm truncate">Squarecana</h1>
            <p className="text-white/60 text-xs truncate">Talent Hub Manager</p>
          </div>
        )}
      </div>

      <nav className="flex-1 px-3 py-4 space-y-1 overflow-y-auto">
        {filteredNav.map(item => {
          const Icon = iconMap[item.icon]
          const isActive = pathname === item.href || pathname.startsWith(item.href + '/')
          return (
            <Link
              key={item.href}
              href={item.href}
              onClick={() => setMobileOpen(false)}
              className={cn(
                "flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors",
                isActive
                  ? "bg-white/15 text-white"
                  : "text-white/70 hover:bg-white/10 hover:text-white",
                collapsed && "justify-center px-2"
              )}
            >
              {Icon && <Icon className="h-5 w-5 flex-shrink-0" />}
              {!collapsed && <span>{item.label}</span>}
            </Link>
          )
        })}
      </nav>

      <div className={cn("px-3 py-4 border-t border-white/10", collapsed && "px-2")}>
        {!collapsed && profile && (
          <div className="px-3 py-2 mb-2">
            <p className="text-white text-sm font-medium truncate">{profile.full_name || profile.email}</p>
            <p className="text-white/50 text-xs truncate capitalize">{profile.role?.replace('_', ' ')}</p>
          </div>
        )}
        <button
          onClick={signOut}
          className={cn(
            "flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-white/70 hover:bg-white/10 hover:text-white w-full transition-colors",
            collapsed && "justify-center px-2"
          )}
        >
          <LogOut className="h-5 w-5 flex-shrink-0" />
          {!collapsed && <span>Sign Out</span>}
        </button>
      </div>
    </div>
  )

  return (
    <>
      {/* Mobile menu button */}
      <button
        onClick={() => setMobileOpen(true)}
        className="fixed top-4 left-4 z-50 lg:hidden bg-[#0F2952] text-white p-2 rounded-lg"
      >
        <Menu className="h-5 w-5" />
      </button>

      {/* Mobile overlay */}
      {mobileOpen && (
        <div className="fixed inset-0 z-50 lg:hidden">
          <div className="absolute inset-0 bg-black/50" onClick={() => setMobileOpen(false)} />
          <div className="absolute left-0 top-0 bottom-0 w-64 bg-[#0F2952]">
            <button
              onClick={() => setMobileOpen(false)}
              className="absolute top-4 right-4 text-white/70 hover:text-white"
            >
              <X className="h-5 w-5" />
            </button>
            <NavContent />
          </div>
        </div>
      )}

      {/* Desktop sidebar */}
      <aside className={cn(
        "hidden lg:flex flex-col bg-[#0F2952] h-screen sticky top-0 transition-all duration-300",
        collapsed ? "w-16" : "w-64"
      )}>
        <NavContent />
        <button
          onClick={() => setCollapsed(!collapsed)}
          className="absolute -right-3 top-8 bg-white border shadow-sm rounded-full p-1 text-gray-600 hover:text-gray-900"
        >
          <ChevronLeft className={cn("h-3 w-3 transition-transform", collapsed && "rotate-180")} />
        </button>
      </aside>
    </>
  )
}

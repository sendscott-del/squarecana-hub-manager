'use client'

import { useEffect, useState, useMemo } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { Hub, Headcount } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { PageSkeleton } from '@/components/shared/loading-skeleton'
import { StatusBadge } from '@/components/shared/status-badge'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Users, Building2, AlertCircle, FileEdit, Lock } from 'lucide-react'
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
  PieChart, Pie, Cell, ResponsiveContainer
} from 'recharts'

const COLORS = ['#0F2952', '#3B82F6', '#F59E0B', '#10B981', '#8B5CF6', '#EF4444', '#6B7280', '#EC4899']

export default function DashboardPage() {
  const { profile: currentUser } = useAuth()
  const [hubs, setHubs] = useState<Hub[]>([])
  const [headcount, setHeadcount] = useState<Headcount[]>([])
  const [changeOrderCount, setChangeOrderCount] = useState(0)
  const [loading, setLoading] = useState(true)
  const [filters, setFilters] = useState({ hub: 'all', department: 'all', roleType: 'all' })
  const supabase = createClient()

  const canView = !!currentUser?.role

  useEffect(() => {
    if (!canView) { setLoading(false); return }
    const fetch = async () => {
      const [hubRes, hcRes, coRes] = await Promise.all([
        supabase.from('sq_hubs').select('*').eq('is_active', true),
        supabase.from('sq_headcount').select('*, hub:sq_hubs(name), country_leader:sq_users!country_leader_user_id(full_name)'),
        supabase.from('sq_change_orders').select('*', { count: 'exact', head: true }).eq('status', 'submitted'),
      ])
      if (hubRes.data) setHubs(hubRes.data)
      if (hcRes.data) setHeadcount(hcRes.data as unknown as Headcount[])
      setChangeOrderCount(coRes.count || 0)
      setLoading(false)
    }
    fetch()
  }, [canView])

  const filteredHeadcount = useMemo(() => {
    return headcount.filter(h => {
      if (filters.hub !== 'all' && h.hub_id !== filters.hub) return false
      if (filters.department !== 'all' && h.department !== filters.department) return false
      if (filters.roleType !== 'all' && h.role_type !== filters.roleType) return false
      return true
    })
  }, [headcount, filters])

  const stats = useMemo(() => {
    const active = headcount.filter(h => h.status === 'active').length
    const open = headcount.filter(h => h.status === 'open').length
    return { total: active + open, active, open, activeHubs: hubs.length }
  }, [headcount, hubs])

  const hubChartData = useMemo(() => {
    return hubs.map(hub => ({
      name: hub.name.length > 15 ? hub.name.substring(0, 15) + '...' : hub.name,
      active: headcount.filter(h => h.hub_id === hub.id && h.status === 'active').length,
      open: headcount.filter(h => h.hub_id === hub.id && h.status === 'open').length,
    }))
  }, [hubs, headcount])

  const roleTypeData = useMemo(() => {
    const counts: Record<string, number> = {}
    headcount.forEach(h => {
      const type = h.role_type || 'Unknown'
      counts[type] = (counts[type] || 0) + 1
    })
    return Object.entries(counts).map(([name, value]) => ({ name, value }))
  }, [headcount])

  const deptData = useMemo(() => {
    const counts: Record<string, number> = {}
    headcount.forEach(h => {
      const dept = h.department || 'Unknown'
      counts[dept] = (counts[dept] || 0) + 1
    })
    return Object.entries(counts).map(([name, value]) => ({ name, value }))
  }, [headcount])

  const departments = useMemo(() => Array.from(new Set(headcount.map(h => h.department).filter(Boolean))), [headcount])
  const roleTypes = useMemo(() => Array.from(new Set(headcount.map(h => h.role_type).filter(Boolean))), [headcount])

  if (!canView) {
    return (
      <div className="flex flex-col items-center justify-center py-20">
        <Lock className="h-16 w-16 text-gray-300 mb-4" />
        <h2 className="text-xl font-semibold text-gray-700 mb-2">Dashboard Access Required</h2>
        <p className="text-gray-500">Please contact your administrator to request access to the executive dashboard.</p>
      </div>
    )
  }

  if (loading) return <PageSkeleton />

  return (
    <div>
      <PageHeader title="Executive Dashboard" description="Global talent hub overview and analytics" />

      {/* Summary Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-500">Total Headcount</p>
                <p className="text-3xl font-bold text-[#0F2952]">{stats.total}</p>
              </div>
              <Users className="h-10 w-10 text-[#0F2952]/20" />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-500">Open Positions</p>
                <p className="text-3xl font-bold text-blue-600">{stats.open}</p>
              </div>
              <AlertCircle className="h-10 w-10 text-blue-600/20" />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-500">Active Hubs</p>
                <p className="text-3xl font-bold text-green-600">{stats.activeHubs}</p>
              </div>
              <Building2 className="h-10 w-10 text-green-600/20" />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-500">Pending Change Orders</p>
                <p className="text-3xl font-bold text-amber-600">{changeOrderCount}</p>
              </div>
              <FileEdit className="h-10 w-10 text-amber-600/20" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Headcount by Hub</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={hubChartData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" fontSize={11} />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="active" fill="#0F2952" name="Active" />
                <Bar dataKey="open" fill="#3B82F6" name="Open" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-base">Role Type Distribution</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie data={roleTypeData} cx="50%" cy="50%" outerRadius={100} dataKey="value" label={({ name, percent }: { name?: string; percent?: number }) => `${name || ''} ${((percent ?? 0) * 100).toFixed(0)}%`}>
                  {roleTypeData.map((_, i) => (
                    <Cell key={i} fill={COLORS[i % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* Department Chart */}
      <Card className="mb-8">
        <CardHeader>
          <CardTitle className="text-base">Department Distribution</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={deptData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="value" fill="#0F2952" name="Headcount" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* Filterable Headcount Table */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">Headcount Details</CardTitle>
          <div className="flex flex-wrap gap-3 mt-4">
            <Select value={filters.hub} onValueChange={v => setFilters({ ...filters, hub: v })}>
              <SelectTrigger className="w-[180px]"><SelectValue placeholder="Filter by hub" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Hubs</SelectItem>
                {hubs.map(h => <SelectItem key={h.id} value={h.id}>{h.name}</SelectItem>)}
              </SelectContent>
            </Select>
            <Select value={filters.department} onValueChange={v => setFilters({ ...filters, department: v })}>
              <SelectTrigger className="w-[180px]"><SelectValue placeholder="Department" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Departments</SelectItem>
                {departments.map(d => <SelectItem key={d!} value={d!}>{d}</SelectItem>)}
              </SelectContent>
            </Select>
            <Select value={filters.roleType} onValueChange={v => setFilters({ ...filters, roleType: v })}>
              <SelectTrigger className="w-[180px]"><SelectValue placeholder="Role Type" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Role Types</SelectItem>
                {roleTypes.map(r => <SelectItem key={r!} value={r!}>{r}</SelectItem>)}
              </SelectContent>
            </Select>
          </div>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b text-left">
                  <th className="py-3 px-2 font-medium">Hub</th>
                  <th className="py-3 px-2 font-medium">Employee</th>
                  <th className="py-3 px-2 font-medium">Role</th>
                  <th className="py-3 px-2 font-medium">Type</th>
                  <th className="py-3 px-2 font-medium">Department</th>
                  <th className="py-3 px-2 font-medium">Country Leader</th>
                  <th className="py-3 px-2 font-medium">Status</th>
                  <th className="py-3 px-2 font-medium">Start Date</th>
                </tr>
              </thead>
              <tbody>
                {filteredHeadcount.map(h => (
                  <tr key={h.id} className="border-b hover:bg-gray-50">
                    <td className="py-3 px-2">{(h.hub as unknown as Hub)?.name || '—'}</td>
                    <td className="py-3 px-2">{h.employee_name || <span className="italic text-gray-400">Open Position</span>}</td>
                    <td className="py-3 px-2">{h.role_title}</td>
                    <td className="py-3 px-2">{h.role_type}</td>
                    <td className="py-3 px-2">{h.department}</td>
                    <td className="py-3 px-2">{(h.country_leader as unknown as { full_name: string })?.full_name || '—'}</td>
                    <td className="py-3 px-2"><StatusBadge status={h.status} /></td>
                    <td className="py-3 px-2">{h.start_date || '—'}</td>
                  </tr>
                ))}
                {filteredHeadcount.length === 0 && (
                  <tr><td colSpan={8} className="py-8 text-center text-gray-400">No headcount records match filters</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

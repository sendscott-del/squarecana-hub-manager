'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { ChangeOrder, Hub } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { StatusBadge } from '@/components/shared/status-badge'
import { EmptyState } from '@/components/shared/empty-state'
import { TableSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Plus } from 'lucide-react'
import Link from 'next/link'
import { format } from 'date-fns'

export default function ChangeOrdersPage() {
  const { profile: currentUser } = useAuth()
  const [orders, setOrders] = useState<ChangeOrder[]>([])
  const [hubs, setHubs] = useState<Hub[]>([])
  const [loading, setLoading] = useState(true)
  const [filters, setFilters] = useState({ hub: 'all', status: 'all', changeType: 'all' })
  const supabase = createClient()

  const canCreate = ['functional_leader', 'hub_leader', 'central_ops'].includes(currentUser?.role || '')

  useEffect(() => {
    const fetch = async () => {
      const [hubRes, orderRes] = await Promise.all([
        supabase.from('sq_hubs').select('*').order('name'),
        supabase.from('sq_change_orders').select('*, hub:sq_hubs(name), submitted_by:sq_users!submitted_by_user_id(full_name)').order('created_at', { ascending: false }),
      ])
      if (hubRes.data) setHubs(hubRes.data)
      if (orderRes.data) {
        // Filter by role
        let filtered = orderRes.data as unknown as ChangeOrder[]
        if (currentUser?.role === 'functional_leader') {
          filtered = filtered.filter(o => o.submitted_by_user_id === currentUser.id)
        } else if (currentUser?.role === 'hub_leader') {
          filtered = filtered.filter(o => o.hub_id === currentUser.hub_id)
        }
        setOrders(filtered)
      }
      setLoading(false)
    }
    fetch()
  }, [currentUser])

  const filteredOrders = orders.filter(o => {
    if (filters.hub !== 'all' && o.hub_id !== filters.hub) return false
    if (filters.status !== 'all' && o.status !== filters.status) return false
    if (filters.changeType !== 'all' && o.change_type !== filters.changeType) return false
    return true
  })

  return (
    <div>
      <PageHeader title="Change Orders" description="Track and manage headcount change requests">
        {canCreate && (
          <Link href="/change-orders/new">
            <Button className="bg-[#0F2952]"><Plus className="h-4 w-4 mr-2" />New Change Order</Button>
          </Link>
        )}
      </PageHeader>

      <div className="flex flex-wrap gap-3 mb-6">
        <Select value={filters.hub} onValueChange={v => setFilters({ ...filters, hub: v })}>
          <SelectTrigger className="w-[180px]"><SelectValue placeholder="Hub" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Hubs</SelectItem>
            {hubs.map(h => <SelectItem key={h.id} value={h.id}>{h.name}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={filters.status} onValueChange={v => setFilters({ ...filters, status: v })}>
          <SelectTrigger className="w-[180px]"><SelectValue placeholder="Status" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Statuses</SelectItem>
            {['draft', 'submitted', 'under_review', 'approved', 'rejected'].map(s => (
              <SelectItem key={s} value={s}>{s.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}</SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={filters.changeType} onValueChange={v => setFilters({ ...filters, changeType: v })}>
          <SelectTrigger className="w-[150px]"><SelectValue placeholder="Type" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Types</SelectItem>
            <SelectItem value="add">Add</SelectItem>
            <SelectItem value="remove">Remove</SelectItem>
            <SelectItem value="modify">Modify</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {loading ? <TableSkeleton /> : filteredOrders.length === 0 ? (
        <EmptyState
          title="No change orders"
          description="No change orders match your current filters."
          action={canCreate ? <Link href="/change-orders/new"><Button className="bg-[#0F2952]">Create Change Order</Button></Link> : undefined}
        />
      ) : (
        <Card>
          <CardContent className="pt-0">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b text-left">
                    <th className="py-3 px-2 font-medium">Title</th>
                    <th className="py-3 px-2 font-medium">Hub</th>
                    <th className="py-3 px-2 font-medium">Type</th>
                    <th className="py-3 px-2 font-medium">Status</th>
                    <th className="py-3 px-2 font-medium">Submitted By</th>
                    <th className="py-3 px-2 font-medium">Date</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredOrders.map(o => (
                    <tr key={o.id} className="border-b hover:bg-gray-50 cursor-pointer" onClick={() => window.location.href = `/change-orders/${o.id}`}>
                      <td className="py-3 px-2 font-medium text-[#0F2952]">{o.title}</td>
                      <td className="py-3 px-2">{(o.hub as unknown as Hub)?.name || '—'}</td>
                      <td className="py-3 px-2 capitalize">{o.change_type}</td>
                      <td className="py-3 px-2"><StatusBadge status={o.status} /></td>
                      <td className="py-3 px-2">{(o.submitted_by as unknown as { full_name: string })?.full_name || '—'}</td>
                      <td className="py-3 px-2">{o.created_at ? format(new Date(o.created_at), 'MMM d, yyyy') : '—'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  )
}

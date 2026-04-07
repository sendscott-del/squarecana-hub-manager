'use client'

import { useEffect, useState, useMemo } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { Contract, Hub } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { StatusBadge } from '@/components/shared/status-badge'
import { EmptyState } from '@/components/shared/empty-state'
import { TableSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Plus, Lock, Eye } from 'lucide-react'
import Link from 'next/link'
import { format, isAfter, isBefore } from 'date-fns'

function getContractStatus(contract: Contract): string {
  if (!contract.start_date || !contract.end_date) return 'active'
  const now = new Date()
  if (isBefore(now, new Date(contract.start_date))) return 'upcoming'
  if (isAfter(now, new Date(contract.end_date))) return 'expired'
  return 'active'
}

export default function ContractsPage() {
  const { profile: currentUser } = useAuth()
  const [contracts, setContracts] = useState<Contract[]>([])
  const [hubs, setHubs] = useState<Hub[]>([])
  const [loading, setLoading] = useState(true)
  const [filters, setFilters] = useState({ hub: 'all', status: 'all' })
  const supabase = createClient()

  const isCentralOps = currentUser?.role === 'central_ops'
  const isExecutive = currentUser?.role === 'executive'

  useEffect(() => {
    const fetch = async () => {
      const [hubRes, contractRes] = await Promise.all([
        supabase.from('sq_hubs').select('*').order('name'),
        supabase.from('sq_contracts').select('*, hub:sq_hubs(name)').order('created_at', { ascending: false }),
      ])
      if (hubRes.data) setHubs(hubRes.data)
      if (contractRes.data) {
        let filtered = contractRes.data as unknown as Contract[]
        // Non-central_ops/admin can only see standard contracts
        if (!isCentralOps && !currentUser?.is_admin) {
          filtered = filtered.filter(c => c.access_level === 'standard')
        }
        setContracts(filtered)
      }
      setLoading(false)
    }
    fetch()
  }, [currentUser])

  const filteredContracts = useMemo(() => {
    return contracts.filter(c => {
      if (filters.hub !== 'all' && c.hub_id !== filters.hub) return false
      if (filters.status !== 'all' && getContractStatus(c) !== filters.status) return false
      return true
    })
  }, [contracts, filters])

  return (
    <div>
      <PageHeader title="Contracts & SOW" description="Manage vendor contracts and statements of work">
        {isCentralOps && (
          <Link href="/contracts/new">
            <Button className="bg-[#0F2952]"><Plus className="h-4 w-4 mr-2" />New Contract</Button>
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
          <SelectTrigger className="w-[150px]"><SelectValue placeholder="Status" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All</SelectItem>
            <SelectItem value="active">Active</SelectItem>
            <SelectItem value="expired">Expired</SelectItem>
            <SelectItem value="upcoming">Upcoming</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {loading ? <TableSkeleton /> : filteredContracts.length === 0 ? (
        <EmptyState title="No contracts found" description="No contracts match your current filters." />
      ) : (
        <Card>
          <CardContent className="pt-0">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b text-left">
                    <th className="py-3 px-2 font-medium">SOW #</th>
                    <th className="py-3 px-2 font-medium">Hub</th>
                    <th className="py-3 px-2 font-medium">Vendor</th>
                    <th className="py-3 px-2 font-medium">Period</th>
                    {!isExecutive && <th className="py-3 px-2 font-medium">Value</th>}
                    <th className="py-3 px-2 font-medium">Status</th>
                    <th className="py-3 px-2 font-medium">Access</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredContracts.map(c => {
                    const status = getContractStatus(c)
                    return (
                      <tr key={c.id} className="border-b hover:bg-gray-50 cursor-pointer" onClick={() => window.location.href = `/contracts/${c.id}`}>
                        <td className="py-3 px-2 font-medium text-[#0F2952]">{c.sow_number}</td>
                        <td className="py-3 px-2">{(c.hub as unknown as { name: string })?.name}</td>
                        <td className="py-3 px-2">{c.vendor_name}</td>
                        <td className="py-3 px-2">
                          {c.start_date && c.end_date ? `${format(new Date(c.start_date), 'MMM yyyy')} — ${format(new Date(c.end_date), 'MMM yyyy')}` : '—'}
                        </td>
                        {!isExecutive && <td className="py-3 px-2">{c.total_value ? `${c.currency} ${c.total_value.toLocaleString()}` : '—'}</td>}
                        <td className="py-3 px-2"><StatusBadge status={status} /></td>
                        <td className="py-3 px-2">
                          {c.access_level === 'restricted' ? (
                            <Badge variant="outline" className="border-red-200 text-red-600"><Lock className="h-3 w-3 mr-1" />Restricted</Badge>
                          ) : (
                            <Badge variant="outline"><Eye className="h-3 w-3 mr-1" />Standard</Badge>
                          )}
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  )
}

'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { Invoice, Hub } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { StatusBadge } from '@/components/shared/status-badge'
import { EmptyState } from '@/components/shared/empty-state'
import { TableSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Plus, CheckSquare } from 'lucide-react'
import Link from 'next/link'
import { format } from 'date-fns'

export default function InvoicesPage() {
  const { profile: currentUser } = useAuth()
  const [invoices, setInvoices] = useState<Invoice[]>([])
  const [hubs, setHubs] = useState<Hub[]>([])
  const [myApprovals, setMyApprovals] = useState<Array<Record<string, unknown>>>([])
  const [loading, setLoading] = useState(true)
  const [filters, setFilters] = useState({ hub: 'all', status: 'all' })
  const [tab, setTab] = useState('invoices')
  const supabase = createClient()

  const canCreate = currentUser?.role === 'central_ops' || currentUser?.role === 'executive'
  const isFunctionalLeader = currentUser?.role === 'functional_leader'

  useEffect(() => {
    const fetch = async () => {
      const [hubRes, invRes] = await Promise.all([
        supabase.from('sq_hubs').select('*').order('name'),
        supabase.from('sq_invoices').select('*, hub:sq_hubs(name)').order('created_at', { ascending: false }),
      ])
      if (hubRes.data) setHubs(hubRes.data)
      if (invRes.data) {
        // Compute approval percentages
        const invoicesWithPct = await Promise.all(
          (invRes.data as unknown as Invoice[]).map(async (inv) => {
            const { data: items } = await supabase
              .from('sq_invoice_line_items')
              .select('approval_status')
              .eq('invoice_id', inv.id)
            const total = items?.length || 0
            const approved = items?.filter((i: { approval_status: string }) => i.approval_status === 'approved').length || 0
            return { ...inv, approval_percentage: total > 0 ? Math.round((approved / total) * 100) : 0 }
          })
        )

        // Filter by role
        let filtered = invoicesWithPct
        if (currentUser?.role === 'hub_leader') {
          filtered = filtered.filter(i => i.hub_id === currentUser.hub_id)
        }
        setInvoices(filtered)
      }

      // Fetch my approvals for functional leaders
      if (isFunctionalLeader && currentUser) {
        const { data: lineItems } = await supabase
          .from('sq_invoice_line_items')
          .select('*, invoice:sq_invoices(invoice_number, vendor_name, due_date, hub:sq_hubs(name))')
          .eq('approved_by_user_id', currentUser.id)
        if (lineItems) setMyApprovals(lineItems)
      }

      setLoading(false)
    }
    fetch()
  }, [currentUser])

  const filteredInvoices = invoices.filter(i => {
    if (filters.hub !== 'all' && i.hub_id !== filters.hub) return false
    if (filters.status !== 'all' && i.status !== filters.status) return false
    return true
  })

  return (
    <div>
      <PageHeader title="Invoices" description="Manage and approve vendor invoices">
        {canCreate && (
          <Link href="/invoices/new">
            <Button className="bg-[#0F2952]"><Plus className="h-4 w-4 mr-2" />New Invoice</Button>
          </Link>
        )}
      </PageHeader>

      {isFunctionalLeader ? (
        <Tabs value={tab} onValueChange={setTab} className="mb-6">
          <TabsList>
            <TabsTrigger value="invoices">All Invoices</TabsTrigger>
            <TabsTrigger value="approvals" className="flex items-center gap-2">
              <CheckSquare className="h-4 w-4" />My Approvals
              {myApprovals.filter(a => a.approval_status === 'pending').length > 0 && (
                <span className="bg-orange-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                  {myApprovals.filter(a => a.approval_status === 'pending').length}
                </span>
              )}
            </TabsTrigger>
          </TabsList>

          <TabsContent value="approvals">
            <MyApprovalsView approvals={myApprovals} supabase={supabase} onUpdate={() => window.location.reload()} />
          </TabsContent>
          <TabsContent value="invoices">
            <InvoiceList invoices={filteredInvoices} hubs={hubs} filters={filters} setFilters={setFilters} loading={loading} canCreate={canCreate} />
          </TabsContent>
        </Tabs>
      ) : (
        <InvoiceList invoices={filteredInvoices} hubs={hubs} filters={filters} setFilters={setFilters} loading={loading} canCreate={canCreate} />
      )}
    </div>
  )
}

function InvoiceList({ invoices, hubs, filters, setFilters, loading, canCreate }: {
  invoices: Invoice[]; hubs: Hub[];
  filters: { hub: string; status: string }; setFilters: (f: { hub: string; status: string }) => void;
  loading: boolean; canCreate: boolean
}) {
  return (
    <>
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
            {['pending', 'in_review', 'approved', 'rejected', 'paid'].map(s => (
              <SelectItem key={s} value={s}>{s.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {loading ? <TableSkeleton /> : invoices.length === 0 ? (
        <EmptyState title="No invoices" description="No invoices match your filters."
          action={canCreate ? <Link href="/invoices/new"><Button className="bg-[#0F2952]">Create Invoice</Button></Link> : undefined} />
      ) : (
        <Card>
          <CardContent className="pt-0">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b text-left">
                    <th className="py-3 px-2 font-medium">Invoice #</th>
                    <th className="py-3 px-2 font-medium">Hub</th>
                    <th className="py-3 px-2 font-medium">Vendor</th>
                    <th className="py-3 px-2 font-medium">Amount</th>
                    <th className="py-3 px-2 font-medium">Due Date</th>
                    <th className="py-3 px-2 font-medium">Status</th>
                    <th className="py-3 px-2 font-medium">Approved</th>
                  </tr>
                </thead>
                <tbody>
                  {invoices.map(inv => (
                    <tr key={inv.id} className="border-b hover:bg-gray-50 cursor-pointer" onClick={() => window.location.href = `/invoices/${inv.id}`}>
                      <td className="py-3 px-2 font-medium text-[#0F2952]">{inv.invoice_number}</td>
                      <td className="py-3 px-2">{(inv.hub as unknown as { name: string })?.name}</td>
                      <td className="py-3 px-2">{inv.vendor_name}</td>
                      <td className="py-3 px-2">{inv.total_amount ? `${inv.currency} ${inv.total_amount.toLocaleString()}` : '—'}</td>
                      <td className="py-3 px-2">{inv.due_date ? format(new Date(inv.due_date), 'MMM d, yyyy') : '—'}</td>
                      <td className="py-3 px-2"><StatusBadge status={inv.status} /></td>
                      <td className="py-3 px-2">
                        <div className="flex items-center gap-2">
                          <div className="w-16 bg-gray-200 rounded-full h-2">
                            <div className="bg-green-500 h-2 rounded-full" style={{ width: `${inv.approval_percentage}%` }} />
                          </div>
                          <span className="text-xs">{inv.approval_percentage}%</span>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>
      )}
    </>
  )
}

function MyApprovalsView({ approvals, supabase, onUpdate }: {
  approvals: Array<Record<string, unknown>>; supabase: ReturnType<typeof createClient>; onUpdate: () => void
}) {
  const [notes, setNotes] = useState<Record<string, string>>({})
  const [saving, setSaving] = useState<string | null>(null)

  const handleAction = async (itemId: string, status: 'approved' | 'disputed') => {
    setSaving(itemId)
    await supabase
      .from('sq_invoice_line_items')
      .update({ approval_status: status, approval_note: notes[itemId] || null })
      .eq('id', itemId)
    setSaving(null)
    onUpdate()
  }

  const pending = approvals.filter(a => a.approval_status === 'pending')
  const completed = approvals.filter(a => a.approval_status !== 'pending')

  return (
    <div className="space-y-6">
      <Card>
        <CardContent className="pt-6">
          <h3 className="font-medium mb-4">Pending Approvals ({pending.length})</h3>
          {pending.length === 0 ? (
            <p className="text-gray-500 text-sm">No pending approvals.</p>
          ) : (
            <div className="space-y-3">
              {pending.map(item => {
                const invoice = item.invoice as Record<string, unknown> | null
                const hub = invoice?.hub as Record<string, unknown> | null
                return (
                  <div key={item.id as string} className="border rounded-lg p-4">
                    <div className="flex flex-wrap items-start justify-between gap-4">
                      <div>
                        <p className="font-medium">{item.employee_name as string} — {item.role_title as string}</p>
                        <p className="text-sm text-gray-500">
                          Invoice {invoice?.invoice_number as string} | {hub?.name as string} | {item.days_worked as number} days @ ${item.rate as number}/day = ${(item.amount as number)?.toLocaleString()}
                        </p>
                        {typeof invoice?.due_date === 'string' && (
                          <p className="text-xs text-orange-600 mt-1">Due: {format(new Date(invoice.due_date), 'MMM d, yyyy')}</p>
                        )}
                      </div>
                      <div className="flex items-center gap-2">
                        <input
                          className="border rounded px-2 py-1 text-sm w-40"
                          placeholder="Note (optional)"
                          value={notes[item.id as string] || ''}
                          onChange={e => setNotes({ ...notes, [item.id as string]: e.target.value })}
                        />
                        <Button
                          size="sm"
                          className="bg-green-600 hover:bg-green-700"
                          onClick={() => handleAction(item.id as string, 'approved')}
                          disabled={saving === item.id}
                        >Approve</Button>
                        <Button
                          size="sm"
                          variant="destructive"
                          onClick={() => handleAction(item.id as string, 'disputed')}
                          disabled={saving === item.id}
                        >Dispute</Button>
                      </div>
                    </div>
                  </div>
                )
              })}
            </div>
          )}
        </CardContent>
      </Card>

      {completed.length > 0 && (
        <Card>
          <CardContent className="pt-6">
            <h3 className="font-medium mb-4">Completed ({completed.length})</h3>
            <div className="space-y-2">
              {completed.map(item => (
                <div key={item.id as string} className="flex items-center justify-between border rounded-lg p-3">
                  <div>
                    <p className="text-sm font-medium">{item.employee_name as string} — {item.role_title as string}</p>
                    <p className="text-xs text-gray-500">${(item.amount as number)?.toLocaleString()}</p>
                  </div>
                  <StatusBadge status={item.approval_status as string} />
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  )
}

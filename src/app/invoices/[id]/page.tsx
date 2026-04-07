'use client'

import { useEffect, useState } from 'react'
import { useParams } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { Invoice, InvoiceLineItem } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { StatusBadge } from '@/components/shared/status-badge'
import { PageSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { ArrowLeft, CheckCircle, XCircle } from 'lucide-react'
import { toast } from 'sonner'
import Link from 'next/link'
import { format } from 'date-fns'

export default function InvoiceDetailPage() {
  const { id } = useParams()
  const { profile: currentUser } = useAuth()
  const [invoice, setInvoice] = useState<Invoice | null>(null)
  const [lineItems, setLineItems] = useState<InvoiceLineItem[]>([])
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState<string | null>(null)
  const supabase = createClient()

  const fetchData = async () => {
    const [invRes, itemsRes] = await Promise.all([
      supabase.from('sq_invoices').select('*, hub:sq_hubs(name)').eq('id', id).single(),
      supabase.from('sq_invoice_line_items').select('*, approver:sq_users!approved_by_user_id(full_name)').eq('invoice_id', id).order('created_at'),
    ])
    if (invRes.data) setInvoice(invRes.data as unknown as Invoice)
    if (itemsRes.data) setLineItems(itemsRes.data as unknown as InvoiceLineItem[])
    setLoading(false)
  }

  useEffect(() => { fetchData() }, [id])

  const handleApproval = async (itemId: string, status: 'approved' | 'disputed', note?: string) => {
    setSaving(itemId)
    await supabase
      .from('sq_invoice_line_items')
      .update({ approval_status: status, approval_note: note || null })
      .eq('id', itemId)

    // Check if all items are approved -> auto update invoice status
    const { data: allItems } = await supabase
      .from('sq_invoice_line_items')
      .select('approval_status')
      .eq('invoice_id', id)

    if (allItems) {
      const allApproved = allItems.every((i: { approval_status: string }) => i.approval_status === 'approved')
      const anyDisputed = allItems.some((i: { approval_status: string }) => i.approval_status === 'disputed')

      if (allApproved) {
        await supabase.from('sq_invoices').update({ status: 'approved' }).eq('id', id)
      } else if (!anyDisputed) {
        await supabase.from('sq_invoices').update({ status: 'in_review' }).eq('id', id)
      }
    }

    await fetchData()
    setSaving(null)
    toast.success(`Line item ${status}`)
  }

  const updateInvoiceStatus = async (status: string) => {
    await supabase.from('sq_invoices').update({ status }).eq('id', id)
    await fetchData()
    toast.success(`Invoice status updated to ${status}`)
  }

  if (loading) return <PageSkeleton />
  if (!invoice) return <div>Invoice not found</div>

  const approvedCount = lineItems.filter(i => i.approval_status === 'approved').length
  const totalCount = lineItems.length
  const pct = totalCount > 0 ? Math.round((approvedCount / totalCount) * 100) : 0

  const canManage = currentUser?.role === 'central_ops' || currentUser?.role === 'executive'

  return (
    <div>
      <Link href="/invoices" className="text-sm text-gray-500 hover:text-gray-700 flex items-center gap-1 mb-4">
        <ArrowLeft className="h-4 w-4" /> Back to Invoices
      </Link>

      <PageHeader title={`Invoice ${invoice.invoice_number}`}>
        <StatusBadge status={invoice.status} />
      </PageHeader>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader><CardTitle className="text-base">Invoice Summary</CardTitle></CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div><span className="text-gray-500">Hub:</span> <span className="ml-2">{(invoice.hub as unknown as { name: string })?.name}</span></div>
                <div><span className="text-gray-500">Vendor:</span> <span className="ml-2">{invoice.vendor_name}</span></div>
                <div><span className="text-gray-500">Invoice Date:</span> <span className="ml-2">{invoice.invoice_date ? format(new Date(invoice.invoice_date), 'MMM d, yyyy') : '—'}</span></div>
                <div><span className="text-gray-500">Due Date:</span> <span className="ml-2">{invoice.due_date ? format(new Date(invoice.due_date), 'MMM d, yyyy') : '—'}</span></div>
                <div><span className="text-gray-500">Total Amount:</span> <span className="ml-2 font-semibold">{invoice.currency} {invoice.total_amount?.toLocaleString()}</span></div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center justify-between">
                <CardTitle className="text-base">Line Items ({totalCount})</CardTitle>
                <div className="flex items-center gap-2">
                  <div className="w-24 bg-gray-200 rounded-full h-2">
                    <div className="bg-green-500 h-2 rounded-full" style={{ width: `${pct}%` }} />
                  </div>
                  <span className="text-xs text-gray-500">{pct}% approved</span>
                </div>
              </div>
            </CardHeader>
            <CardContent>
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b text-left">
                      <th className="py-2 px-2 font-medium">Employee</th>
                      <th className="py-2 px-2 font-medium">Role</th>
                      <th className="py-2 px-2 font-medium">Days</th>
                      <th className="py-2 px-2 font-medium">Rate</th>
                      <th className="py-2 px-2 font-medium">Amount</th>
                      <th className="py-2 px-2 font-medium">Status</th>
                      <th className="py-2 px-2 font-medium">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {lineItems.map(item => {
                      const canApprove = item.approved_by_user_id === currentUser?.id && item.approval_status === 'pending'
                      return (
                        <tr key={item.id} className="border-b">
                          <td className="py-3 px-2">{item.employee_name}</td>
                          <td className="py-3 px-2">{item.role_title}</td>
                          <td className="py-3 px-2">{item.days_worked}</td>
                          <td className="py-3 px-2">${item.rate?.toLocaleString()}</td>
                          <td className="py-3 px-2 font-medium">${item.amount?.toLocaleString()}</td>
                          <td className="py-3 px-2"><StatusBadge status={item.approval_status} /></td>
                          <td className="py-3 px-2">
                            {canApprove ? (
                              <div className="flex gap-1">
                                <Button size="sm" className="bg-green-600 hover:bg-green-700 h-7 text-xs" onClick={() => handleApproval(item.id, 'approved')} disabled={saving === item.id}>
                                  <CheckCircle className="h-3 w-3 mr-1" />Approve
                                </Button>
                                <Button size="sm" variant="destructive" className="h-7 text-xs" onClick={() => handleApproval(item.id, 'disputed')} disabled={saving === item.id}>
                                  <XCircle className="h-3 w-3 mr-1" />Dispute
                                </Button>
                              </div>
                            ) : item.approval_note ? (
                              <span className="text-xs text-gray-500">{item.approval_note}</span>
                            ) : (
                              <span className="text-xs text-gray-400">—</span>
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
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader><CardTitle className="text-base">Approval Progress</CardTitle></CardHeader>
            <CardContent className="text-sm space-y-3">
              <div className="flex justify-between"><span>Approved</span><span className="text-green-600">{approvedCount}</span></div>
              <div className="flex justify-between"><span>Pending</span><span className="text-orange-600">{lineItems.filter(i => i.approval_status === 'pending').length}</span></div>
              <div className="flex justify-between"><span>Disputed</span><span className="text-red-600">{lineItems.filter(i => i.approval_status === 'disputed').length}</span></div>
              <Separator />
              <div className="flex justify-between font-medium"><span>Total Items</span><span>{totalCount}</span></div>
            </CardContent>
          </Card>

          {canManage && (
            <Card>
              <CardHeader><CardTitle className="text-base">Actions</CardTitle></CardHeader>
              <CardContent className="space-y-2">
                {invoice.status !== 'paid' && (
                  <Button className="w-full bg-emerald-600 hover:bg-emerald-700" onClick={() => updateInvoiceStatus('paid')}>Mark as Paid</Button>
                )}
                {invoice.status !== 'approved' && pct === 100 && (
                  <Button className="w-full bg-green-600 hover:bg-green-700" onClick={() => updateInvoiceStatus('approved')}>Approve Invoice</Button>
                )}
                {invoice.status !== 'rejected' && (
                  <Button variant="destructive" className="w-full" onClick={() => updateInvoiceStatus('rejected')}>Reject Invoice</Button>
                )}
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  )
}

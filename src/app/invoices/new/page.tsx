'use client'

import { useState, useEffect } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { useRouter } from 'next/navigation'
import { Hub } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { ArrowLeft, Plus, Trash2 } from 'lucide-react'
import { toast } from 'sonner'
import Link from 'next/link'

interface LineItemForm {
  employee_name: string
  role_title: string
  days_worked: string
  rate: string
  approved_by_user_id: string
}

export default function NewInvoicePage() {
  const { profile: currentUser } = useAuth()
  const router = useRouter()
  const supabase = createClient()
  const [hubs, setHubs] = useState<Hub[]>([])
  const [saving, setSaving] = useState(false)
  const [form, setForm] = useState({
    hub_id: currentUser?.hub_id || '',
    vendor_name: '',
    invoice_number: '',
    invoice_date: '',
    due_date: '',
    currency: 'USD',
  })
  const [lineItems, setLineItems] = useState<LineItemForm[]>([
    { employee_name: '', role_title: '', days_worked: '', rate: '', approved_by_user_id: '' },
  ])

  useEffect(() => {
    supabase.from('sq_hubs').select('*').order('name').then(({ data }) => {
      if (data) setHubs(data)
    })
  }, [])

  const addLineItem = () => {
    setLineItems([...lineItems, { employee_name: '', role_title: '', days_worked: '', rate: '', approved_by_user_id: '' }])
  }

  const removeLineItem = (i: number) => {
    setLineItems(lineItems.filter((_, j) => j !== i))
  }

  const updateLineItem = (i: number, field: string, value: string) => {
    const updated = [...lineItems]
    updated[i] = { ...updated[i], [field]: value }
    setLineItems(updated)
  }

  const totalAmount = lineItems.reduce((sum, item) => {
    return sum + (Number(item.days_worked) || 0) * (Number(item.rate) || 0)
  }, 0)

  const handleSubmit = async () => {
    if (!form.hub_id || !form.invoice_number) {
      toast.error('Please fill required fields')
      return
    }
    setSaving(true)

    const { data: invoice, error } = await supabase.from('sq_invoices').insert({
      hub_id: form.hub_id,
      vendor_name: form.vendor_name,
      invoice_number: form.invoice_number,
      invoice_date: form.invoice_date || null,
      due_date: form.due_date || null,
      total_amount: totalAmount,
      currency: form.currency,
      status: 'pending',
      submitted_by: currentUser?.id,
    }).select().single()

    if (error || !invoice) {
      toast.error('Failed to create invoice')
      setSaving(false)
      return
    }

    // Insert line items
    const items = lineItems
      .filter(li => li.employee_name)
      .map(li => ({
        invoice_id: invoice.id,
        employee_name: li.employee_name,
        role_title: li.role_title,
        days_worked: Number(li.days_worked) || 0,
        rate: Number(li.rate) || 0,
        amount: (Number(li.days_worked) || 0) * (Number(li.rate) || 0),
        approved_by_user_id: li.approved_by_user_id || null,
      }))

    if (items.length > 0) {
      await supabase.from('sq_invoice_line_items').insert(items)
    }

    toast.success('Invoice created')
    router.push(`/invoices/${invoice.id}`)
    setSaving(false)
  }

  return (
    <div>
      <Link href="/invoices" className="text-sm text-gray-500 hover:text-gray-700 flex items-center gap-1 mb-4">
        <ArrowLeft className="h-4 w-4" /> Back to Invoices
      </Link>
      <PageHeader title="New Invoice" />

      <div className="space-y-6 max-w-4xl">
        <Card>
          <CardHeader><CardTitle className="text-base">Invoice Details</CardTitle></CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Hub *</Label>
                <Select value={form.hub_id} onValueChange={v => setForm({ ...form, hub_id: v })}>
                  <SelectTrigger><SelectValue placeholder="Select hub" /></SelectTrigger>
                  <SelectContent>{hubs.map(h => <SelectItem key={h.id} value={h.id}>{h.name}</SelectItem>)}</SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Invoice Number *</Label>
                <Input value={form.invoice_number} onChange={e => setForm({ ...form, invoice_number: e.target.value })} placeholder="INV-2024-0001" />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Vendor Name</Label>
                <Input value={form.vendor_name} onChange={e => setForm({ ...form, vendor_name: e.target.value })} />
              </div>
              <div className="space-y-2">
                <Label>Currency</Label>
                <Select value={form.currency} onValueChange={v => setForm({ ...form, currency: v })}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="USD">USD</SelectItem>
                    <SelectItem value="EUR">EUR</SelectItem>
                    <SelectItem value="INR">INR</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Invoice Date</Label>
                <Input type="date" value={form.invoice_date} onChange={e => setForm({ ...form, invoice_date: e.target.value })} />
              </div>
              <div className="space-y-2">
                <Label>Due Date</Label>
                <Input type="date" value={form.due_date} onChange={e => setForm({ ...form, due_date: e.target.value })} />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="text-base">Line Items</CardTitle>
              <Button variant="outline" size="sm" onClick={addLineItem}><Plus className="h-4 w-4 mr-1" />Add Line</Button>
            </div>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {lineItems.map((item, i) => (
                <div key={i} className="grid grid-cols-6 gap-3 items-end border-b pb-4">
                  <div className="col-span-2 space-y-1">
                    <Label className="text-xs">Employee Name</Label>
                    <Input value={item.employee_name} onChange={e => updateLineItem(i, 'employee_name', e.target.value)} />
                  </div>
                  <div className="space-y-1">
                    <Label className="text-xs">Role</Label>
                    <Input value={item.role_title} onChange={e => updateLineItem(i, 'role_title', e.target.value)} />
                  </div>
                  <div className="space-y-1">
                    <Label className="text-xs">Days</Label>
                    <Input type="number" value={item.days_worked} onChange={e => updateLineItem(i, 'days_worked', e.target.value)} />
                  </div>
                  <div className="space-y-1">
                    <Label className="text-xs">Rate/Day</Label>
                    <Input type="number" value={item.rate} onChange={e => updateLineItem(i, 'rate', e.target.value)} />
                  </div>
                  <div className="flex items-end gap-2">
                    <span className="text-sm font-medium pb-2">${((Number(item.days_worked) || 0) * (Number(item.rate) || 0)).toLocaleString()}</span>
                    {lineItems.length > 1 && (
                      <Button variant="ghost" size="sm" onClick={() => removeLineItem(i)} className="text-red-500 pb-1">
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    )}
                  </div>
                </div>
              ))}
            </div>
            <div className="flex justify-between items-center mt-4 pt-4 border-t">
              <span className="text-lg font-semibold">Total: ${totalAmount.toLocaleString()}</span>
              <Button className="bg-[#0F2952]" onClick={handleSubmit} disabled={saving}>
                {saving ? 'Creating...' : 'Create Invoice'}
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

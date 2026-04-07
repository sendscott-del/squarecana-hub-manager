'use client'

import { useState, useEffect } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { useRouter } from 'next/navigation'
import { Hub } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { ArrowLeft } from 'lucide-react'
import { toast } from 'sonner'
import Link from 'next/link'

export default function NewContractPage() {
  const { profile: currentUser } = useAuth()
  const router = useRouter()
  const supabase = createClient()
  const [hubs, setHubs] = useState<Hub[]>([])
  const [saving, setSaving] = useState(false)
  const [form, setForm] = useState({
    hub_id: '',
    sow_number: '',
    vendor_name: '',
    start_date: '',
    end_date: '',
    total_value: '',
    currency: 'USD',
    document_url: '',
    access_level: 'standard',
  })

  useEffect(() => {
    supabase.from('sq_hubs').select('*').order('name').then(({ data }) => {
      if (data) setHubs(data)
    })
  }, [])

  const handleSubmit = async () => {
    if (!form.hub_id || !form.sow_number) {
      toast.error('Please fill required fields')
      return
    }
    setSaving(true)
    const { data, error } = await supabase.from('sq_contracts').insert({
      ...form,
      total_value: form.total_value ? Number(form.total_value) : null,
      start_date: form.start_date || null,
      end_date: form.end_date || null,
      document_url: form.document_url || null,
      created_by: currentUser?.id,
    }).select().single()

    if (error) {
      toast.error('Failed to create contract')
    } else {
      toast.success('Contract created')
      router.push(`/contracts/${data.id}`)
    }
    setSaving(false)
  }

  return (
    <div>
      <Link href="/contracts" className="text-sm text-gray-500 hover:text-gray-700 flex items-center gap-1 mb-4">
        <ArrowLeft className="h-4 w-4" /> Back to Contracts
      </Link>
      <PageHeader title="New Contract" />
      <Card className="max-w-2xl">
        <CardContent className="pt-6 space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Hub *</Label>
              <Select value={form.hub_id} onValueChange={v => setForm({ ...form, hub_id: v })}>
                <SelectTrigger><SelectValue placeholder="Select hub" /></SelectTrigger>
                <SelectContent>{hubs.map(h => <SelectItem key={h.id} value={h.id}>{h.name}</SelectItem>)}</SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>SOW Number *</Label>
              <Input value={form.sow_number} onChange={e => setForm({ ...form, sow_number: e.target.value })} placeholder="SOW-2024-003" />
            </div>
          </div>
          <div className="space-y-2">
            <Label>Vendor Name</Label>
            <Input value={form.vendor_name} onChange={e => setForm({ ...form, vendor_name: e.target.value })} />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Start Date</Label>
              <Input type="date" value={form.start_date} onChange={e => setForm({ ...form, start_date: e.target.value })} />
            </div>
            <div className="space-y-2">
              <Label>End Date</Label>
              <Input type="date" value={form.end_date} onChange={e => setForm({ ...form, end_date: e.target.value })} />
            </div>
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Total Value</Label>
              <Input type="number" value={form.total_value} onChange={e => setForm({ ...form, total_value: e.target.value })} />
            </div>
            <div className="space-y-2">
              <Label>Currency</Label>
              <Select value={form.currency} onValueChange={v => setForm({ ...form, currency: v })}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="USD">USD</SelectItem>
                  <SelectItem value="EUR">EUR</SelectItem>
                  <SelectItem value="INR">INR</SelectItem>
                  <SelectItem value="COP">COP</SelectItem>
                  <SelectItem value="ZAR">ZAR</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <div className="space-y-2">
            <Label>Document URL</Label>
            <Input value={form.document_url} onChange={e => setForm({ ...form, document_url: e.target.value })} placeholder="https://..." />
          </div>
          <div className="space-y-2">
            <Label>Access Level</Label>
            <Select value={form.access_level} onValueChange={v => setForm({ ...form, access_level: v })}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                <SelectItem value="standard">Standard (visible to all roles)</SelectItem>
                <SelectItem value="restricted">Restricted (central ops + admin only)</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <Button className="bg-[#0F2952]" onClick={handleSubmit} disabled={saving}>
            {saving ? 'Creating...' : 'Create Contract'}
          </Button>
        </CardContent>
      </Card>
    </div>
  )
}

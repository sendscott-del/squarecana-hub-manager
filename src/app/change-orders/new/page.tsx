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
import { Textarea } from '@/components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { ArrowLeft } from 'lucide-react'
import { toast } from 'sonner'
import Link from 'next/link'

export default function NewChangeOrderPage() {
  const { profile: currentUser } = useAuth()
  const router = useRouter()
  const supabase = createClient()
  const [hubs, setHubs] = useState<Hub[]>([])
  const [saving, setSaving] = useState(false)
  const [form, setForm] = useState({
    hub_id: currentUser?.hub_id || '',
    title: '',
    description: '',
    change_type: 'add' as string,
  })

  useEffect(() => {
    supabase.from('sq_hubs').select('*').order('name').then(({ data }) => {
      if (data) setHubs(data)
    })
  }, [])

  const handleSubmit = async (asDraft: boolean) => {
    if (!form.title || !form.hub_id) {
      toast.error('Please fill in required fields')
      return
    }
    setSaving(true)
    const { data, error } = await supabase.from('sq_change_orders').insert({
      hub_id: form.hub_id,
      submitted_by_user_id: currentUser?.id,
      title: form.title,
      description: form.description,
      change_type: form.change_type,
      status: asDraft ? 'draft' : 'submitted',
      submitted_at: asDraft ? null : new Date().toISOString(),
    }).select().single()

    if (error) {
      toast.error('Failed to create change order')
      setSaving(false)
      return
    }
    toast.success(asDraft ? 'Draft saved' : 'Change order submitted')
    router.push(`/change-orders/${data.id}`)
  }

  return (
    <div>
      <Link href="/change-orders" className="text-sm text-gray-500 hover:text-gray-700 flex items-center gap-1 mb-4">
        <ArrowLeft className="h-4 w-4" /> Back to Change Orders
      </Link>
      <PageHeader title="New Change Order" />

      <Card className="max-w-2xl">
        <CardContent className="pt-6 space-y-4">
          <div className="space-y-2">
            <Label>Hub *</Label>
            <Select value={form.hub_id} onValueChange={v => setForm({ ...form, hub_id: v })}>
              <SelectTrigger><SelectValue placeholder="Select hub" /></SelectTrigger>
              <SelectContent>
                {hubs.map(h => <SelectItem key={h.id} value={h.id}>{h.name}</SelectItem>)}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>Title *</Label>
            <Input value={form.title} onChange={e => setForm({ ...form, title: e.target.value })} placeholder="e.g., Add Senior Data Analyst" />
          </div>
          <div className="space-y-2">
            <Label>Change Type</Label>
            <Select value={form.change_type} onValueChange={v => setForm({ ...form, change_type: v })}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                <SelectItem value="add">Add Position</SelectItem>
                <SelectItem value="remove">Remove Position</SelectItem>
                <SelectItem value="modify">Modify Position</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>Description</Label>
            <Textarea value={form.description} onChange={e => setForm({ ...form, description: e.target.value })} rows={4} placeholder="Describe the change and rationale..." />
          </div>
          <div className="flex gap-3 pt-4">
            <Button variant="outline" onClick={() => handleSubmit(true)} disabled={saving}>Save as Draft</Button>
            <Button className="bg-[#0F2952]" onClick={() => handleSubmit(false)} disabled={saving}>Submit for Review</Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

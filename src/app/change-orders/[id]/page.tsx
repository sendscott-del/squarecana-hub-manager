'use client'

import { useEffect, useState } from 'react'
import { useParams } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { ChangeOrder } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { StatusBadge } from '@/components/shared/status-badge'
import { PageSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { Separator } from '@/components/ui/separator'
import { ArrowLeft, CheckCircle, XCircle, Eye } from 'lucide-react'
import { toast } from 'sonner'
import Link from 'next/link'
import { format } from 'date-fns'

export default function ChangeOrderDetailPage() {
  const { id } = useParams()
  const { profile: currentUser } = useAuth()
  const [order, setOrder] = useState<ChangeOrder | null>(null)
  const [loading, setLoading] = useState(true)
  const [reviewNotes, setReviewNotes] = useState('')
  const [saving, setSaving] = useState(false)
  const supabase = createClient()

  const isCentralOps = currentUser?.role === 'central_ops'

  useEffect(() => {
    const fetch = async () => {
      const { data } = await supabase
        .from('sq_change_orders')
        .select('*, hub:sq_hubs(name), submitted_by:sq_users!submitted_by_user_id(full_name), reviewer:sq_users!reviewer_user_id(full_name)')
        .eq('id', id)
        .single()
      if (data) setOrder(data as unknown as ChangeOrder)
      setLoading(false)
    }
    fetch()
  }, [id])

  const updateStatus = async (newStatus: string) => {
    setSaving(true)
    const update: Record<string, unknown> = {
      status: newStatus,
      reviewer_user_id: currentUser?.id,
      review_notes: reviewNotes || order?.review_notes,
      reviewed_at: new Date().toISOString(),
    }
    if (newStatus === 'submitted') update.submitted_at = new Date().toISOString()

    const { error } = await supabase
      .from('sq_change_orders')
      .update(update)
      .eq('id', id)

    if (error) {
      toast.error('Failed to update status')
    } else {
      toast.success(`Status updated to ${newStatus.replace(/_/g, ' ')}`)
      // Refresh
      const { data } = await supabase
        .from('sq_change_orders')
        .select('*, hub:sq_hubs(name), submitted_by:sq_users!submitted_by_user_id(full_name), reviewer:sq_users!reviewer_user_id(full_name)')
        .eq('id', id)
        .single()
      if (data) setOrder(data as unknown as ChangeOrder)
    }
    setSaving(false)
  }

  if (loading) return <PageSkeleton />
  if (!order) return <div>Change order not found</div>

  const nextStatuses: Record<string, string[]> = {
    draft: ['submitted'],
    submitted: ['under_review'],
    under_review: ['approved', 'rejected'],
  }

  return (
    <div>
      <Link href="/change-orders" className="text-sm text-gray-500 hover:text-gray-700 flex items-center gap-1 mb-4">
        <ArrowLeft className="h-4 w-4" /> Back to Change Orders
      </Link>

      <PageHeader title={order.title}>
        <StatusBadge status={order.status} />
      </PageHeader>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="text-base">Details</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div><span className="text-gray-500">Hub:</span> <span className="ml-2">{(order.hub as unknown as { name: string })?.name}</span></div>
                <div><span className="text-gray-500">Change Type:</span> <span className="ml-2 capitalize">{order.change_type}</span></div>
                <div><span className="text-gray-500">Submitted By:</span> <span className="ml-2">{(order.submitted_by as unknown as { full_name: string })?.full_name}</span></div>
                <div><span className="text-gray-500">Created:</span> <span className="ml-2">{format(new Date(order.created_at), 'MMM d, yyyy')}</span></div>
                {order.submitted_at && (
                  <div><span className="text-gray-500">Submitted:</span> <span className="ml-2">{format(new Date(order.submitted_at), 'MMM d, yyyy')}</span></div>
                )}
                {order.reviewed_at && (
                  <div><span className="text-gray-500">Reviewed:</span> <span className="ml-2">{format(new Date(order.reviewed_at), 'MMM d, yyyy')}</span></div>
                )}
              </div>
              <Separator />
              <div>
                <h4 className="font-medium text-sm mb-2">Description</h4>
                <p className="text-sm text-gray-700 whitespace-pre-wrap">{order.description || 'No description provided.'}</p>
              </div>
              {order.review_notes && (
                <>
                  <Separator />
                  <div>
                    <h4 className="font-medium text-sm mb-2">Reviewer Notes</h4>
                    <p className="text-sm text-gray-700 whitespace-pre-wrap">{order.review_notes}</p>
                    {order.reviewer && (
                      <p className="text-xs text-gray-400 mt-1">— {(order.reviewer as unknown as { full_name: string })?.full_name}</p>
                    )}
                  </div>
                </>
              )}
            </CardContent>
          </Card>
        </div>

        {/* Actions sidebar */}
        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="text-base">Status History</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3 text-sm">
              <div className="flex items-center gap-2">
                <div className="h-2 w-2 rounded-full bg-green-500" />
                <span>Created {format(new Date(order.created_at), 'MMM d, yyyy')}</span>
              </div>
              {order.submitted_at && (
                <div className="flex items-center gap-2">
                  <div className="h-2 w-2 rounded-full bg-blue-500" />
                  <span>Submitted {format(new Date(order.submitted_at), 'MMM d, yyyy')}</span>
                </div>
              )}
              {order.reviewed_at && (
                <div className="flex items-center gap-2">
                  <div className={`h-2 w-2 rounded-full ${order.status === 'approved' ? 'bg-green-500' : order.status === 'rejected' ? 'bg-red-500' : 'bg-yellow-500'}`} />
                  <span>{order.status === 'approved' ? 'Approved' : order.status === 'rejected' ? 'Rejected' : 'Under Review'} {format(new Date(order.reviewed_at), 'MMM d, yyyy')}</span>
                </div>
              )}
            </CardContent>
          </Card>

          {isCentralOps && nextStatuses[order.status] && (
            <Card>
              <CardHeader>
                <CardTitle className="text-base">Actions</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label>Review Notes</Label>
                  <Textarea
                    value={reviewNotes}
                    onChange={e => setReviewNotes(e.target.value)}
                    placeholder="Add notes for this status change..."
                    rows={3}
                  />
                </div>
                <div className="flex flex-col gap-2">
                  {nextStatuses[order.status].map(status => (
                    <Button
                      key={status}
                      onClick={() => updateStatus(status)}
                      disabled={saving}
                      variant={status === 'rejected' ? 'destructive' : 'default'}
                      className={status === 'approved' ? 'bg-green-600 hover:bg-green-700' : status === 'rejected' ? '' : 'bg-[#0F2952]'}
                    >
                      {status === 'approved' && <CheckCircle className="h-4 w-4 mr-2" />}
                      {status === 'rejected' && <XCircle className="h-4 w-4 mr-2" />}
                      {status === 'under_review' && <Eye className="h-4 w-4 mr-2" />}
                      {status.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}
                    </Button>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          {/* Submit draft */}
          {order.status === 'draft' && order.submitted_by_user_id === currentUser?.id && (
            <Card>
              <CardContent className="pt-6">
                <Button onClick={() => updateStatus('submitted')} disabled={saving} className="w-full bg-[#0F2952]">
                  Submit for Review
                </Button>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  )
}

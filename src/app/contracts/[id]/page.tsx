'use client'

import { useEffect, useState } from 'react'
import { useParams } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { Contract } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { StatusBadge } from '@/components/shared/status-badge'
import { PageSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { ArrowLeft, Lock, FileText, Info } from 'lucide-react'
import Link from 'next/link'
import { format, isAfter, isBefore } from 'date-fns'

export default function ContractDetailPage() {
  const { id } = useParams()
  const { profile: currentUser } = useAuth()
  const [contract, setContract] = useState<Contract | null>(null)
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  const isExecutive = currentUser?.role === 'executive'

  useEffect(() => {
    const fetch = async () => {
      const { data } = await supabase
        .from('sq_contracts')
        .select('*, hub:sq_hubs(name)')
        .eq('id', id)
        .single()
      if (data) setContract(data as unknown as Contract)
      setLoading(false)
    }
    fetch()
  }, [id])

  if (loading) return <PageSkeleton />
  if (!contract) return <div>Contract not found</div>

  const getStatus = () => {
    if (!contract.start_date || !contract.end_date) return 'active'
    const now = new Date()
    if (isBefore(now, new Date(contract.start_date))) return 'upcoming'
    if (isAfter(now, new Date(contract.end_date))) return 'expired'
    return 'active'
  }

  return (
    <div>
      <Link href="/contracts" className="text-sm text-gray-500 hover:text-gray-700 flex items-center gap-1 mb-4">
        <ArrowLeft className="h-4 w-4" /> Back to Contracts
      </Link>

      <PageHeader title={contract.sow_number || 'Contract'}>
        <StatusBadge status={getStatus()} />
        {contract.access_level === 'restricted' && (
          <Badge variant="outline" className="border-red-200 text-red-600"><Lock className="h-3 w-3 mr-1" />Restricted</Badge>
        )}
      </PageHeader>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="text-base">Contract Summary</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div><span className="text-gray-500">Hub:</span> <span className="ml-2">{(contract.hub as unknown as { name: string })?.name}</span></div>
                <div><span className="text-gray-500">Vendor:</span> <span className="ml-2">{contract.vendor_name}</span></div>
                <div><span className="text-gray-500">Start Date:</span> <span className="ml-2">{contract.start_date ? format(new Date(contract.start_date), 'MMM d, yyyy') : '—'}</span></div>
                <div><span className="text-gray-500">End Date:</span> <span className="ml-2">{contract.end_date ? format(new Date(contract.end_date), 'MMM d, yyyy') : '—'}</span></div>
                {!isExecutive && (
                  <>
                    <div><span className="text-gray-500">Total Value:</span> <span className="ml-2">{contract.total_value ? `${contract.currency} ${contract.total_value.toLocaleString()}` : '—'}</span></div>
                    <div><span className="text-gray-500">Currency:</span> <span className="ml-2">{contract.currency}</span></div>
                  </>
                )}
                {isExecutive && (
                  <div className="col-span-2 text-gray-400 text-xs italic">Financial details are not available for your role.</div>
                )}
              </div>
              {contract.document_url && (
                <>
                  <Separator className="my-4" />
                  <a href={contract.document_url} target="_blank" rel="noopener noreferrer" className="text-sm text-blue-600 flex items-center gap-1 hover:underline">
                    <FileText className="h-4 w-4" /> View Document
                  </a>
                </>
              )}
            </CardContent>
          </Card>

          {/* SOW Clauses - v2 placeholder */}
          <Card>
            <CardHeader>
              <CardTitle className="text-base flex items-center gap-2">
                SOW Clause Configuration
                <Badge variant="secondary">Coming in v2</Badge>
              </CardTitle>
              <CardDescription>
                Configure contract clauses, thresholds, notice periods, and cost impacts.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 flex gap-3">
                <Info className="h-5 w-5 text-blue-600 flex-shrink-0 mt-0.5" />
                <div>
                  <p className="text-sm text-blue-800 font-medium">This feature is under development</p>
                  <p className="text-sm text-blue-700 mt-1">
                    SOW clause management will be available in the next major release. In the meantime, you can document clause ideas and requirements in the notes below.
                  </p>
                  <textarea
                    className="mt-3 w-full border rounded-md p-2 text-sm min-h-[80px] bg-white"
                    placeholder="Document clause ideas or requirements here for v2 planning..."
                  />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <div>
          <Card>
            <CardHeader>
              <CardTitle className="text-base">Details</CardTitle>
            </CardHeader>
            <CardContent className="text-sm space-y-3">
              <div>
                <span className="text-gray-500">SOW Number</span>
                <p className="font-medium">{contract.sow_number}</p>
              </div>
              <div>
                <span className="text-gray-500">Access Level</span>
                <p className="font-medium capitalize">{contract.access_level}</p>
              </div>
              <div>
                <span className="text-gray-500">Created</span>
                <p className="font-medium">{format(new Date(contract.created_at), 'MMM d, yyyy')}</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}

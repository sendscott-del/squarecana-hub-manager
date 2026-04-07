'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { Hub } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { CardSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Building2, MapPin, Users, ExternalLink } from 'lucide-react'
import Link from 'next/link'

export default function HubsPage() {
  const [hubs, setHubs] = useState<Hub[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createClient()
  const { demoMode } = useAuth()

  useEffect(() => {
    const fetchHubs = async () => {
      const { data: hubData } = await supabase
        .from('sq_hubs')
        .select('*')
        .order('name')

      if (hubData) {
        setHubs(hubData.map((hub: Hub & { fte_count?: number }) => ({
          ...hub,
          headcount_count: hub.fte_count || 0,
        })))
      }
      setLoading(false)
    }
    fetchHubs()
  }, [demoMode])

  return (
    <div>
      <PageHeader
        title="Talent Hubs"
        description="Manage and view all global talent hub profiles"
      />

      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {Array.from({ length: 6 }).map((_, i) => <CardSkeleton key={i} />)}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {hubs.map(hub => (
            <Link key={hub.id} href={`/hubs/${hub.id}`}>
              <Card className="hover:shadow-md transition-shadow cursor-pointer h-full">
                <CardHeader className="pb-3">
                  <div className="flex items-start justify-between">
                    <CardTitle className="text-lg">{hub.name}</CardTitle>
                    <Badge variant={hub.hub_type === 'vendor' ? 'default' : 'secondary'}>
                      {hub.hub_type === 'vendor' ? 'Vendor' : 'Internal'}
                    </Badge>
                  </div>
                </CardHeader>
                <CardContent className="space-y-3">
                  <div className="flex items-center gap-2 text-sm text-gray-600">
                    <MapPin className="h-4 w-4" />
                    <span>{hub.location_city}, {hub.location_country}</span>
                  </div>
                  {hub.vendor_name && (
                    <div className="flex items-center gap-2 text-sm text-gray-600">
                      <Building2 className="h-4 w-4" />
                      <span>{hub.vendor_name}</span>
                    </div>
                  )}
                  <div className="flex items-center gap-2 text-sm text-gray-600">
                    <Users className="h-4 w-4" />
                    <span>{hub.headcount_count} active headcount</span>
                  </div>
                  <div className="flex items-center gap-1 text-sm text-[#0F2952] font-medium pt-2">
                    <span>View Profile</span>
                    <ExternalLink className="h-3 w-3" />
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}

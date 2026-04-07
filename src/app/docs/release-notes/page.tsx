'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { ReleaseNote } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { TableSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Tag, CheckCircle, Bug } from 'lucide-react'
import { format } from 'date-fns'
import Link from 'next/link'

export default function ReleaseNotesPage() {
  const [notes, setNotes] = useState<ReleaseNote[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase
      .from('sq_release_notes')
      .select('*')
      .order('release_date', { ascending: false })
      .then(({ data }) => {
        if (data) setNotes(data)
        setLoading(false)
      })
  }, [])

  return (
    <div>
      <PageHeader title="Documentation" description="Release notes and user guide" />

      <Tabs defaultValue="release-notes" className="mb-6">
        <TabsList>
          <TabsTrigger value="release-notes">Release Notes</TabsTrigger>
          <Link href="/docs/user-guide">
            <TabsTrigger value="user-guide">User Guide</TabsTrigger>
          </Link>
        </TabsList>
      </Tabs>

      {loading ? <TableSkeleton /> : (
        <div className="space-y-6">
          {notes.map(note => (
            <Card key={note.id}>
              <CardHeader>
                <div className="flex items-center gap-3">
                  <Badge variant="outline" className="bg-[#0F2952] text-white border-[#0F2952]">
                    <Tag className="h-3 w-3 mr-1" />v{note.version}
                  </Badge>
                  <span className="text-sm text-gray-500">{format(new Date(note.release_date), 'MMMM d, yyyy')}</span>
                </div>
              </CardHeader>
              <CardContent className="space-y-6">
                {note.features && (note.features as string[]).length > 0 && (
                  <div>
                    <h3 className="font-medium text-sm text-green-700 flex items-center gap-2 mb-3">
                      <CheckCircle className="h-4 w-4" />New Features
                    </h3>
                    <ul className="space-y-2">
                      {(note.features as string[]).map((feature, i) => (
                        <li key={i} className="text-sm text-gray-700 flex items-start gap-2">
                          <span className="text-green-500 mt-1">+</span>
                          <span>{feature}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
                {note.bug_fixes && (note.bug_fixes as string[]).length > 0 && (
                  <div>
                    <h3 className="font-medium text-sm text-orange-700 flex items-center gap-2 mb-3">
                      <Bug className="h-4 w-4" />Bug Fixes
                    </h3>
                    <ul className="space-y-2">
                      {(note.bug_fixes as string[]).map((fix, i) => (
                        <li key={i} className="text-sm text-gray-700 flex items-start gap-2">
                          <span className="text-orange-500 mt-1">~</span>
                          <span>{fix}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  )
}

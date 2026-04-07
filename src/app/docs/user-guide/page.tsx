'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { UserGuideSection } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { TableSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { ScrollArea } from '@/components/ui/scroll-area'
import Link from 'next/link'

export default function UserGuidePage() {
  const [sections, setSections] = useState<UserGuideSection[]>([])
  const [loading, setLoading] = useState(true)
  const [activeSection, setActiveSection] = useState('')
  const supabase = createClient()

  useEffect(() => {
    supabase
      .from('sq_user_guide_sections')
      .select('*')
      .order('section_order')
      .then(({ data }) => {
        if (data) {
          setSections(data)
          if (data.length > 0) setActiveSection(data[0].id)
        }
        setLoading(false)
      })
  }, [])

  // Simple markdown-like rendering
  const renderMarkdown = (text: string) => {
    return text
      .split('\n\n')
      .map((block, i) => {
        if (block.startsWith('## ')) {
          return <h2 key={i} className="text-lg font-semibold text-[#0F2952] mt-6 mb-3">{block.replace('## ', '')}</h2>
        }
        if (block.startsWith('### ')) {
          return <h3 key={i} className="text-base font-medium mt-4 mb-2">{block.replace('### ', '')}</h3>
        }
        if (block.startsWith('- ')) {
          const items = block.split('\n').filter(l => l.startsWith('- '))
          return (
            <ul key={i} className="list-disc list-inside space-y-1 my-2">
              {items.map((item, j) => (
                <li key={j} className="text-sm text-gray-700">{item.replace('- ', '')}</li>
              ))}
            </ul>
          )
        }
        if (block.startsWith('1. ') || block.startsWith('2. ')) {
          const items = block.split('\n').filter(l => /^\d+\.\s/.test(l))
          return (
            <ol key={i} className="list-decimal list-inside space-y-1 my-2">
              {items.map((item, j) => (
                <li key={j} className="text-sm text-gray-700">{item.replace(/^\d+\.\s/, '')}</li>
              ))}
            </ol>
          )
        }
        return <p key={i} className="text-sm text-gray-700 my-2">{block}</p>
      })
  }

  return (
    <div>
      <PageHeader title="Documentation" description="Release notes and user guide" />

      <Tabs defaultValue="user-guide" className="mb-6">
        <TabsList>
          <Link href="/docs/release-notes">
            <TabsTrigger value="release-notes">Release Notes</TabsTrigger>
          </Link>
          <TabsTrigger value="user-guide">User Guide</TabsTrigger>
        </TabsList>
      </Tabs>

      {loading ? <TableSkeleton /> : (
        <div className="flex gap-6">
          {/* Table of contents */}
          <div className="hidden lg:block w-64 flex-shrink-0">
            <Card className="sticky top-8">
              <CardHeader className="py-3">
                <CardTitle className="text-sm">Contents</CardTitle>
              </CardHeader>
              <CardContent className="py-0 pb-3">
                <ScrollArea className="h-[400px]">
                  <nav className="space-y-1">
                    {sections.map(section => (
                      <button
                        key={section.id}
                        onClick={() => setActiveSection(section.id)}
                        className={`w-full text-left px-3 py-2 rounded text-sm transition-colors ${
                          activeSection === section.id
                            ? 'bg-[#0F2952]/10 text-[#0F2952] font-medium'
                            : 'text-gray-600 hover:bg-gray-100'
                        }`}
                      >
                        {section.section_order}. {section.title}
                      </button>
                    ))}
                  </nav>
                </ScrollArea>
              </CardContent>
            </Card>
          </div>

          {/* Content */}
          <div className="flex-1 min-w-0">
            {/* Mobile section selector */}
            <div className="lg:hidden mb-4">
              <select
                className="w-full border rounded-md p-2 text-sm"
                value={activeSection}
                onChange={e => setActiveSection(e.target.value)}
              >
                {sections.map(s => (
                  <option key={s.id} value={s.id}>{s.section_order}. {s.title}</option>
                ))}
              </select>
            </div>

            {sections
              .filter(s => s.id === activeSection)
              .map(section => (
                <Card key={section.id}>
                  <CardHeader>
                    <CardTitle>{section.section_order}. {section.title}</CardTitle>
                  </CardHeader>
                  <CardContent className="prose prose-sm max-w-none">
                    {section.content_markdown ? renderMarkdown(section.content_markdown) : (
                      <p className="text-gray-500">No content yet.</p>
                    )}
                  </CardContent>
                </Card>
              ))
            }
          </div>
        </div>
      )}
    </div>
  )
}

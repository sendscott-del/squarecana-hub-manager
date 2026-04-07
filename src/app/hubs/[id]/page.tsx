'use client'

import { useEffect, useState } from 'react'
import { useParams } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { Hub, HubProfile } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { PageSkeleton } from '@/components/shared/loading-skeleton'
import { TiptapEditor } from '@/components/shared/tiptap-editor'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { ArrowLeft, Save, MapPin, Building2, Clock, Trash2, Plus } from 'lucide-react'
import { toast } from 'sonner'
import Link from 'next/link'
import { format } from 'date-fns'

const SECTIONS = [
  { key: 'overview', label: 'Overview' },
  { key: 'cost_summary', label: 'Cost Summary' },
  { key: 'talent_profile', label: 'Talent Profile' },
  { key: 'hr_processes', label: 'HR Processes' },
  { key: 'key_contacts', label: 'Key Contacts' },
  { key: 'notes', label: 'Notes' },
]

export default function HubDetailPage() {
  const { id } = useParams()
  const { profile: currentUser } = useAuth()
  const [hub, setHub] = useState<Hub | null>(null)
  const [profiles, setProfiles] = useState<Record<string, HubProfile>>({})
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [activeSection, setActiveSection] = useState('overview')
  const supabase = createClient()

  const canEdit = currentUser?.role === 'central_ops' ||
    (currentUser?.role === 'hub_leader' && currentUser?.hub_id === id)

  useEffect(() => {
    const fetchData = async () => {
      const [hubRes, profilesRes] = await Promise.all([
        supabase.from('sq_hubs').select('*').eq('id', id).single(),
        supabase.from('sq_hub_profiles').select('*, updater:sq_users!updated_by(full_name)').eq('hub_id', id),
      ])

      if (hubRes.data) setHub(hubRes.data)
      if (profilesRes.data) {
        const profileMap: Record<string, HubProfile> = {}
        profilesRes.data.forEach((p: HubProfile & { updater?: { full_name: string } }) => {
          profileMap[p.section_key] = {
            ...p,
            updater_name: (p as unknown as { updater?: { full_name: string } }).updater?.full_name || 'Unknown',
          }
        })
        setProfiles(profileMap)
      }
      setLoading(false)
    }
    fetchData()
  }, [id])

  const saveSection = async (sectionKey: string, content: Record<string, unknown>) => {
    setSaving(true)
    const existing = profiles[sectionKey]

    if (existing) {
      await supabase
        .from('sq_hub_profiles')
        .update({
          content_json: content,
          updated_by: currentUser?.id,
          updated_at: new Date().toISOString(),
        })
        .eq('id', existing.id)
    } else {
      await supabase
        .from('sq_hub_profiles')
        .insert({
          hub_id: id as string,
          section_key: sectionKey,
          content_json: content,
          updated_by: currentUser?.id,
        })
    }

    // Refetch
    const { data } = await supabase
      .from('sq_hub_profiles')
      .select('*, updater:sq_users!updated_by(full_name)')
      .eq('hub_id', id)
      .eq('section_key', sectionKey)
      .single()

    if (data) {
      setProfiles(prev => ({
        ...prev,
        [sectionKey]: {
          ...data,
          updater_name: (data as unknown as { updater?: { full_name: string } }).updater?.full_name || 'Unknown',
        },
      }))
    }

    setSaving(false)
    toast.success('Section saved successfully')
  }

  if (loading) return <PageSkeleton />
  if (!hub) return <div>Hub not found</div>

  const getContent = (key: string) => profiles[key]?.content_json || {}

  return (
    <div>
      <div className="mb-6">
        <Link href="/hubs" className="text-sm text-gray-500 hover:text-gray-700 flex items-center gap-1 mb-4">
          <ArrowLeft className="h-4 w-4" /> Back to Hubs
        </Link>
        <PageHeader title={hub.name}>
          <Badge variant={hub.hub_type === 'vendor' ? 'default' : 'secondary'}>
            {hub.hub_type === 'vendor' ? 'Vendor-Managed' : 'Internal'}
          </Badge>
        </PageHeader>
        <div className="flex flex-wrap items-center gap-4 text-sm text-gray-600">
          <span className="flex items-center gap-1"><MapPin className="h-4 w-4" />{hub.location_city}, {hub.location_country}</span>
          {hub.vendor_name && <span className="flex items-center gap-1"><Building2 className="h-4 w-4" />{hub.vendor_name}</span>}
        </div>
      </div>

      <Tabs value={activeSection} onValueChange={setActiveSection}>
        <TabsList className="mb-6 flex-wrap h-auto">
          {SECTIONS.map(s => (
            <TabsTrigger key={s.key} value={s.key}>{s.label}</TabsTrigger>
          ))}
        </TabsList>

        {/* Overview */}
        <TabsContent value="overview">
          <OverviewSection
            data={getContent('overview') as Record<string, string>}
            profile={profiles.overview}
            canEdit={canEdit}
            onSave={(data) => saveSection('overview', data)}
            saving={saving}
          />
        </TabsContent>

        {/* Cost Summary */}
        <TabsContent value="cost_summary">
          <CostSummarySection
            data={getContent('cost_summary') as { tiers?: { level: string; avg_cost: number; currency: string }[]; last_updated?: string }}
            profile={profiles.cost_summary}
            canEdit={canEdit}
            onSave={(data) => saveSection('cost_summary', data)}
            saving={saving}
          />
        </TabsContent>

        {/* Talent Profile */}
        <TabsContent value="talent_profile">
          <TalentProfileSection
            data={getContent('talent_profile') as Record<string, string>}
            profile={profiles.talent_profile}
            canEdit={canEdit}
            onSave={(data) => saveSection('talent_profile', data)}
            saving={saving}
          />
        </TabsContent>

        {/* HR Processes */}
        <TabsContent value="hr_processes">
          <HRProcessesSection
            data={getContent('hr_processes') as Record<string, string>}
            profile={profiles.hr_processes}
            canEdit={canEdit}
            onSave={(data) => saveSection('hr_processes', data)}
            saving={saving}
          />
        </TabsContent>

        {/* Key Contacts */}
        <TabsContent value="key_contacts">
          <KeyContactsSection
            data={(() => {
              const c = getContent('key_contacts') as unknown
              if (Array.isArray(c)) return c as { name: string; title: string; email: string; phone: string }[]
              if (c && typeof c === 'object' && 'contacts' in c) return (c as { contacts: { name: string; title: string; email: string; phone: string }[] }).contacts || []
              return []
            })()}
            profile={profiles.key_contacts}
            canEdit={canEdit}
            onSave={(contacts) => saveSection('key_contacts', { contacts })}
            saving={saving}
          />
        </TabsContent>

        {/* Notes */}
        <TabsContent value="notes">
          <NotesSection
            data={getContent('notes') as { content?: string }}
            profile={profiles.notes}
            canEdit={canEdit}
            onSave={(data) => saveSection('notes', data)}
            saving={saving}
          />
        </TabsContent>
      </Tabs>
    </div>
  )
}

function SectionMeta({ profile }: { profile?: HubProfile }) {
  if (!profile) return null
  return (
    <p className="text-xs text-gray-400 flex items-center gap-1 mt-4">
      <Clock className="h-3 w-3" />
      Last updated by {profile.updater_name} on {format(new Date(profile.updated_at), 'MMM d, yyyy')}
    </p>
  )
}

function OverviewSection({ data, profile, canEdit, onSave, saving }: {
  data: Record<string, string>; profile?: HubProfile; canEdit: boolean;
  onSave: (d: Record<string, string>) => void; saving: boolean
}) {
  const [form, setForm] = useState(data)
  useEffect(() => { setForm(data) }, [data])

  const fields = [
    { key: 'timezone', label: 'Timezone' },
    { key: 'hub_size', label: 'Hub Size' },
    { key: 'description', label: 'Description' },
  ]

  return (
    <Card>
      <CardHeader>
        <CardTitle>Overview</CardTitle>
        <CardDescription>General hub information and description</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {fields.map(f => (
          <div key={f.key} className="space-y-1">
            <Label>{f.label}</Label>
            {canEdit ? (
              f.key === 'description' ? (
                <textarea
                  className="w-full border rounded-md p-2 text-sm min-h-[80px]"
                  value={form[f.key] || ''}
                  onChange={e => setForm({ ...form, [f.key]: e.target.value })}
                />
              ) : (
                <Input
                  value={form[f.key] || ''}
                  onChange={e => setForm({ ...form, [f.key]: e.target.value })}
                />
              )
            ) : (
              <p className="text-sm text-gray-700">{form[f.key] || 'Not set'}</p>
            )}
          </div>
        ))}
        {canEdit && (
          <Button onClick={() => onSave(form)} disabled={saving} className="bg-[#0F2952]">
            <Save className="h-4 w-4 mr-2" />{saving ? 'Saving...' : 'Save Overview'}
          </Button>
        )}
        <SectionMeta profile={profile} />
      </CardContent>
    </Card>
  )
}

function CostSummarySection({ data, profile, canEdit, onSave, saving }: {
  data: { tiers?: { level: string; avg_cost: number; currency: string }[]; last_updated?: string };
  profile?: HubProfile; canEdit: boolean; onSave: (d: Record<string, unknown>) => void; saving: boolean
}) {
  const [tiers, setTiers] = useState(data.tiers || [
    { level: 'Junior', avg_cost: 0, currency: 'USD' },
    { level: 'Mid', avg_cost: 0, currency: 'USD' },
    { level: 'Senior', avg_cost: 0, currency: 'USD' },
    { level: 'Lead', avg_cost: 0, currency: 'USD' },
  ])
  useEffect(() => {
    if (data.tiers) setTiers(data.tiers)
  }, [data])

  return (
    <Card>
      <CardHeader>
        <CardTitle>Cost Summary</CardTitle>
        <CardDescription>Average monthly cost by role tier</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b">
                <th className="text-left py-2 font-medium">Role Tier</th>
                <th className="text-left py-2 font-medium">Avg Monthly Cost</th>
                <th className="text-left py-2 font-medium">Currency</th>
              </tr>
            </thead>
            <tbody>
              {tiers.map((tier, i) => (
                <tr key={tier.level} className="border-b">
                  <td className="py-2">{tier.level}</td>
                  <td className="py-2">
                    {canEdit ? (
                      <Input
                        type="number"
                        className="w-32"
                        value={tier.avg_cost}
                        onChange={e => {
                          const newTiers = [...tiers]
                          newTiers[i] = { ...tier, avg_cost: Number(e.target.value) }
                          setTiers(newTiers)
                        }}
                      />
                    ) : (
                      `$${tier.avg_cost.toLocaleString()}`
                    )}
                  </td>
                  <td className="py-2">{tier.currency}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        {canEdit && (
          <Button onClick={() => onSave({ tiers, last_updated: new Date().toISOString() })} disabled={saving} className="mt-4 bg-[#0F2952]">
            <Save className="h-4 w-4 mr-2" />{saving ? 'Saving...' : 'Save Cost Summary'}
          </Button>
        )}
        <SectionMeta profile={profile} />
      </CardContent>
    </Card>
  )
}

function TalentProfileSection({ data, profile, canEdit, onSave, saving }: {
  data: Record<string, string>; profile?: HubProfile; canEdit: boolean;
  onSave: (d: Record<string, string>) => void; saving: boolean
}) {
  const [form, setForm] = useState(data)
  useEffect(() => { setForm(data) }, [data])

  const fields = [
    { key: 'types_of_work', label: 'Types of Work' },
    { key: 'strengths', label: 'Strengths' },
    { key: 'weaknesses', label: 'Weaknesses' },
    { key: 'talent_market', label: 'Talent Market / Competition' },
  ]

  return (
    <Card>
      <CardHeader>
        <CardTitle>Talent Profile</CardTitle>
        <CardDescription>Capabilities, strengths, and market context</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        {fields.map(f => (
          <div key={f.key} className="space-y-2">
            <Label className="text-sm font-medium">{f.label}</Label>
            <TiptapEditor
              content={form[f.key] || ''}
              onChange={val => setForm({ ...form, [f.key]: val })}
              editable={canEdit}
              placeholder={`Enter ${f.label.toLowerCase()}...`}
            />
          </div>
        ))}
        {canEdit && (
          <Button onClick={() => onSave(form)} disabled={saving} className="bg-[#0F2952]">
            <Save className="h-4 w-4 mr-2" />{saving ? 'Saving...' : 'Save Talent Profile'}
          </Button>
        )}
        <SectionMeta profile={profile} />
      </CardContent>
    </Card>
  )
}

function HRProcessesSection({ data, profile, canEdit, onSave, saving }: {
  data: Record<string, string>; profile?: HubProfile; canEdit: boolean;
  onSave: (d: Record<string, string>) => void; saving: boolean
}) {
  const [form, setForm] = useState(data)
  const [tab, setTab] = useState('requisition')
  useEffect(() => { setForm(data) }, [data])

  const tabs = [
    { key: 'requisition', label: 'Opening a Requisition / Change Order' },
    { key: 'performance', label: 'Performance Management' },
    { key: 'offboarding', label: 'Offboarding & Notice Periods' },
  ]

  return (
    <Card>
      <CardHeader>
        <CardTitle>HR Processes</CardTitle>
        <CardDescription>Standard operating procedures</CardDescription>
      </CardHeader>
      <CardContent>
        <Tabs value={tab} onValueChange={setTab}>
          <TabsList className="mb-4">
            {tabs.map(t => (
              <TabsTrigger key={t.key} value={t.key} className="text-xs sm:text-sm">{t.label}</TabsTrigger>
            ))}
          </TabsList>
          {tabs.map(t => (
            <TabsContent key={t.key} value={t.key}>
              <TiptapEditor
                content={form[t.key] || ''}
                onChange={val => setForm({ ...form, [t.key]: val })}
                editable={canEdit}
                placeholder={`Document ${t.label.toLowerCase()} process...`}
              />
            </TabsContent>
          ))}
        </Tabs>
        {canEdit && (
          <Button onClick={() => onSave(form)} disabled={saving} className="mt-4 bg-[#0F2952]">
            <Save className="h-4 w-4 mr-2" />{saving ? 'Saving...' : 'Save HR Processes'}
          </Button>
        )}
        <SectionMeta profile={profile} />
      </CardContent>
    </Card>
  )
}

function KeyContactsSection({ data, profile, canEdit, onSave, saving }: {
  data: { name: string; title: string; email: string; phone: string }[];
  profile?: HubProfile; canEdit: boolean;
  onSave: (contacts: { name: string; title: string; email: string; phone: string }[]) => void; saving: boolean
}) {
  const [contacts, setContacts] = useState(data)
  useEffect(() => { setContacts(data) }, [data])

  const updateContact = (i: number, field: string, value: string) => {
    const updated = [...contacts]
    updated[i] = { ...updated[i], [field]: value }
    setContacts(updated)
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Key Contacts</CardTitle>
        <CardDescription>Primary contacts for this hub</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {contacts.length === 0 && !canEdit && (
          <p className="text-gray-500 text-sm">No contacts added yet.</p>
        )}
        {contacts.map((contact, i) => (
          <div key={i} className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 p-4 border rounded-lg">
            {['name', 'title', 'email', 'phone'].map(field => (
              <div key={field}>
                <Label className="text-xs capitalize">{field}</Label>
                {canEdit ? (
                  <Input
                    value={(contact as Record<string, string>)[field] || ''}
                    onChange={e => updateContact(i, field, e.target.value)}
                    className="mt-1"
                  />
                ) : (
                  <p className="text-sm mt-1">{(contact as Record<string, string>)[field]}</p>
                )}
              </div>
            ))}
            {canEdit && (
              <div className="flex items-end sm:col-span-2 lg:col-span-4">
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setContacts(contacts.filter((_, j) => j !== i))}
                  className="text-red-500"
                >
                  <Trash2 className="h-4 w-4 mr-1" /> Remove
                </Button>
              </div>
            )}
          </div>
        ))}
        {canEdit && (
          <div className="flex gap-2">
            <Button
              variant="outline"
              onClick={() => setContacts([...contacts, { name: '', title: '', email: '', phone: '' }])}
            >
              <Plus className="h-4 w-4 mr-1" /> Add Contact
            </Button>
            <Button onClick={() => onSave(contacts)} disabled={saving} className="bg-[#0F2952]">
              <Save className="h-4 w-4 mr-2" />{saving ? 'Saving...' : 'Save Contacts'}
            </Button>
          </div>
        )}
        <SectionMeta profile={profile} />
      </CardContent>
    </Card>
  )
}

function NotesSection({ data, profile, canEdit, onSave, saving }: {
  data: { content?: string }; profile?: HubProfile; canEdit: boolean;
  onSave: (d: { content: string }) => void; saving: boolean
}) {
  const [content, setContent] = useState(data.content || '')
  useEffect(() => { setContent(data.content || '') }, [data])

  return (
    <Card>
      <CardHeader>
        <CardTitle>Notes</CardTitle>
        <CardDescription>Free-form notes and additional information</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <TiptapEditor
          content={content}
          onChange={setContent}
          editable={canEdit}
          placeholder="Add notes about this hub..."
        />
        {canEdit && (
          <Button onClick={() => onSave({ content })} disabled={saving} className="bg-[#0F2952]">
            <Save className="h-4 w-4 mr-2" />{saving ? 'Saving...' : 'Save Notes'}
          </Button>
        )}
        <SectionMeta profile={profile} />
      </CardContent>
    </Card>
  )
}

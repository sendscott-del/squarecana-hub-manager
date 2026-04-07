'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useAuth } from '@/lib/auth-context'
import { AppUser, Hub } from '@/lib/types'
import { PageHeader } from '@/components/shared/page-header'
import { StatusBadge } from '@/components/shared/status-badge'
import { TableSkeleton } from '@/components/shared/loading-skeleton'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Switch } from '@/components/ui/switch'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { ROLE_LABELS } from '@/lib/constants'
import { AlertTriangle, Shield, Lock, CheckCircle, XCircle, Users, Building2 } from 'lucide-react'
import { toast } from 'sonner'

export default function SettingsPage() {
  const { profile: currentUser, demoMode, refreshProfile } = useAuth()
  const [users, setUsers] = useState<AppUser[]>([])
  const [hubs, setHubs] = useState<Hub[]>([])
  const [loading, setLoading] = useState(true)
  const [demoToggle, setDemoToggle] = useState(demoMode)
  const supabase = createClient()

  const isAdmin = currentUser?.is_admin

  useEffect(() => {
    if (!isAdmin) { setLoading(false); return }
    Promise.all([
      supabase.from('sq_users').select('*').order('created_at', { ascending: false }),
      supabase.from('sq_hubs').select('*').order('name'),
    ]).then(([userRes, hubRes]) => {
      if (userRes.data) setUsers(userRes.data)
      if (hubRes.data) setHubs(hubRes.data)
      setLoading(false)
    })
  }, [isAdmin])

  if (!isAdmin) {
    return (
      <div className="flex flex-col items-center justify-center py-20">
        <Lock className="h-16 w-16 text-gray-300 mb-4" />
        <h2 className="text-xl font-semibold text-gray-700 mb-2">Admin Access Required</h2>
        <p className="text-gray-500">Only administrators can access settings.</p>
      </div>
    )
  }

  const toggleDemoMode = async () => {
    const newValue = !demoToggle
    setDemoToggle(newValue)
    await supabase
      .from('sq_settings')
      .upsert({ key: 'demo_mode', value: String(newValue), updated_at: new Date().toISOString() }, { onConflict: 'key' })
    await refreshProfile()
    toast.success(`Demo mode ${newValue ? 'enabled' : 'disabled'}`)
  }

  const updateUser = async (userId: string, updates: Partial<AppUser>) => {
    const { error } = await supabase.from('sq_users').update(updates).eq('id', userId)
    if (error) {
      toast.error('Failed to update user')
      return
    }
    setUsers(users.map(u => u.id === userId ? { ...u, ...updates } : u))
    toast.success('User updated')
  }

  const toggleHub = async (hubId: string, isActive: boolean) => {
    await supabase.from('sq_hubs').update({ is_active: isActive }).eq('id', hubId)
    setHubs(hubs.map(h => h.id === hubId ? { ...h, is_active: isActive } : h))
    toast.success(`Hub ${isActive ? 'activated' : 'deactivated'}`)
  }

  return (
    <div>
      <PageHeader title="Settings" description="System configuration and user management" />

      <Tabs defaultValue="demo" className="space-y-6">
        <TabsList>
          <TabsTrigger value="demo">Demo Mode</TabsTrigger>
          <TabsTrigger value="users">User Management</TabsTrigger>
          <TabsTrigger value="hubs">Hub Management</TabsTrigger>
        </TabsList>

        <TabsContent value="demo">
          <Card className="max-w-lg">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <AlertTriangle className="h-5 w-5 text-amber-500" />
                Demo Mode
              </CardTitle>
              <CardDescription>
                When enabled, the app displays pre-seeded sample data. Real data is not affected.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="flex items-center justify-between">
                <div>
                  <Label className="text-base">Enable Demo Mode</Label>
                  <p className="text-sm text-gray-500 mt-1">
                    {demoToggle ? 'Currently showing demo data' : 'Currently showing real data'}
                  </p>
                </div>
                <Switch checked={demoToggle} onCheckedChange={toggleDemoMode} />
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="users">
          {loading ? <TableSkeleton /> : (
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="h-5 w-5" />
                  User Management
                </CardTitle>
                <CardDescription>Manage user accounts, roles, and hub assignments</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="overflow-x-auto">
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="border-b text-left">
                        <th className="py-3 px-2 font-medium">Name</th>
                        <th className="py-3 px-2 font-medium">Email</th>
                        <th className="py-3 px-2 font-medium">Status</th>
                        <th className="py-3 px-2 font-medium">Role</th>
                        <th className="py-3 px-2 font-medium">Hub</th>
                        <th className="py-3 px-2 font-medium">Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {users.map(user => (
                        <tr key={user.id} className="border-b">
                          <td className="py-3 px-2">
                            <div className="flex items-center gap-2">
                              {user.full_name || 'Unnamed'}
                              {user.is_admin && <Shield className="h-3 w-3 text-amber-500" />}
                            </div>
                          </td>
                          <td className="py-3 px-2 text-gray-500">{user.email}</td>
                          <td className="py-3 px-2"><StatusBadge status={user.status} /></td>
                          <td className="py-3 px-2">
                            <Select
                              value={user.role || ''}
                              onValueChange={v => updateUser(user.id, { role: v as AppUser['role'] })}
                            >
                              <SelectTrigger className="w-[160px] h-8">
                                <SelectValue placeholder="Assign role" />
                              </SelectTrigger>
                              <SelectContent>
                                {Object.entries(ROLE_LABELS).map(([key, label]) => (
                                  <SelectItem key={key} value={key}>{label}</SelectItem>
                                ))}
                              </SelectContent>
                            </Select>
                          </td>
                          <td className="py-3 px-2">
                            <Select
                              value={user.hub_id || 'none'}
                              onValueChange={v => updateUser(user.id, { hub_id: v === 'none' ? null : v })}
                            >
                              <SelectTrigger className="w-[160px] h-8">
                                <SelectValue placeholder="Assign hub" />
                              </SelectTrigger>
                              <SelectContent>
                                <SelectItem value="none">No hub</SelectItem>
                                {hubs.map(h => <SelectItem key={h.id} value={h.id}>{h.name}</SelectItem>)}
                              </SelectContent>
                            </Select>
                          </td>
                          <td className="py-3 px-2">
                            <div className="flex gap-1">
                              {user.status === 'pending' && (
                                <Button
                                  size="sm"
                                  className="h-7 bg-green-600 hover:bg-green-700"
                                  onClick={() => updateUser(user.id, { status: 'active' })}
                                >
                                  <CheckCircle className="h-3 w-3 mr-1" />Approve
                                </Button>
                              )}
                              {user.status === 'active' && user.id !== currentUser?.id && (
                                <Button
                                  size="sm"
                                  variant="destructive"
                                  className="h-7"
                                  onClick={() => updateUser(user.id, { status: 'inactive' })}
                                >
                                  <XCircle className="h-3 w-3 mr-1" />Deactivate
                                </Button>
                              )}
                              {user.status === 'inactive' && (
                                <Button
                                  size="sm"
                                  variant="outline"
                                  className="h-7"
                                  onClick={() => updateUser(user.id, { status: 'active' })}
                                >
                                  Reactivate
                                </Button>
                              )}
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="hubs">
          {loading ? <TableSkeleton /> : (
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Building2 className="h-5 w-5" />
                  Hub Management
                </CardTitle>
                <CardDescription>Activate or deactivate hubs (data is preserved)</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {hubs.map(hub => (
                    <div key={hub.id} className="flex items-center justify-between p-4 border rounded-lg">
                      <div>
                        <p className="font-medium">{hub.name}</p>
                        <p className="text-sm text-gray-500">
                          {hub.location_city}, {hub.location_country}
                          {hub.vendor_name && ` — ${hub.vendor_name}`}
                        </p>
                      </div>
                      <div className="flex items-center gap-3">
                        <StatusBadge status={hub.is_active ? 'active' : 'inactive'} />
                        <Switch
                          checked={hub.is_active}
                          onCheckedChange={(checked) => toggleHub(hub.id, checked)}
                        />
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}
        </TabsContent>
      </Tabs>
    </div>
  )
}

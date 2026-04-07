export const STATUS_COLORS: Record<string, string> = {
  draft: 'bg-gray-100 text-gray-700 border-gray-200',
  submitted: 'bg-blue-100 text-blue-700 border-blue-200',
  under_review: 'bg-yellow-100 text-yellow-700 border-yellow-200',
  approved: 'bg-green-100 text-green-700 border-green-200',
  rejected: 'bg-red-100 text-red-700 border-red-200',
  pending: 'bg-orange-100 text-orange-700 border-orange-200',
  active: 'bg-green-100 text-green-700 border-green-200',
  inactive: 'bg-gray-100 text-gray-700 border-gray-200',
  open: 'bg-blue-100 text-blue-700 border-blue-200',
  closed: 'bg-gray-100 text-gray-700 border-gray-200',
  in_review: 'bg-yellow-100 text-yellow-700 border-yellow-200',
  paid: 'bg-emerald-100 text-emerald-700 border-emerald-200',
  disputed: 'bg-red-100 text-red-700 border-red-200',
}

export const STATUS_LABELS: Record<string, string> = {
  draft: 'Draft',
  submitted: 'Submitted',
  under_review: 'Under Review',
  approved: 'Approved',
  rejected: 'Rejected',
  pending: 'Pending',
  active: 'Active',
  inactive: 'Inactive',
  open: 'Open',
  closed: 'Closed',
  in_review: 'In Review',
  paid: 'Paid',
  disputed: 'Disputed',
  functional_leader: 'Functional Leader',
  central_ops: 'Central Operations',
  hub_leader: 'Hub Leader',
  executive: 'Executive',
}

export const ROLE_LABELS: Record<string, string> = {
  functional_leader: 'Functional / Country Leader',
  central_ops: 'Central Operations',
  hub_leader: 'Hub Leader',
  executive: 'Executive',
}

export const NAV_ITEMS = [
  { label: 'Dashboard', href: '/dashboard', icon: 'LayoutDashboard', roles: ['executive', 'central_ops', 'functional_leader', 'hub_leader'] },
  { label: 'Hubs', href: '/hubs', icon: 'Building2', roles: ['executive', 'central_ops', 'functional_leader', 'hub_leader'] },
  { label: 'Change Orders', href: '/change-orders', icon: 'FileEdit', roles: ['executive', 'central_ops', 'functional_leader', 'hub_leader'] },
  { label: 'Contracts & SOW', href: '/contracts', icon: 'FileText', roles: ['executive', 'central_ops', 'functional_leader', 'hub_leader'] },
  { label: 'Invoices', href: '/invoices', icon: 'Receipt', roles: ['executive', 'central_ops', 'functional_leader', 'hub_leader'] },
  { label: 'Documentation', href: '/docs/release-notes', icon: 'BookOpen', roles: ['executive', 'central_ops', 'functional_leader', 'hub_leader'] },
  { label: 'Settings', href: '/settings', icon: 'Settings', adminOnly: true, roles: ['central_ops'] },
]

export type UserRole = 'functional_leader' | 'central_ops' | 'hub_leader' | 'executive'
export type UserStatus = 'pending' | 'active' | 'inactive'
export type HubType = 'vendor' | 'internal'
export type HeadcountStatus = 'active' | 'open' | 'closed'
export type ChangeOrderStatus = 'draft' | 'submitted' | 'under_review' | 'approved' | 'rejected'
export type ChangeType = 'add' | 'remove' | 'modify'
export type AccessLevel = 'restricted' | 'standard'
export type InvoiceStatus = 'pending' | 'in_review' | 'approved' | 'rejected' | 'paid'
export type ApprovalStatus = 'pending' | 'approved' | 'disputed'

export interface AppUser {
  id: string
  email: string
  full_name: string | null
  role: UserRole | null
  hub_id: string | null
  is_admin: boolean
  status: UserStatus
  created_at: string
}

export interface Hub {
  id: string
  name: string
  location_city: string | null
  location_country: string | null
  hub_type: HubType | null
  vendor_name: string | null
  is_active: boolean
  created_at: string
  headcount_count?: number
}

export interface HubProfile {
  id: string
  hub_id: string
  section_key: string
  content_json: Record<string, unknown> | null
  updated_by: string | null
  updated_at: string
  updater_name?: string
}

export interface Headcount {
  id: string
  hub_id: string
  employee_name: string | null
  role_title: string | null
  role_type: string | null
  department: string | null
  function_area: string | null
  country_leader_user_id: string | null
  status: HeadcountStatus
  start_date: string | null
  end_date: string | null
  cost_per_month: number | null
  notes: string | null
  created_at: string
  hub?: Hub
  country_leader?: AppUser
}

export interface ChangeOrder {
  id: string
  hub_id: string
  submitted_by_user_id: string | null
  title: string
  description: string | null
  change_type: ChangeType | null
  headcount_id: string | null
  status: ChangeOrderStatus
  reviewer_user_id: string | null
  review_notes: string | null
  submitted_at: string | null
  reviewed_at: string | null
  created_at: string
  hub?: Hub
  submitted_by?: AppUser
  reviewer?: AppUser
}

export interface Contract {
  id: string
  hub_id: string
  sow_number: string | null
  vendor_name: string | null
  start_date: string | null
  end_date: string | null
  total_value: number | null
  currency: string
  document_url: string | null
  access_level: AccessLevel
  created_by: string | null
  created_at: string
  hub?: Hub
}

export interface Invoice {
  id: string
  hub_id: string
  vendor_name: string | null
  invoice_number: string | null
  invoice_date: string | null
  due_date: string | null
  total_amount: number | null
  currency: string
  status: InvoiceStatus
  submitted_by: string | null
  created_at: string
  hub?: Hub
  line_items?: InvoiceLineItem[]
  approval_percentage?: number
}

export interface InvoiceLineItem {
  id: string
  invoice_id: string
  employee_name: string | null
  role_title: string | null
  days_worked: number | null
  rate: number | null
  amount: number | null
  approved_by_user_id: string | null
  approval_status: ApprovalStatus
  approval_note: string | null
  created_at: string
  approver?: AppUser
}

export interface ReleaseNote {
  id: string
  version: string
  release_date: string
  features: string[]
  bug_fixes: string[]
  created_at: string
}

export interface UserGuideSection {
  id: string
  section_order: number
  title: string
  content_markdown: string | null
  updated_at: string
}

export interface Setting {
  id: string
  key: string
  value: string | null
  updated_at: string
}

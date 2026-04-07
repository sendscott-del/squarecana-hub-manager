# Squarecana Talent Hub Manager

A full-stack enterprise application for managing global talent hubs, vendor contracts, headcount, change orders, and invoice approvals.

## Tech Stack

- **Framework**: Next.js 14 (App Router)
- **Database & Auth**: Supabase (PostgreSQL + Auth + Email)
- **Styling**: Tailwind CSS + shadcn/ui
- **Rich Text**: Tiptap editor
- **Charts**: Recharts
- **Deployment**: Vercel

## Features

- **Hub Profiles**: 6 structured sections (Overview, Cost Summary, Talent Profile, HR Processes, Key Contacts, Notes) with rich text editing
- **Executive Dashboard**: Summary cards, headcount bar/pie charts, filterable headcount table
- **Change Order Management**: Full workflow (Draft > Submitted > Under Review > Approved/Rejected)
- **Contracts & SOW**: Access-level controlled contracts with v2 clause placeholder
- **Invoice Approval**: Line-item approval workflow with functional leader assignments
- **Role-Based Access**: 4 roles (Functional Leader, Central Ops, Hub Leader, Executive)
- **Demo Mode**: Toggle between sample data and real data
- **Self-Registration**: Users register and await admin approval
- **Documentation**: Auto-updated release notes and user guide

## Setup

### 1. Clone and Install

```bash
git clone https://github.com/sendscott-del/squarecana-hub-manager.git
cd squarecana-hub-manager
npm install
```

### 2. Environment Variables

Create a `.env.local` file:

```env
NEXT_PUBLIC_SUPABASE_URL=your-supabase-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-supabase-service-role-key
```

### 3. Supabase Setup

1. Create a new Supabase project (or use an existing one)
2. Run the schema in the SQL Editor:
   - Open `supabase/schema.sql` and execute it in your Supabase SQL Editor
3. Run the seed data:
   - Open `supabase/seed.sql` and execute it in your Supabase SQL Editor
4. Enable email auth in Authentication > Providers

### 4. Run Locally

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

### 5. Deploy to Vercel

1. Push to GitHub
2. Import the project in Vercel
3. Add environment variables in Vercel project settings
4. Deploy

## Database

All tables use the `sq_` prefix to avoid conflicts with other apps sharing the same Supabase instance.

### Tables

| Table | Description |
|-------|-------------|
| `sq_settings` | App settings (demo mode, etc.) |
| `sq_users` | User profiles with roles and status |
| `sq_hubs` | Talent hub definitions |
| `sq_hub_profiles` | Hub profile sections (JSON content) |
| `sq_headcount` | Employee/position records |
| `sq_change_orders` | Headcount change requests |
| `sq_contracts` | Vendor contracts/SOWs |
| `sq_sow_clauses` | Contract clauses (v2 ready) |
| `sq_invoices` | Vendor invoices |
| `sq_invoice_line_items` | Per-person invoice line items |
| `sq_invoice_reminders` | Email reminder log |
| `sq_release_notes` | Release notes |
| `sq_user_guide_sections` | User guide content |

### User Roles

| Role | Access |
|------|--------|
| `functional_leader` | View hubs, submit change orders, approve assigned invoice line items |
| `central_ops` | Full edit access to all data, manage vendors |
| `hub_leader` | Manage their own hub, change orders, and invoices |
| `executive` | Read-only executive dashboard, no PII or cost details |

## Demo Mode

Toggle demo mode from Settings (admin only). When active, an orange banner appears and all data shown is pre-seeded sample data.

## Demo Users (seeded)

| Name | Role | Admin |
|------|------|-------|
| Maria Santos | Functional Leader | No |
| James Mitchell | Central Operations | Yes |
| Priya Sharma | Hub Leader | No |
| Robert Chen | Executive | No |

-- ============================================================
-- Squarecana Hub Manager v1.0.0 — Seed V2 Updates
-- Run this in the Supabase SQL Editor
-- Date: 2026-04-07
-- ============================================================

-- ============================================================
-- 1. RELEASE NOTES
-- ============================================================

DELETE FROM sq_release_notes;

INSERT INTO sq_release_notes (version, release_date, features, bug_fixes)
VALUES (
  'v1.0.0',
  '2026-04-07',
  '[
    "Hub profile management with 6 structured sections — overview, cost summary, talent profile, HR processes, key contacts, and notes",
    "Executive dashboard with headcount analytics, bar charts by hub, pie chart by role type, and department distribution",
    "Change order workflow supporting draft, submitted, under review, approved, and rejected statuses",
    "Contract and SOW management with standard and restricted access levels",
    "Invoice approval workflow with line-item level approvals and dispute tracking",
    "Three user roles — Executive (full access), Central Operations (view and edit), and Functional Leader (view and submit)",
    "Demo mode with comprehensive sample data across 6 global hubs",
    "Self-registration with admin approval workflow",
    "Release notes and user guide documentation",
    "SOW clause tracking with 6 seeded clauses across vendor contracts",
    "Invoice reminder system with notification logging",
    "Enriched hub profiles with geography-specific content for all 6 hubs"
  ]'::jsonb,
  '[]'::jsonb
);


-- ============================================================
-- 2. USER GUIDE SECTIONS
-- ============================================================

DELETE FROM sq_user_guide_sections;

-- Section 1: Getting Started
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'Getting Started',
  1,
  E'## Welcome to Squarecana Talent Hub Manager\n\nSquarecana Talent Hub Manager is your central platform for managing global talent hubs, tracking headcount, processing change orders, and overseeing vendor contracts and invoices. Whether you are an executive reviewing high-level analytics or a functional leader submitting staffing requests, this application provides the tools you need to stay informed and take action.\n\n## How to Register\n\nTo get started, visit the application login page and click the **Register** link. You will be asked to provide your full name, email address, and a password. Fill in all required fields and submit the form. Your account will be created immediately, but it will be in a **Pending** status until an administrator reviews and approves it.\n\n## Waiting for Approval\n\nAfter you register, an administrator will review your account. They will assign you one of three roles — Executive, Central Operations, or Functional Leader — based on your responsibilities. Until your account is approved and a role is assigned, you will not be able to access any features in the application. You will know your account is active when you can log in and see the navigation sidebar.\n\n## Navigating the Application\n\nOnce approved, you will see a sidebar on the left side of the screen with links to all major features: Dashboard, Hubs, Change Orders, Contracts, Invoices, Settings, Release Notes, and User Guide. Click any link to navigate to that section. The sidebar is always available so you can move between features quickly.\n\n## Demo Mode\n\nIf your administrator has enabled demo mode, you will see sample data throughout the application. This is useful for exploring features before real data is entered. An orange banner at the top of the page will indicate when demo mode is active. Your admin can toggle demo mode off at any time from the Settings page, and your real data will not be affected.',
  '2026-04-07'
);

-- Section 2: User Roles
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'User Roles',
  2,
  E'## Understanding Roles in Squarecana\n\nSquarecana Talent Hub Manager uses three roles to control what each user can see and do. Your role determines which pages you can access, whether you can edit data, and what actions are available to you. Roles are assigned by an administrator during the account approval process and can be changed later if your responsibilities change.\n\n## Executive\n\nThe Executive role provides full access to every feature in the application. Executives can view the dashboard with headcount analytics, edit hub profiles, create and approve change orders, manage contracts and invoices, and access all administrative settings. This role is intended for senior leaders who need complete visibility and control over talent hub operations.\n\n## Central Operations\n\nThe Central Operations role is designed for operations team members who manage day-to-day hub activities. Central Ops users can view all data across hubs, edit hub profiles, approve or reject change orders that have been submitted for review, manage contracts and invoices, and access the user management settings. This role has nearly the same capabilities as Executive and is the primary hands-on management role.\n\n## Functional Leader\n\nThe Functional Leader role is for team leads and managers who need visibility into hub data and the ability to request changes. Functional Leaders can view all data across every hub, submit change orders for review, and view contracts and invoices. However, they cannot edit hub profiles directly or approve change orders — those actions require an Executive or Central Operations role.\n\n## How Roles Are Assigned\n\nRole assignment is handled by an administrator through the **Settings > User Management** page. When a new user registers, their account is placed in a Pending state. An admin reviews the registration, selects the appropriate role, and approves the account. If your role needs to change, contact your Central Operations administrator.',
  '2026-04-07'
);

-- Section 3: Hub Profiles
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'Hub Profiles',
  3,
  E'## Viewing Your Hubs\n\nThe **Hubs** page displays all of your talent hubs as a card-based listing. Each card shows the hub''s name, location, type (captive or vendor-managed), the vendor name if applicable, and the current headcount. This gives you a quick overview of your entire global hub network at a glance. Click any hub card to open its full profile.\n\n## Hub Profile Tabs\n\nEach hub profile is organized into six tabs that cover different aspects of the hub:\n\n- **Overview** — Displays the hub''s location, timezone, hub size category, and a general description of the hub''s purpose and capabilities.\n- **Cost Summary** — Shows average monthly costs broken down by role tier: Junior, Mid, Senior, and Lead. This helps you compare cost structures across hubs.\n- **Talent Profile** — Describes the types of work the hub handles, its key strengths and weaknesses, and the level of talent market competition in that geography.\n- **HR Processes** — Documents how to open requisitions, how performance management works at the hub, and the offboarding procedures that apply.\n- **Key Contacts** — Lists the important people associated with the hub, including their names, titles, email addresses, and phone numbers.\n- **Notes** — A free-form area for any additional information, observations, or reminders about the hub.\n\n## Editing Hub Profiles\n\nUsers with the Executive or Central Operations role can edit any section of a hub profile. Simply navigate to the tab you want to update, make your changes, and save. Functional Leaders have read-only access to all hub profile information — they can view everything but cannot make changes.\n\n## Using Hub Data Effectively\n\nHub profiles are the foundation of the application. The information stored here feeds into the dashboard analytics, helps contextualize change orders, and provides the reference data needed for contract and invoice management. Keeping hub profiles accurate and up to date ensures that everyone in your organization is working with the best available information.',
  '2026-04-07'
);

-- Section 4: Executive Dashboard
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'Executive Dashboard',
  4,
  E'## Dashboard Overview\n\nThe Executive Dashboard is the first thing you see when you log in. It provides a high-level summary of your talent hub operations through a set of summary cards and interactive charts. The dashboard is designed to give executives and operations leaders a quick snapshot of headcount, staffing activity, and organizational distribution without needing to drill into individual hubs.\n\n## Summary Cards\n\nAt the top of the dashboard, four summary cards display key metrics: **Total Headcount** (the number of active employees across all hubs), **Open Positions** (roles that have been approved but not yet filled), **Active Hubs** (the number of hubs currently operating), and **Pending Change Orders** (staffing requests awaiting review). These numbers update automatically as data changes.\n\n## Charts and Visualizations\n\nBelow the summary cards, three charts provide visual breakdowns of your data:\n\n- **Headcount by Hub** — A bar chart showing active headcount and open positions for each hub. This makes it easy to compare hub sizes and see where open roles are concentrated.\n- **Role Type Distribution** — A pie chart that breaks down your workforce by role type, such as analysts, specialists, managers, and other categories. This helps you understand the composition of your talent pool.\n- **Department Distribution** — A bar chart showing headcount across departments including Operations, Finance, HR, Technology, and Customer Success.\n\n## Headcount Table\n\nAt the bottom of the dashboard, a filterable table lists individual headcount records. Each row shows the hub, employee name, role, role type, department, country leader, status, and start date. You can use the filters above the table to narrow results by hub, department, or role type, making it easy to find specific people or drill into particular segments of your workforce.\n\n## Tips for Using the Dashboard\n\nUse the dashboard as your starting point each day to check for new pending change orders and to monitor headcount trends. The filters on the headcount table are especially useful when preparing for staffing reviews or when you need to quickly answer questions about team composition in a specific hub or department.',
  '2026-04-07'
);

-- Section 5: Change Orders
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'Change Orders',
  5,
  E'## What Are Change Orders?\n\nChange orders are formal requests to add, remove, or modify headcount positions within your talent hubs. They provide a structured workflow so that staffing changes are proposed, reviewed, and either approved or rejected before taking effect. This ensures that all stakeholders have visibility into staffing decisions and that changes are properly documented.\n\n## Creating a Change Order\n\nAll roles can create change orders. Navigate to the **Change Orders** page and click the **New Change Order** button. You will need to select the hub the change applies to, enter a title describing the request, choose the type of change (add, remove, or modify), and provide a description with any relevant details. Once the form is complete, you can either **Save as Draft** to continue editing later, or **Submit for Review** to send it into the approval workflow immediately.\n\n## The Change Order Workflow\n\nChange orders move through a defined set of statuses:\n\n1. **Draft** — The change order has been created but not yet submitted. You can edit it freely at this stage.\n2. **Submitted** — The change order has been sent for review. It is now visible to reviewers.\n3. **Under Review** — A reviewer has picked up the change order and is evaluating it.\n4. **Approved** — The change order has been approved and the requested staffing changes will be applied.\n5. **Rejected** — The change order was not approved. The reviewer will include notes explaining why.\n\n## Reviewing Change Orders\n\nExecutive and Central Operations users can review submitted change orders. Open a submitted change order to see its details, then choose to approve or reject it. When approving or rejecting, you can add notes to explain your decision. These notes are visible to the person who submitted the request.\n\n## Filtering and Searching\n\nThe Change Orders page provides filters to help you find specific requests. You can filter by hub, status, or change type. This is useful when you have many change orders and need to focus on a particular hub or see only pending requests that need your attention.',
  '2026-04-07'
);

-- Section 6: Contracts & SOW
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'Contracts & SOW',
  6,
  E'## Managing Contracts\n\nThe **Contracts** page lists all vendor agreements associated with your talent hubs. Each contract entry shows the SOW number, start and end dates, total contract value, and the access level assigned to it. This centralized view makes it easy to track which agreements are active, which are expiring soon, and which vendors are associated with each hub.\n\n## Access Levels\n\nContracts have two access levels: **Standard** and **Restricted**. Standard access contracts are visible to all users regardless of their role. Restricted contracts are only visible to users with the Central Operations or Executive role. This allows sensitive agreements to be protected while still giving broader visibility to routine contracts.\n\n## Contract Details\n\nClick on any contract to view its full details. The detail view shows the complete date range, total value, currency, associated hub and vendor, and a link to the contract document if one has been uploaded. This is your single source of truth for each vendor agreement.\n\n## SOW Clause Configuration\n\nThe Contracts page includes a **SOW Clause Configuration** section. In the current version, this area shows a "Coming in v2" placeholder along with a notes field where you can document ideas for clause tracking. Future versions will expand this into a full clause management system.\n\n## Creating and Filtering Contracts\n\nExecutive and Central Operations users can create new contracts by clicking the **New Contract** button and filling in the required fields. Functional Leaders have read-only access to contracts. All users can use the filter controls to narrow the contract list by hub, vendor, or status (active, expired, or upcoming). This makes it straightforward to find the specific agreement you are looking for.',
  '2026-04-07'
);

-- Section 7: Invoice Approval
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'Invoice Approval',
  7,
  E'## How Invoices Work\n\nInvoices are created for vendor-managed hubs to track and approve payments for outsourced talent. In the demo data, invoices exist for Vendor C and Vendor G. Each invoice contains header information — the vendor name, invoice number, invoice date, due date, and total amount — along with individual line items for each person billed.\n\n## Invoice Line Items\n\nEach line item on an invoice represents one employee or contractor. The line item shows the employee name, their role, the number of days worked during the billing period, the daily rate, and the calculated amount. This level of detail allows reviewers to verify billing accuracy on a per-person basis before approving payment.\n\n## Approving Line Items as a Functional Leader\n\nFunctional Leaders will see a **My Approvals** tab on the Invoices page. This tab shows all invoice line items that have been assigned to you for review. For each line item, you can choose to **Approve** it (confirming the billing is correct) or **Dispute** it (flagging an issue). When disputing a line item, you should add a note explaining the problem so that the operations team can follow up.\n\n## Invoice Status Updates\n\nInvoice status updates automatically based on line item approvals. When all line items on an invoice have been approved, the invoice status changes to **Approved**. If any line items are disputed, the invoice remains in **In Review** status until the disputes are resolved. A progress bar on each invoice shows the percentage of line items that have been approved, giving you a quick visual indicator of where things stand.\n\n## Managing Invoices\n\nExecutive and Central Operations users have additional capabilities. They can create new invoices, mark approved invoices as paid, or reject invoices entirely. These users also have visibility into all line item approvals and disputes across the organization, not just their own assignments. This provides the oversight needed to manage the full invoice lifecycle from submission through payment.',
  '2026-04-07'
);

-- Section 8: Demo Mode
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'Demo Mode',
  8,
  E'## What Is Demo Mode?\n\nDemo mode is a built-in feature that populates the application with pre-seeded sample data across six global talent hubs. It is designed to help new users explore the application''s features and understand how everything works before real data is entered. Demo mode provides a safe, realistic environment for training and evaluation purposes.\n\n## How to Identify Demo Mode\n\nWhen demo mode is active, an orange banner appears at the top of every page with the message: **"Demo Mode Active — Showing sample data only."** This makes it clear that the data you are viewing is sample data, not production information. If you do not see this banner, the application is displaying real data.\n\n## What Demo Data Includes\n\nThe demo dataset is comprehensive. It includes realistic headcount records across all six hubs, sample change orders in various workflow stages, vendor contracts with different access levels and statuses, invoices with line items ready for approval, and fully populated hub profiles with geography-specific content. This gives you a complete picture of how the application functions in a real-world scenario.\n\n## Toggling Demo Mode\n\nDemo mode can be turned on or off from the **Settings** page by any user with admin access. Navigate to Settings and select the **Demo Mode** tab, then use the toggle to enable or disable it. The change takes effect immediately for all users across the application.\n\n## Data Safety\n\nYour real data is never affected by demo mode. When demo mode is active, the application simply filters to show only the sample dataset. When demo mode is turned off, your actual production data is displayed instead. You can switch between modes freely without any risk of data loss or corruption.',
  '2026-04-07'
);

-- Section 9: Settings & Administration
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'Settings & Administration',
  9,
  E'## Accessing Settings\n\nThe **Settings** page is available to admin users — specifically, Executive and Central Operations users who have the admin flag enabled on their account. Settings is where you manage application-wide configurations, user accounts, and hub availability. If you do not see the Settings link in your sidebar, contact your administrator to request access.\n\n## Demo Mode Tab\n\nThe Demo Mode tab provides a simple toggle to turn demo mode on or off for the entire application. When enabled, all users will see sample data throughout the app. When disabled, only real production data is displayed. This is useful for onboarding new team members or for demonstrating the application to stakeholders.\n\n## User Management Tab\n\nThe User Management tab displays a list of all registered users along with their current status and role. From this tab, administrators can:\n\n- **Approve pending registrations** — New users who have registered will appear with a "Pending" status. Click on a pending user to review their information, assign them a role (Executive, Central Operations, or Functional Leader), and approve their account.\n- **Assign hub associations** — Link users to specific hubs so they see relevant data for their responsibilities.\n- **Deactivate accounts** — If a user no longer needs access, you can deactivate their account. This prevents them from logging in but preserves their historical activity.\n\nNew users cannot access any part of the application until they have been approved and assigned a role. This ensures that only authorized personnel can view your talent hub data.\n\n## Hub Management Tab\n\nThe Hub Management tab allows administrators to activate or deactivate individual hubs. Deactivating a hub hides it from all views throughout the application — it will not appear on the dashboard, in hub listings, or in filter dropdowns. However, all data associated with a deactivated hub is preserved in the database and will reappear if the hub is reactivated. This is useful for temporarily removing hubs that are being wound down or restructured.',
  '2026-04-07'
);

-- Section 10: FAQ
INSERT INTO sq_user_guide_sections (title, section_order, content_markdown, updated_at)
VALUES (
  'FAQ',
  10,
  E'## Frequently Asked Questions\n\nThis section answers the most common questions about using Squarecana Talent Hub Manager. If your question is not covered here, reach out to your Central Operations administrator for assistance.\n\n### How do I get access to the application?\n\nVisit the login page and click the **Register** link. Fill in your name, email, and password, then submit the form. Your account will be created in a Pending state. An administrator will review your registration, assign you a role, and approve your account. Once approved, you can log in and access all features available to your role.\n\n### I can''t see certain data — what should I do?\n\nYour visibility within the application depends on the role assigned to your account. For example, Restricted contracts are only visible to Executive and Central Operations users. If you believe you should have access to data that you cannot see, contact your administrator to discuss whether a role change is appropriate.\n\n### How do I submit a change order?\n\nNavigate to the **Change Orders** page using the sidebar. Click the **New Change Order** button. Select the hub, enter a title and description, choose the change type, and either save it as a draft or submit it for review. Once submitted, it will enter the approval workflow and be reviewed by an Executive or Central Operations user.\n\n### What happens when a change order is approved?\n\nWhen an Executive or Central Operations user approves a change order, the requested headcount changes are applied to the relevant hub. The change order record is updated to Approved status with the reviewer''s notes, and the dashboard analytics will reflect the updated headcount.\n\n### How do I approve invoice line items?\n\nGo to the **Invoices** page and open the invoice that contains your assigned line items. You will see each line item listed with the employee name, role, days worked, rate, and amount. For each item, click **Approve** if the billing is correct, or **Dispute** if there is an issue. Add a note when disputing so the operations team understands the problem.\n\n### Who can edit hub profiles?\n\nOnly users with the **Executive** or **Central Operations** role can edit hub profiles. Functional Leaders have read-only access to all hub information. If you need a hub profile updated and you are a Functional Leader, submit a request to your Central Operations administrator.\n\n### How do I toggle demo mode?\n\nNavigate to **Settings** using the sidebar, then select the **Demo Mode** tab. Use the toggle switch to turn demo mode on or off. This change applies immediately to all users. Only users with admin access can modify this setting.\n\n### Who do I contact for help?\n\nFor any questions, issues, or access requests, contact your **Central Operations administrator**. They manage user accounts, hub configurations, and application settings, and can assist with any problems you encounter.',
  '2026-04-07'
);


-- ============================================================
-- 3. UPDATE INVOICE DATA
-- ============================================================

-- Assign functional leader to all invoice line items for "My Approvals" view
UPDATE sq_invoice_line_items
SET approved_by_user_id = '22222222-2222-2222-2222-222222222201'
WHERE invoice_id IN (
  '66666666-6666-6666-6666-666666660101',
  '66666666-6666-6666-6666-666666660201'
);

-- Set submitted_by to the central_ops user
UPDATE sq_invoices
SET submitted_by = '22222222-2222-2222-2222-222222222202';


-- ============================================================
-- 4. UPDATE DEMO DATA DATES TO BE RECENT (2025-2026 range)
-- ============================================================

-- Headcount start dates
UPDATE sq_headcount
SET start_date = start_date + interval '2 years'
WHERE start_date IS NOT NULL;

-- Change order dates
UPDATE sq_change_orders
SET created_at = created_at + interval '2 years',
    submitted_at = submitted_at + interval '2 years'
WHERE submitted_at IS NOT NULL;

UPDATE sq_change_orders
SET created_at = created_at + interval '2 years'
WHERE submitted_at IS NULL;

UPDATE sq_change_orders
SET reviewed_at = reviewed_at + interval '2 years'
WHERE reviewed_at IS NOT NULL;

-- Contract dates
UPDATE sq_contracts
SET start_date = start_date + interval '2 years',
    end_date = end_date + interval '2 years',
    created_at = created_at + interval '2 years';

-- Invoice dates
UPDATE sq_invoices
SET invoice_date = invoice_date + interval '2 years',
    due_date = due_date + interval '2 years',
    created_at = created_at + interval '2 years';

-- ============================================================
-- Rich Invoice Demo Data for Squarecana Hub Manager
-- Creates 3 months of invoices for both vendor hubs with
-- line items assigned to different functional leaders
-- ============================================================

-- First, create additional demo functional leaders to assign line items to
INSERT INTO auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, aud, role)
VALUES
  ('22222222-2222-2222-2222-222222222205', '00000000-0000-0000-0000-000000000000', 'david.park@example.com', crypt('demo1234', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"David Park"}', now(), now(), 'authenticated', 'authenticated'),
  ('22222222-2222-2222-2222-222222222206', '00000000-0000-0000-0000-000000000000', 'sarah.chen@example.com', crypt('demo1234', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Sarah Chen"}', now(), now(), 'authenticated', 'authenticated')
ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
VALUES
  ('22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222205', 'david.park@example.com', '{"sub":"22222222-2222-2222-2222-222222222205","email":"david.park@example.com"}', 'email', now(), now(), now()),
  ('22222222-2222-2222-2222-222222222206', '22222222-2222-2222-2222-222222222206', 'sarah.chen@example.com', '{"sub":"22222222-2222-2222-2222-222222222206","email":"sarah.chen@example.com"}', 'email', now(), now(), now())
ON CONFLICT DO NOTHING;

DELETE FROM sq_users WHERE id IN ('22222222-2222-2222-2222-222222222205', '22222222-2222-2222-2222-222222222206');

INSERT INTO sq_users (id, email, full_name, role, hub_id, is_admin, status) VALUES
  ('22222222-2222-2222-2222-222222222205', 'david.park@example.com', 'David Park', 'functional_leader', NULL, false, 'active'),
  ('22222222-2222-2222-2222-222222222206', 'sarah.chen@example.com', 'Sarah Chen', 'functional_leader', NULL, false, 'active');

-- Functional Leaders for assignment:
-- Maria Santos (user1): 22222222-2222-2222-2222-222222222201 — Operations & Customer Success
-- David Park (user5):   22222222-2222-2222-2222-222222222205 — Technology & Finance
-- Sarah Chen (user6):   22222222-2222-2222-2222-222222222206 — HR & Process

-- Delete existing invoices to replace with richer data
DELETE FROM sq_invoice_reminders;
DELETE FROM sq_invoice_line_items;
DELETE FROM sq_invoices;

-- ============================================================
-- VENDOR C (Bogota) — 3 monthly invoices
-- ============================================================

-- January 2026 — PAID
INSERT INTO sq_invoices (id, hub_id, vendor_name, invoice_number, invoice_date, due_date, total_amount, currency, status, submitted_by, created_at) VALUES
('66666666-6666-6666-6666-666666660301', '11111111-1111-1111-1111-111111111101', 'Vendor C', 'VC-2026-001', '2026-01-31', '2026-02-28', 47750.00, 'USD', 'paid', '22222222-2222-2222-2222-222222222202', '2026-02-01T00:00:00Z');

INSERT INTO sq_invoice_line_items (invoice_id, employee_name, role_title, days_worked, rate, amount, approved_by_user_id, approval_status, approval_note) VALUES
('66666666-6666-6666-6666-666666660301', 'Alejandro Gomez',     'Operations Analyst',          22, 160, 3520,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660301', 'Valentina Torres',    'Financial Analyst',           22, 250, 5500,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660301', 'Santiago Herrera',     'Team Lead',                  22, 400, 8800,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660301', 'Camila Restrepo',     'Data Analyst',                22, 240, 5280,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660301', 'Mateo Ramirez',       'Process Specialist',          22, 260, 5720,  '22222222-2222-2222-2222-222222222206', 'approved', NULL),
('66666666-6666-6666-6666-666666660301', 'Laura Jimenez',       'HR Coordinator',              22, 220, 4840,  '22222222-2222-2222-2222-222222222206', 'approved', NULL),
('66666666-6666-6666-6666-666666660301', 'Andres Castillo',     'QA Specialist',               20, 230, 4600,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660301', 'Carolina Vargas',     'Customer Success Specialist', 22, 210, 4620,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660301', 'Felipe Diaz',         'Business Analyst',            21, 260, 4870,  '22222222-2222-2222-2222-222222222205', 'approved', NULL);

-- February 2026 — APPROVED (all line items approved)
INSERT INTO sq_invoices (id, hub_id, vendor_name, invoice_number, invoice_date, due_date, total_amount, currency, status, submitted_by, created_at) VALUES
('66666666-6666-6666-6666-666666660302', '11111111-1111-1111-1111-111111111101', 'Vendor C', 'VC-2026-002', '2026-02-28', '2026-03-31', 46210.00, 'USD', 'approved', '22222222-2222-2222-2222-222222222202', '2026-03-01T00:00:00Z');

INSERT INTO sq_invoice_line_items (invoice_id, employee_name, role_title, days_worked, rate, amount, approved_by_user_id, approval_status, approval_note) VALUES
('66666666-6666-6666-6666-666666660302', 'Alejandro Gomez',     'Operations Analyst',          20, 160, 3200,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660302', 'Valentina Torres',    'Financial Analyst',           20, 250, 5000,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660302', 'Santiago Herrera',     'Team Lead',                  20, 400, 8000,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660302', 'Camila Restrepo',     'Data Analyst',                20, 240, 4800,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660302', 'Mateo Ramirez',       'Process Specialist',          20, 260, 5200,  '22222222-2222-2222-2222-222222222206', 'approved', NULL),
('66666666-6666-6666-6666-666666660302', 'Laura Jimenez',       'HR Coordinator',              19, 220, 4180,  '22222222-2222-2222-2222-222222222206', 'approved', NULL),
('66666666-6666-6666-6666-666666660302', 'Andres Castillo',     'QA Specialist',               20, 230, 4600,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660302', 'Carolina Vargas',     'Customer Success Specialist', 20, 210, 4200,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660302', 'Felipe Diaz',         'Business Analyst',            21, 260, 5460,  '22222222-2222-2222-2222-222222222205', 'approved', 'Rate increase from Feb effective'),
('66666666-6666-6666-6666-666666660302', 'Ana Maria Lopez',     'Operations Analyst',          10, 160, 1570,  '22222222-2222-2222-2222-222222222201', 'approved', 'New hire — started mid-month');

-- March 2026 — IN REVIEW (mix of approved, pending, disputed)
INSERT INTO sq_invoices (id, hub_id, vendor_name, invoice_number, invoice_date, due_date, total_amount, currency, status, submitted_by, created_at) VALUES
('66666666-6666-6666-6666-666666660303', '11111111-1111-1111-1111-111111111101', 'Vendor C', 'VC-2026-003', '2026-03-31', '2026-04-30', 52830.00, 'USD', 'in_review', '22222222-2222-2222-2222-222222222202', '2026-04-01T00:00:00Z');

INSERT INTO sq_invoice_line_items (invoice_id, employee_name, role_title, days_worked, rate, amount, approved_by_user_id, approval_status, approval_note) VALUES
('66666666-6666-6666-6666-666666660303', 'Alejandro Gomez',     'Operations Analyst',          23, 160, 3680,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660303', 'Valentina Torres',    'Financial Analyst',           23, 250, 5750,  '22222222-2222-2222-2222-222222222205', 'pending', NULL),
('66666666-6666-6666-6666-666666660303', 'Santiago Herrera',     'Team Lead',                  23, 400, 9200,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660303', 'Camila Restrepo',     'Data Analyst',                23, 240, 5520,  '22222222-2222-2222-2222-222222222205', 'pending', NULL),
('66666666-6666-6666-6666-666666660303', 'Mateo Ramirez',       'Process Specialist',          23, 260, 5980,  '22222222-2222-2222-2222-222222222206', 'approved', NULL),
('66666666-6666-6666-6666-666666660303', 'Laura Jimenez',       'HR Coordinator',              23, 220, 5060,  '22222222-2222-2222-2222-222222222206', 'pending', NULL),
('66666666-6666-6666-6666-666666660303', 'Andres Castillo',     'QA Specialist',               21, 230, 4830,  '22222222-2222-2222-2222-222222222201', 'disputed', 'Billed for 21 days but attendance records show 19. Disputed 2 days.'),
('66666666-6666-6666-6666-666666660303', 'Carolina Vargas',     'Customer Success Specialist', 23, 210, 4830,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660303', 'Felipe Diaz',         'Business Analyst',            22, 260, 5720,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660303', 'Ana Maria Lopez',     'Operations Analyst',          23, 160, 3680,  '22222222-2222-2222-2222-222222222201', 'pending', NULL);

-- ============================================================
-- VENDOR G (Bangalore) — 3 monthly invoices
-- ============================================================

-- January 2026 — PAID
INSERT INTO sq_invoices (id, hub_id, vendor_name, invoice_number, invoice_date, due_date, total_amount, currency, status, submitted_by, created_at) VALUES
('66666666-6666-6666-6666-666666660401', '11111111-1111-1111-1111-111111111102', 'Vendor G', 'VG-2026-001', '2026-01-31', '2026-02-28', 52270.00, 'USD', 'paid', '22222222-2222-2222-2222-222222222202', '2026-02-01T00:00:00Z');

INSERT INTO sq_invoice_line_items (invoice_id, employee_name, role_title, days_worked, rate, amount, approved_by_user_id, approval_status, approval_note) VALUES
('66666666-6666-6666-6666-666666660401', 'Arun Kumar',          'Software Developer',          22, 220, 4840,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Deepika Menon',       'QA Specialist',               22, 190, 4180,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Suresh Venkatesh',    'Team Lead',                   22, 380, 8360,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Lakshmi Iyer',        'Data Analyst',                22, 200, 4400,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Ravi Shankar',        'Senior Software Developer',   22, 340, 7480,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Meena Krishnan',      'Business Analyst',            22, 240, 5280,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Prasad Rao',          'Project Manager',             22, 310, 6820,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Kavitha Sundaram',    'Operations Analyst',          20, 150, 3000,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Ajay Pillai',         'Software Developer',          22, 220, 4840,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660401', 'Divya Natarajan',     'QA Specialist',               15, 200, 3070,  '22222222-2222-2222-2222-222222222205', 'approved', 'Partial month — medical leave');

-- February 2026 — APPROVED
INSERT INTO sq_invoices (id, hub_id, vendor_name, invoice_number, invoice_date, due_date, total_amount, currency, status, submitted_by, created_at) VALUES
('66666666-6666-6666-6666-666666660402', '11111111-1111-1111-1111-111111111102', 'Vendor G', 'VG-2026-002', '2026-02-28', '2026-03-31', 55690.00, 'USD', 'approved', '22222222-2222-2222-2222-222222222202', '2026-03-01T00:00:00Z');

INSERT INTO sq_invoice_line_items (invoice_id, employee_name, role_title, days_worked, rate, amount, approved_by_user_id, approval_status, approval_note) VALUES
('66666666-6666-6666-6666-666666660402', 'Arun Kumar',          'Software Developer',          20, 220, 4400,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Deepika Menon',       'QA Specialist',               20, 190, 3800,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Suresh Venkatesh',    'Team Lead',                   20, 380, 7600,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Lakshmi Iyer',        'Data Analyst',                20, 200, 4000,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Ravi Shankar',        'Senior Software Developer',   20, 340, 6800,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Meena Krishnan',      'Business Analyst',            20, 240, 4800,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Prasad Rao',          'Project Manager',             20, 310, 6200,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Kavitha Sundaram',    'Operations Analyst',          20, 150, 3000,  '22222222-2222-2222-2222-222222222201', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Ajay Pillai',         'Software Developer',          20, 220, 4400,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Divya Natarajan',     'QA Specialist',               20, 200, 4000,  '22222222-2222-2222-2222-222222222205', 'approved', NULL),
('66666666-6666-6666-6666-666666660402', 'Rohit Mehta',         'DevOps Engineer',             15, 280, 4200,  '22222222-2222-2222-2222-222222222205', 'approved', 'New hire — started Feb 10'),
('66666666-6666-6666-6666-666666660402', 'Priyanka Desai',      'Data Engineer',               10, 250, 2490,  '22222222-2222-2222-2222-222222222205', 'approved', 'New hire — started Feb 17');

-- March 2026 — PENDING (just submitted, no reviews yet)
INSERT INTO sq_invoices (id, hub_id, vendor_name, invoice_number, invoice_date, due_date, total_amount, currency, status, submitted_by, created_at) VALUES
('66666666-6666-6666-6666-666666660403', '11111111-1111-1111-1111-111111111102', 'Vendor G', 'VG-2026-003', '2026-03-31', '2026-04-30', 63420.00, 'USD', 'pending', '22222222-2222-2222-2222-222222222202', '2026-04-01T00:00:00Z');

INSERT INTO sq_invoice_line_items (invoice_id, employee_name, role_title, days_worked, rate, amount, approved_by_user_id, approval_status) VALUES
('66666666-6666-6666-6666-666666660403', 'Arun Kumar',          'Software Developer',          23, 220, 5060,  '22222222-2222-2222-2222-222222222205', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Deepika Menon',       'QA Specialist',               23, 190, 4370,  '22222222-2222-2222-2222-222222222205', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Suresh Venkatesh',    'Team Lead',                   23, 380, 8740,  '22222222-2222-2222-2222-222222222205', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Lakshmi Iyer',        'Data Analyst',                23, 200, 4600,  '22222222-2222-2222-2222-222222222205', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Ravi Shankar',        'Senior Software Developer',   23, 340, 7820,  '22222222-2222-2222-2222-222222222205', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Meena Krishnan',      'Business Analyst',            23, 240, 5520,  '22222222-2222-2222-2222-222222222201', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Prasad Rao',          'Project Manager',             23, 310, 7130,  '22222222-2222-2222-2222-222222222201', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Kavitha Sundaram',    'Operations Analyst',          21, 150, 3150,  '22222222-2222-2222-2222-222222222201', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Ajay Pillai',         'Software Developer',          23, 220, 5060,  '22222222-2222-2222-2222-222222222205', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Divya Natarajan',     'QA Specialist',               23, 200, 4600,  '22222222-2222-2222-2222-222222222205', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Rohit Mehta',         'DevOps Engineer',             23, 280, 6440,  '22222222-2222-2222-2222-222222222205', 'pending'),
('66666666-6666-6666-6666-666666660403', 'Priyanka Desai',      'Data Engineer',               20, 250, 4930,  '22222222-2222-2222-2222-222222222205', 'pending');

-- ============================================================
-- Invoice Reminders
-- ============================================================
INSERT INTO sq_invoice_reminders (invoice_id, sent_to_user_id, reminder_type, sent_at) VALUES
-- March Vendor C (in_review) — reminders sent to approvers with pending items
('66666666-6666-6666-6666-666666660303', '22222222-2222-2222-2222-222222222205', 'initial_notification', '2026-04-01T09:00:00Z'),
('66666666-6666-6666-6666-666666660303', '22222222-2222-2222-2222-222222222206', 'initial_notification', '2026-04-01T09:00:00Z'),
('66666666-6666-6666-6666-666666660303', '22222222-2222-2222-2222-222222222201', 'initial_notification', '2026-04-01T09:00:00Z'),
-- March Vendor G (pending) — initial notifications
('66666666-6666-6666-6666-666666660403', '22222222-2222-2222-2222-222222222205', 'initial_notification', '2026-04-01T09:00:00Z'),
('66666666-6666-6666-6666-666666660403', '22222222-2222-2222-2222-222222222201', 'initial_notification', '2026-04-01T09:00:00Z'),
-- Due date reminder for Vendor C March invoice
('66666666-6666-6666-6666-666666660303', '22222222-2222-2222-2222-222222222205', 'follow_up', '2026-04-07T09:00:00Z'),
('66666666-6666-6666-6666-666666660303', '22222222-2222-2222-2222-222222222206', 'follow_up', '2026-04-07T09:00:00Z');

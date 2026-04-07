-- =============================================================================
-- Squarecana Talent Hub Manager — Seed / Demo Data
-- =============================================================================
-- Run against a database that already has the sq_* schema in place.
-- All UUIDs use fixed, predictable patterns so they can be cross-referenced.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 1. Settings
-- ---------------------------------------------------------------------------
INSERT INTO sq_settings (key, value) VALUES
  ('demo_mode', 'true')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- ---------------------------------------------------------------------------
-- 2. Hubs
-- ---------------------------------------------------------------------------
INSERT INTO sq_hubs (id, name, city, country, region, hub_type, vendor_name, status, created_at) VALUES
  ('11111111-1111-1111-1111-111111111101', 'Bogota Hub',        'Bogota',       'Colombia',     'LATAM',  'vendor',   'Vendor C', 'active', '2021-06-15T00:00:00Z'),
  ('11111111-1111-1111-1111-111111111102', 'Bangalore Vendor Hub','Bangalore',  'India',        'APAC',   'vendor',   'Vendor G', 'active', '2022-03-01T00:00:00Z'),
  ('11111111-1111-1111-1111-111111111103', 'Bangalore Internal Hub','Bangalore','India',        'APAC',   'internal', NULL,       'active', '2022-01-10T00:00:00Z'),
  ('11111111-1111-1111-1111-111111111104', 'Baroda Hub',        'Baroda',       'India',        'APAC',   'internal', NULL,       'active', '2022-07-20T00:00:00Z'),
  ('11111111-1111-1111-1111-111111111105', 'Athens Hub',        'Athens',       'Greece',       'EMEA',   'internal', NULL,       'active', '2023-02-01T00:00:00Z'),
  ('11111111-1111-1111-1111-111111111106', 'South Africa Hub',  'Johannesburg', 'South Africa', 'EMEA',   'internal', NULL,       'active', '2023-05-15T00:00:00Z');

-- ---------------------------------------------------------------------------
-- 3. Demo Users
-- ---------------------------------------------------------------------------
INSERT INTO sq_users (id, email, full_name, role, hub_id, status, is_admin, created_at) VALUES
  ('22222222-2222-2222-2222-222222222201', 'maria.santos@example.com',   'Maria Santos',   'functional_leader', '11111111-1111-1111-1111-111111111101', 'active', false, '2023-01-10T00:00:00Z'),
  ('22222222-2222-2222-2222-222222222202', 'james.mitchell@example.com', 'James Mitchell', 'central_ops',       NULL,                                   'active', true,  '2023-01-05T00:00:00Z'),
  ('22222222-2222-2222-2222-222222222203', 'priya.sharma@example.com',   'Priya Sharma',   'hub_leader',        '11111111-1111-1111-1111-111111111103', 'active', false, '2023-02-15T00:00:00Z'),
  ('22222222-2222-2222-2222-222222222204', 'robert.chen@example.com',    'Robert Chen',    'executive',         NULL,                                   'active', false, '2023-01-02T00:00:00Z');

-- ---------------------------------------------------------------------------
-- 4. Hub Profiles — 6 sections per hub (36 rows)
-- ---------------------------------------------------------------------------

-- ---- Hub 1: Bogota, Colombia (Vendor C) ----
INSERT INTO sq_hub_profiles (hub_id, section_key, content_json, updated_by, updated_at) VALUES
('11111111-1111-1111-1111-111111111101', 'overview',
 '{"location":"Bogota, Colombia","type":"Vendor-Managed","vendor":"Vendor C","timezone":"UTC-5","hub_size":"45 FTEs","description":"Our Bogota hub serves as a primary nearshore delivery center for operations and finance functions. Vendor C manages day-to-day operations with strong English-language capabilities and a growing talent pipeline. The hub was established in 2021 and has scaled rapidly to support North American business hours."}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111101', 'cost_summary',
 '{"tiers":[{"level":"Junior","avg_cost":2500,"currency":"USD"},{"level":"Mid","avg_cost":4000,"currency":"USD"},{"level":"Senior","avg_cost":6000,"currency":"USD"},{"level":"Lead","avg_cost":8000,"currency":"USD"}],"last_updated":"2024-01-15"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111101', 'talent_profile',
 '{"types_of_work":"<p>Financial analysis, data entry, reconciliation, accounts payable/receivable, general ledger support, management reporting, and operational analytics.</p>","strengths":"<p>Strong English proficiency across all levels. Excellent cultural alignment with North American teams. Favorable time zone overlap for real-time collaboration. Growing pool of CPA and CFA candidates.</p>","weaknesses":"<p>Limited availability of niche technical skills such as advanced data engineering. Higher attrition in junior roles compared to India hubs. Salary expectations rising faster than other LATAM markets.</p>","talent_market":"<p>Bogota has a rapidly growing professional services market with strong university programs in business and finance. Competition from other multinational shared services centers is increasing, but Vendor C maintains competitive benefits packages.</p>"}',
 '22222222-2222-2222-2222-222222222201', '2024-10-20T00:00:00Z'),
('11111111-1111-1111-1111-111111111101', 'hr_processes',
 '{"requisition":"<p>Submit a change order through the Hub Manager portal. Vendor C will source and present candidates within 15 business days. Final approval rests with the functional leader.</p>","performance":"<p>Annual performance review cycle aligned to calendar year. Mid-year check-in in June. Vendor C delivers performance summaries; functional leaders provide input on ratings.</p>","offboarding":"<p>30-day notice period required per Colombian labor law. Vendor C handles all exit paperwork and knowledge transfer coordination. Equipment return managed locally.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-09-15T00:00:00Z'),
('11111111-1111-1111-1111-111111111101', 'key_contacts',
 '[{"name":"Carlos Rodriguez","title":"Hub Manager","email":"carlos.rodriguez@vendorc.com","phone":"+57 1 234 5678"},{"name":"Isabella Moreno","title":"HR Lead","email":"isabella.moreno@vendorc.com","phone":"+57 1 234 5679"},{"name":"Maria Santos","title":"Functional Leader","email":"maria.santos@example.com","phone":"+1 555 012 3456"}]',
 '22222222-2222-2222-2222-222222222201', '2024-11-10T00:00:00Z'),
('11111111-1111-1111-1111-111111111101', 'notes',
 '{"content":"<p>Hub established in June 2021 during initial offshoring wave. Expanded from 20 to 45 FTEs in 2023. Current SOW runs through December 2025. Vendor C has been responsive to scaling requests. Consider renegotiating rates at next contract renewal — market rates have shifted.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-05T00:00:00Z');

-- ---- Hub 2: Bangalore, India (Vendor G) ----
INSERT INTO sq_hub_profiles (hub_id, section_key, content_json, updated_by, updated_at) VALUES
('11111111-1111-1111-1111-111111111102', 'overview',
 '{"location":"Bangalore, India","type":"Vendor-Managed","vendor":"Vendor G","timezone":"UTC+5:30","hub_size":"55 FTEs","description":"The Bangalore vendor hub is our largest offshore delivery center, managed by Vendor G. It supports technology, operations, and analytics functions with a deep talent pool. Established in 2022, it has become a critical part of our global delivery model."}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111102', 'cost_summary',
 '{"tiers":[{"level":"Junior","avg_cost":2000,"currency":"USD"},{"level":"Mid","avg_cost":3500,"currency":"USD"},{"level":"Senior","avg_cost":5500,"currency":"USD"},{"level":"Lead","avg_cost":7500,"currency":"USD"}],"last_updated":"2024-02-10"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111102', 'talent_profile',
 '{"types_of_work":"<p>Software development, QA testing, data analytics, business intelligence, DevOps support, application maintenance, and technical project management.</p>","strengths":"<p>Deep technology talent pool with strong engineering fundamentals. Competitive cost structure. Vendor G has established training programs and a strong bench of pre-vetted candidates. Excellent scalability.</p>","weaknesses":"<p>Time zone gap with North America requires overlapping hours arrangements. High market competition for senior developers leading to attrition risk. Communication styles may require coaching for client-facing roles.</p>","talent_market":"<p>Bangalore remains India''s premier technology hub with over 1 million IT professionals. While costs are rising, the talent depth and quality remain unmatched in India. Vendor G maintains a strong employer brand locally.</p>"}',
 '22222222-2222-2222-2222-222222222203', '2024-10-25T00:00:00Z'),
('11111111-1111-1111-1111-111111111102', 'hr_processes',
 '{"requisition":"<p>Submit change order via Hub Manager. Vendor G sources candidates within 10 business days for standard roles, 20 days for specialized technical roles. Two rounds of interviews: technical screen and hiring manager round.</p>","performance":"<p>Quarterly performance check-ins with formal annual review in March. Vendor G uses a 5-point rating scale. Promotion cycles occur annually in April.</p>","offboarding":"<p>60-day notice period per Vendor G contract terms (exceeds statutory minimum). Knowledge transfer plan required for all departures. Background verification clearance needed before final settlement.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-09-20T00:00:00Z'),
('11111111-1111-1111-1111-111111111102', 'key_contacts',
 '[{"name":"Rajesh Nair","title":"Delivery Manager","email":"rajesh.nair@vendorg.com","phone":"+91 80 2345 6789"},{"name":"Ananya Desai","title":"HR Business Partner","email":"ananya.desai@vendorg.com","phone":"+91 80 2345 6790"},{"name":"Vikram Singh","title":"Technical Lead","email":"vikram.singh@vendorg.com","phone":"+91 80 2345 6791"}]',
 '22222222-2222-2222-2222-222222222203', '2024-11-10T00:00:00Z'),
('11111111-1111-1111-1111-111111111102', 'notes',
 '{"content":"<p>Hub launched in March 2022. Rapid growth from 15 to 55 FTEs within 18 months. Vendor G contract has restricted access provisions — only hub leaders and central ops can view financial details. Consider adding a second delivery manager as the team approaches 60 FTEs.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-08T00:00:00Z');

-- ---- Hub 3: Bangalore, India (Internal) ----
INSERT INTO sq_hub_profiles (hub_id, section_key, content_json, updated_by, updated_at) VALUES
('11111111-1111-1111-1111-111111111103', 'overview',
 '{"location":"Bangalore, India","type":"Internal","vendor":null,"timezone":"UTC+5:30","hub_size":"38 FTEs","description":"Our internal Bangalore hub houses directly employed team members focused on core business functions including finance, HR, and customer success. Established in January 2022, this hub operates from a co-working space with plans to move to a dedicated office in 2025."}',
 '22222222-2222-2222-2222-222222222203', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111103', 'cost_summary',
 '{"tiers":[{"level":"Junior","avg_cost":2000,"currency":"USD"},{"level":"Mid","avg_cost":3500,"currency":"USD"},{"level":"Senior","avg_cost":5500,"currency":"USD"},{"level":"Lead","avg_cost":7500,"currency":"USD"}],"last_updated":"2024-03-01"}',
 '22222222-2222-2222-2222-222222222203', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111103', 'talent_profile',
 '{"types_of_work":"<p>Financial planning and analysis, HR operations, payroll processing, customer success management, vendor management, and internal audit support.</p>","strengths":"<p>Direct employment model provides better retention and cultural integration. Team members participate in company-wide initiatives. Strong process orientation and documentation habits. Lower attrition than vendor-managed hubs.</p>","weaknesses":"<p>Higher total cost of employment when including benefits, office space, and equipment. Recruiting takes longer without vendor bench. Limited surge capacity for short-term projects.</p>","talent_market":"<p>Bangalore offers a strong talent pool for finance and operations roles. Competition with IT sector for top graduates means competitive compensation packages are essential. Internal employer brand is still developing in the local market.</p>"}',
 '22222222-2222-2222-2222-222222222203', '2024-10-18T00:00:00Z'),
('11111111-1111-1111-1111-111111111103', 'hr_processes',
 '{"requisition":"<p>Hiring manager submits requisition through internal HRIS. Recruiting team sources candidates with a 20-business-day target for shortlist. Standard interview process: phone screen, technical assessment, panel interview, and offer.</p>","performance":"<p>Semi-annual performance reviews in June and December. Continuous feedback encouraged through 1:1 meetings. Annual compensation review in January aligned with company-wide cycle.</p>","offboarding":"<p>90-day notice period for senior roles, 30 days for others per Indian labor regulations. Exit interviews conducted by HR. Equipment and access revocation on last working day.</p>"}',
 '22222222-2222-2222-2222-222222222203', '2024-09-10T00:00:00Z'),
('11111111-1111-1111-1111-111111111103', 'key_contacts',
 '[{"name":"Priya Sharma","title":"Hub Leader","email":"priya.sharma@example.com","phone":"+91 80 3456 7890"},{"name":"Amit Patel","title":"Finance Manager","email":"amit.patel@example.com","phone":"+91 80 3456 7891"},{"name":"Sneha Reddy","title":"HR Coordinator","email":"sneha.reddy@example.com","phone":"+91 80 3456 7892"}]',
 '22222222-2222-2222-2222-222222222203', '2024-11-12T00:00:00Z'),
('11111111-1111-1111-1111-111111111103', 'notes',
 '{"content":"<p>Hub has been stable with low attrition (under 10% annually). Office lease expires in March 2025 — facilities team is evaluating dedicated office options in Whitefield or Electronic City. Team engagement scores consistently above company average.</p>"}',
 '22222222-2222-2222-2222-222222222203', '2024-11-02T00:00:00Z');

-- ---- Hub 4: Baroda, India (Internal) ----
INSERT INTO sq_hub_profiles (hub_id, section_key, content_json, updated_by, updated_at) VALUES
('11111111-1111-1111-1111-111111111104', 'overview',
 '{"location":"Baroda (Vadodara), India","type":"Internal","vendor":null,"timezone":"UTC+5:30","hub_size":"30 FTEs","description":"The Baroda hub is a cost-optimized internal delivery center focused on back-office operations and data processing. Located in Gujarat, it benefits from lower costs compared to Bangalore while maintaining strong quality standards. Established in mid-2022."}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111104', 'cost_summary',
 '{"tiers":[{"level":"Junior","avg_cost":1800,"currency":"USD"},{"level":"Mid","avg_cost":3000,"currency":"USD"},{"level":"Senior","avg_cost":4500,"currency":"USD"},{"level":"Lead","avg_cost":6500,"currency":"USD"}],"last_updated":"2024-03-15"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111104', 'talent_profile',
 '{"types_of_work":"<p>Data entry and validation, document processing, accounts payable, invoice reconciliation, basic financial reporting, and administrative support.</p>","strengths":"<p>Significantly lower operating costs than Tier-1 Indian cities. Low attrition due to limited competition. Strong work ethic and willingness to work flexible hours. Stable workforce with long average tenure.</p>","weaknesses":"<p>Smaller talent pool limits ability to hire specialized roles. Fewer candidates with advanced English communication skills. Limited local infrastructure for technology-heavy roles.</p>","talent_market":"<p>Baroda is an emerging shared services destination with a growing number of universities producing business graduates. The market is less saturated than Bangalore or Hyderabad, offering better retention but a smaller candidate pool for senior roles.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-10-22T00:00:00Z'),
('11111111-1111-1111-1111-111111111104', 'hr_processes',
 '{"requisition":"<p>Requisitions submitted through internal HRIS with approval from hub leader and functional leader. Local recruiting team partners with placement agencies for junior roles. Senior roles may require Bangalore-based recruiting support.</p>","performance":"<p>Annual performance reviews in December. Goals set in January. Mid-year progress reviews are informal but documented. Training and development plans created for high-potential employees.</p>","offboarding":"<p>30-day notice period standard. Knowledge transfer checklist required. Local HR manages all statutory compliance including gratuity and provident fund settlements.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-09-18T00:00:00Z'),
('11111111-1111-1111-1111-111111111104', 'key_contacts',
 '[{"name":"Dhruv Mehta","title":"Hub Leader","email":"dhruv.mehta@example.com","phone":"+91 265 234 5678"},{"name":"Kavita Joshi","title":"Operations Manager","email":"kavita.joshi@example.com","phone":"+91 265 234 5679"}]',
 '22222222-2222-2222-2222-222222222202', '2024-11-08T00:00:00Z'),
('11111111-1111-1111-1111-111111111104', 'notes',
 '{"content":"<p>Hub started as a pilot with 10 FTEs in July 2022 and has grown steadily. Office space secured through 2026. Consider expanding into customer support functions given the favorable cost structure. Internet connectivity has been upgraded to redundant fiber links after Q2 2023 outage.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-10-30T00:00:00Z');

-- ---- Hub 5: Athens, Greece (Internal) ----
INSERT INTO sq_hub_profiles (hub_id, section_key, content_json, updated_by, updated_at) VALUES
('11111111-1111-1111-1111-111111111105', 'overview',
 '{"location":"Athens, Greece","type":"Internal","vendor":null,"timezone":"UTC+2","hub_size":"25 FTEs","description":"The Athens hub provides European-based delivery capabilities with strong multilingual talent. Focused on customer success, business analysis, and project management functions requiring EU time zone coverage. Established in early 2023."}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111105', 'cost_summary',
 '{"tiers":[{"level":"Junior","avg_cost":3000,"currency":"USD"},{"level":"Mid","avg_cost":4500,"currency":"USD"},{"level":"Senior","avg_cost":7000,"currency":"USD"},{"level":"Lead","avg_cost":9500,"currency":"USD"}],"last_updated":"2024-04-01"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111105', 'talent_profile',
 '{"types_of_work":"<p>Customer success management, business analysis, project management, quality assurance, process improvement, and European regulatory compliance support.</p>","strengths":"<p>Multilingual capabilities (Greek, English, French, German common). EU time zone alignment for European clients. Strong educational background — many candidates hold master''s degrees. Cultural affinity with Western European and North American teams.</p>","weaknesses":"<p>Higher costs than India or South Africa hubs. Smaller talent pool for highly specialized technical roles. Greek labor regulations add complexity to workforce management. Limited scalability compared to larger markets.</p>","talent_market":"<p>Athens has a well-educated workforce with high unemployment rates among young professionals, creating a favorable hiring environment. The tech and outsourcing sectors are growing, with government incentives attracting foreign investment. Salary expectations are moderate by EU standards.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-10-28T00:00:00Z'),
('11111111-1111-1111-1111-111111111105', 'hr_processes',
 '{"requisition":"<p>Requisitions processed through internal HRIS with approval chain. Local recruiting agency partnership for sourcing. Interview process includes language assessment for multilingual roles. Average time-to-fill is 25 business days.</p>","performance":"<p>Annual performance review aligned with company cycle. Greek labor law requires specific documentation for performance-related actions. Bonus structure tied to individual and team KPIs.</p>","offboarding":"<p>Notice period per Greek labor code based on tenure (1-6 months). Severance calculations follow statutory requirements. Legal counsel review required for all involuntary terminations.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-09-25T00:00:00Z'),
('11111111-1111-1111-1111-111111111105', 'key_contacts',
 '[{"name":"Elena Papadopoulos","title":"Hub Leader","email":"elena.papadopoulos@example.com","phone":"+30 21 0234 5678"},{"name":"Nikos Stavros","title":"Operations Lead","email":"nikos.stavros@example.com","phone":"+30 21 0234 5679"},{"name":"Anna Georgiou","title":"HR Manager","email":"anna.georgiou@example.com","phone":"+30 21 0234 5680"}]',
 '22222222-2222-2222-2222-222222222202', '2024-11-10T00:00:00Z'),
('11111111-1111-1111-1111-111111111105', 'notes',
 '{"content":"<p>Newest European hub, established February 2023. Currently in a serviced office with plans to evaluate a permanent lease in Q2 2025. Team has strong customer satisfaction scores. Exploring expansion into data analytics and BI functions given local university partnerships.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-03T00:00:00Z');

-- ---- Hub 6: Johannesburg, South Africa (Internal) ----
INSERT INTO sq_hub_profiles (hub_id, section_key, content_json, updated_by, updated_at) VALUES
('11111111-1111-1111-1111-111111111106', 'overview',
 '{"location":"Johannesburg, South Africa","type":"Internal","vendor":null,"timezone":"UTC+2","hub_size":"32 FTEs","description":"The Johannesburg hub provides operations and customer-facing functions with strong English proficiency and favorable time zone overlap with European operations. Established in May 2023, the hub benefits from South Africa''s growing BPO sector and government incentives for job creation."}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111106', 'cost_summary',
 '{"tiers":[{"level":"Junior","avg_cost":2200,"currency":"USD"},{"level":"Mid","avg_cost":3800,"currency":"USD"},{"level":"Senior","avg_cost":5800,"currency":"USD"},{"level":"Lead","avg_cost":7800,"currency":"USD"}],"last_updated":"2024-04-15"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-01T00:00:00Z'),
('11111111-1111-1111-1111-111111111106', 'talent_profile',
 '{"types_of_work":"<p>Customer success operations, technical support, financial operations, data analysis, process documentation, and quality assurance.</p>","strengths":"<p>Native English speakers with neutral accents — excellent for customer-facing roles. Strong affinity with UK and European business culture. Competitive cost structure with good value for mid-level talent. Government employment incentives reduce effective costs.</p>","weaknesses":"<p>Load shedding (power outages) requires UPS and generator investments. Security considerations for office locations. Skills gap in advanced technology roles. Infrastructure can be inconsistent outside major business districts.</p>","talent_market":"<p>Johannesburg has a large, educated workforce with high youth unemployment creating a favorable hiring environment. The BPO sector is a national priority with government support. Universities produce strong business and finance graduates. Competition from Cape Town for top talent is increasing.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-10-30T00:00:00Z'),
('11111111-1111-1111-1111-111111111106', 'hr_processes',
 '{"requisition":"<p>Requisitions submitted through HRIS with hub leader approval. Local recruiting team leverages job boards and university partnerships. BEE (Black Economic Empowerment) compliance considered in hiring decisions. Average time-to-fill is 20 business days.</p>","performance":"<p>Annual performance reviews in November. South African labor law (BCEA and LRA) governs performance management processes. Progressive discipline required with documented counseling before any termination.</p>","offboarding":"<p>Notice period per BCEA: 1 week during first 6 months, 2 weeks for 6-12 months, 4 weeks after 1 year. CCMA processes must be followed for any dismissals. Final pay includes accrued leave and any applicable severance.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-09-28T00:00:00Z'),
('11111111-1111-1111-1111-111111111106', 'key_contacts',
 '[{"name":"Thabo Molefe","title":"Hub Leader","email":"thabo.molefe@example.com","phone":"+27 11 234 5678"},{"name":"Zanele Dlamini","title":"HR Manager","email":"zanele.dlamini@example.com","phone":"+27 11 234 5679"},{"name":"Pieter van der Merwe","title":"Finance Lead","email":"pieter.vdm@example.com","phone":"+27 11 234 5680"}]',
 '22222222-2222-2222-2222-222222222202', '2024-11-10T00:00:00Z'),
('11111111-1111-1111-1111-111111111106', 'notes',
 '{"content":"<p>Hub opened May 2023 with initial focus on customer success. Load shedding mitigation plan in place with UPS systems and generator backup. Exploring Sandton City office relocation for better talent attraction. Team has shown strong performance metrics — customer satisfaction scores in top quartile across all hubs.</p>"}',
 '22222222-2222-2222-2222-222222222202', '2024-11-06T00:00:00Z');

-- ---------------------------------------------------------------------------
-- 5. Headcount  (~10-12 per hub, ~65 total)
-- ---------------------------------------------------------------------------

-- ---- Hub 1: Bogota, Colombia — 11 records ----
INSERT INTO sq_headcount (id, hub_id, employee_name, role_title, role_type, department, function_area, country_leader_user_id, status, cost_per_month, start_date, created_at) VALUES
('33333333-3333-3333-3333-333333010101', '11111111-1111-1111-1111-111111111101', 'Alejandro Gomez',     'Operations Analyst',        'Analyst',      'Operations',       'Ops Analytics',      '22222222-2222-2222-2222-222222222201', 'active', 2500,  '2022-03-15', '2022-03-15T00:00:00Z'),
('33333333-3333-3333-3333-333333010102', '11111111-1111-1111-1111-111111111101', 'Valentina Torres',    'Financial Analyst',         'Analyst',      'Finance',          'FP&A',               '22222222-2222-2222-2222-222222222201', 'active', 4000,  '2022-04-01', '2022-04-01T00:00:00Z'),
('33333333-3333-3333-3333-333333010103', '11111111-1111-1111-1111-111111111101', 'Santiago Herrera',     'Team Lead',                 'Lead',         'Operations',       'Ops Analytics',      '22222222-2222-2222-2222-222222222201', 'active', 8000,  '2022-02-01', '2022-02-01T00:00:00Z'),
('33333333-3333-3333-3333-333333010104', '11111111-1111-1111-1111-111111111101', 'Camila Restrepo',     'Data Analyst',              'Analyst',      'Operations',       'Data & Reporting',   '22222222-2222-2222-2222-222222222201', 'active', 3800,  '2022-06-01', '2022-06-01T00:00:00Z'),
('33333333-3333-3333-3333-333333010105', '11111111-1111-1111-1111-111111111101', 'Mateo Ramirez',       'Process Specialist',        'Specialist',   'Operations',       'Process Improvement', '22222222-2222-2222-2222-222222222201', 'active', 4200,  '2022-08-15', '2022-08-15T00:00:00Z'),
('33333333-3333-3333-3333-333333010106', '11111111-1111-1111-1111-111111111101', 'Laura Jimenez',       'HR Coordinator',            'Coordinator',  'HR',               'People Ops',         '22222222-2222-2222-2222-222222222201', 'active', 3500,  '2022-09-01', '2022-09-01T00:00:00Z'),
('33333333-3333-3333-3333-333333010107', '11111111-1111-1111-1111-111111111101', 'Andres Castillo',     'QA Specialist',             'Specialist',   'Operations',       'Quality',            '22222222-2222-2222-2222-222222222201', 'active', 3600,  '2023-01-10', '2023-01-10T00:00:00Z'),
('33333333-3333-3333-3333-333333010108', '11111111-1111-1111-1111-111111111101', 'Carolina Vargas',     'Customer Success Specialist','Specialist',  'Customer Success', 'Client Services',    '22222222-2222-2222-2222-222222222201', 'active', 3400,  '2023-03-01', '2023-03-01T00:00:00Z'),
('33333333-3333-3333-3333-333333010109', '11111111-1111-1111-1111-111111111101', NULL,                  'Senior Financial Analyst',  'Analyst',      'Finance',          'FP&A',               '22222222-2222-2222-2222-222222222201', 'open',   6000,  NULL,         '2024-10-01T00:00:00Z'),
('33333333-3333-3333-3333-333333010110', '11111111-1111-1111-1111-111111111101', NULL,                  'Operations Analyst',        'Analyst',      'Operations',       'Ops Analytics',      '22222222-2222-2222-2222-222222222201', 'open',   2500,  NULL,         '2024-10-15T00:00:00Z'),
('33333333-3333-3333-3333-333333010111', '11111111-1111-1111-1111-111111111101', 'Felipe Diaz',         'Business Analyst',          'Analyst',      'Operations',       'Business Analysis',  '22222222-2222-2222-2222-222222222201', 'active', 4200,  '2023-06-01', '2023-06-01T00:00:00Z');

-- ---- Hub 2: Bangalore, India (Vendor G) — 12 records ----
INSERT INTO sq_headcount (id, hub_id, employee_name, role_title, role_type, department, function_area, country_leader_user_id, status, cost_per_month, start_date, created_at) VALUES
('33333333-3333-3333-3333-333333020101', '11111111-1111-1111-1111-111111111102', 'Arun Kumar',          'Software Developer',        'Developer',    'Technology',       'Engineering',        '22222222-2222-2222-2222-222222222201', 'active', 3500,  '2022-04-01', '2022-04-01T00:00:00Z'),
('33333333-3333-3333-3333-333333020102', '11111111-1111-1111-1111-111111111102', 'Deepika Menon',       'QA Specialist',             'Specialist',   'Technology',       'Quality Engineering','22222222-2222-2222-2222-222222222201', 'active', 3000,  '2022-04-15', '2022-04-15T00:00:00Z'),
('33333333-3333-3333-3333-333333020103', '11111111-1111-1111-1111-111111111102', 'Suresh Venkatesh',    'Team Lead',                 'Lead',         'Technology',       'Engineering',        '22222222-2222-2222-2222-222222222201', 'active', 7500,  '2022-03-15', '2022-03-15T00:00:00Z'),
('33333333-3333-3333-3333-333333020104', '11111111-1111-1111-1111-111111111102', 'Lakshmi Iyer',        'Data Analyst',              'Analyst',      'Operations',       'Data & Analytics',   '22222222-2222-2222-2222-222222222201', 'active', 3200,  '2022-06-01', '2022-06-01T00:00:00Z'),
('33333333-3333-3333-3333-333333020105', '11111111-1111-1111-1111-111111111102', 'Ravi Shankar',        'Software Developer',        'Developer',    'Technology',       'Engineering',        '22222222-2222-2222-2222-222222222201', 'active', 5500,  '2022-07-01', '2022-07-01T00:00:00Z'),
('33333333-3333-3333-3333-333333020106', '11111111-1111-1111-1111-111111111102', 'Meena Krishnan',      'Business Analyst',          'Analyst',      'Operations',       'Business Analysis',  '22222222-2222-2222-2222-222222222201', 'active', 3800,  '2022-09-01', '2022-09-01T00:00:00Z'),
('33333333-3333-3333-3333-333333020107', '11111111-1111-1111-1111-111111111102', 'Prasad Rao',          'Project Manager',           'Manager',      'Technology',       'PMO',                '22222222-2222-2222-2222-222222222201', 'active', 5000,  '2023-01-15', '2023-01-15T00:00:00Z'),
('33333333-3333-3333-3333-333333020108', '11111111-1111-1111-1111-111111111102', 'Kavitha Sundaram',    'Operations Analyst',        'Analyst',      'Operations',       'Ops Analytics',      '22222222-2222-2222-2222-222222222201', 'active', 2000,  '2023-03-01', '2023-03-01T00:00:00Z'),
('33333333-3333-3333-3333-333333020109', '11111111-1111-1111-1111-111111111102', 'Ajay Pillai',         'Software Developer',        'Developer',    'Technology',       'Engineering',        '22222222-2222-2222-2222-222222222201', 'active', 3500,  '2023-05-01', '2023-05-01T00:00:00Z'),
('33333333-3333-3333-3333-333333020110', '11111111-1111-1111-1111-111111111102', NULL,                  'Senior Software Developer', 'Developer',    'Technology',       'Engineering',        '22222222-2222-2222-2222-222222222201', 'open',   5500,  NULL,         '2024-09-01T00:00:00Z'),
('33333333-3333-3333-3333-333333020111', '11111111-1111-1111-1111-111111111102', NULL,                  'Data Analyst',              'Analyst',      'Operations',       'Data & Analytics',   '22222222-2222-2222-2222-222222222201', 'open',   2000,  NULL,         '2024-10-01T00:00:00Z'),
('33333333-3333-3333-3333-333333020112', '11111111-1111-1111-1111-111111111102', 'Divya Natarajan',     'QA Specialist',             'Specialist',   'Technology',       'Quality Engineering','22222222-2222-2222-2222-222222222201', 'active', 3200,  '2023-08-01', '2023-08-01T00:00:00Z');

-- ---- Hub 3: Bangalore, India (Internal) — 11 records ----
INSERT INTO sq_headcount (id, hub_id, employee_name, role_title, role_type, department, function_area, country_leader_user_id, status, cost_per_month, start_date, created_at) VALUES
('33333333-3333-3333-3333-333333030101', '11111111-1111-1111-1111-111111111103', 'Rohit Sharma',        'Financial Analyst',         'Analyst',      'Finance',          'FP&A',               '22222222-2222-2222-2222-222222222203', 'active', 3500,  '2022-02-01', '2022-02-01T00:00:00Z'),
('33333333-3333-3333-3333-333333030102', '11111111-1111-1111-1111-111111111103', 'Neha Gupta',          'HR Coordinator',            'Coordinator',  'HR',               'People Ops',         '22222222-2222-2222-2222-222222222203', 'active', 3000,  '2022-02-15', '2022-02-15T00:00:00Z'),
('33333333-3333-3333-3333-333333030103', '11111111-1111-1111-1111-111111111103', 'Vikram Choudhury',    'Team Lead',                 'Lead',         'Finance',          'FP&A',               '22222222-2222-2222-2222-222222222203', 'active', 7500,  '2022-01-15', '2022-01-15T00:00:00Z'),
('33333333-3333-3333-3333-333333030104', '11111111-1111-1111-1111-111111111103', 'Pooja Srinivasan',    'Customer Success Specialist','Specialist',  'Customer Success', 'Client Services',    '22222222-2222-2222-2222-222222222203', 'active', 3200,  '2022-05-01', '2022-05-01T00:00:00Z'),
('33333333-3333-3333-3333-333333030105', '11111111-1111-1111-1111-111111111103', 'Karthik Bhat',        'Operations Analyst',        'Analyst',      'Operations',       'Ops Analytics',      '22222222-2222-2222-2222-222222222203', 'active', 2000,  '2022-07-01', '2022-07-01T00:00:00Z'),
('33333333-3333-3333-3333-333333030106', '11111111-1111-1111-1111-111111111103', 'Anita Rao',           'Process Specialist',        'Specialist',   'Operations',       'Process Improvement', '22222222-2222-2222-2222-222222222203', 'active', 3800,  '2022-09-01', '2022-09-01T00:00:00Z'),
('33333333-3333-3333-3333-333333030107', '11111111-1111-1111-1111-111111111103', 'Sanjay Mukherjee',    'Data Analyst',              'Analyst',      'Operations',       'Data & Reporting',   '22222222-2222-2222-2222-222222222203', 'active', 3500,  '2023-01-10', '2023-01-10T00:00:00Z'),
('33333333-3333-3333-3333-333333030108', '11111111-1111-1111-1111-111111111103', 'Swati Verma',         'Financial Analyst',         'Analyst',      'Finance',          'Accounting',         '22222222-2222-2222-2222-222222222203', 'active', 3200,  '2023-04-01', '2023-04-01T00:00:00Z'),
('33333333-3333-3333-3333-333333030109', '11111111-1111-1111-1111-111111111103', NULL,                  'Senior Financial Analyst',  'Analyst',      'Finance',          'FP&A',               '22222222-2222-2222-2222-222222222203', 'open',   5500,  NULL,         '2024-09-15T00:00:00Z'),
('33333333-3333-3333-3333-333333030110', '11111111-1111-1111-1111-111111111103', NULL,                  'Customer Success Specialist','Specialist',  'Customer Success', 'Client Services',    '22222222-2222-2222-2222-222222222203', 'open',   3200,  NULL,         '2024-10-20T00:00:00Z'),
('33333333-3333-3333-3333-333333030111', '11111111-1111-1111-1111-111111111103', 'Megha Jain',          'Business Analyst',          'Analyst',      'Operations',       'Business Analysis',  '22222222-2222-2222-2222-222222222203', 'active', 3800,  '2023-07-01', '2023-07-01T00:00:00Z');

-- ---- Hub 4: Baroda, India (Internal) — 10 records ----
INSERT INTO sq_headcount (id, hub_id, employee_name, role_title, role_type, department, function_area, country_leader_user_id, status, cost_per_month, start_date, created_at) VALUES
('33333333-3333-3333-3333-333333040101', '11111111-1111-1111-1111-111111111104', 'Harsh Patel',         'Operations Analyst',        'Analyst',      'Operations',       'Data Processing',    '22222222-2222-2222-2222-222222222201', 'active', 1800,  '2022-08-01', '2022-08-01T00:00:00Z'),
('33333333-3333-3333-3333-333333040102', '11111111-1111-1111-1111-111111111104', 'Ritu Desai',          'Data Analyst',              'Analyst',      'Operations',       'Data & Reporting',   '22222222-2222-2222-2222-222222222201', 'active', 3000,  '2022-08-15', '2022-08-15T00:00:00Z'),
('33333333-3333-3333-3333-333333040103', '11111111-1111-1111-1111-111111111104', 'Manish Shah',         'Team Lead',                 'Lead',         'Operations',       'Data Processing',    '22222222-2222-2222-2222-222222222201', 'active', 6500,  '2022-07-20', '2022-07-20T00:00:00Z'),
('33333333-3333-3333-3333-333333040104', '11111111-1111-1111-1111-111111111104', 'Jaya Trivedi',        'Financial Analyst',         'Analyst',      'Finance',          'Accounts Payable',   '22222222-2222-2222-2222-222222222201', 'active', 2800,  '2022-10-01', '2022-10-01T00:00:00Z'),
('33333333-3333-3333-3333-333333040105', '11111111-1111-1111-1111-111111111104', 'Yash Bhatt',          'Process Specialist',        'Specialist',   'Operations',       'Process Improvement', '22222222-2222-2222-2222-222222222201', 'active', 3200,  '2023-01-15', '2023-01-15T00:00:00Z'),
('33333333-3333-3333-3333-333333040106', '11111111-1111-1111-1111-111111111104', 'Nisha Pandya',        'Operations Analyst',        'Analyst',      'Operations',       'Data Processing',    '22222222-2222-2222-2222-222222222201', 'active', 1800,  '2023-03-01', '2023-03-01T00:00:00Z'),
('33333333-3333-3333-3333-333333040107', '11111111-1111-1111-1111-111111111104', 'Chirag Mehta',        'QA Specialist',             'Specialist',   'Operations',       'Quality',            '22222222-2222-2222-2222-222222222201', 'active', 2800,  '2023-06-01', '2023-06-01T00:00:00Z'),
('33333333-3333-3333-3333-333333040108', '11111111-1111-1111-1111-111111111104', NULL,                  'Financial Analyst',         'Analyst',      'Finance',          'Accounts Payable',   '22222222-2222-2222-2222-222222222201', 'open',   2800,  NULL,         '2024-10-01T00:00:00Z'),
('33333333-3333-3333-3333-333333040109', '11111111-1111-1111-1111-111111111104', NULL,                  'Operations Analyst',        'Analyst',      'Operations',       'Data Processing',    '22222222-2222-2222-2222-222222222201', 'open',   1800,  NULL,         '2024-11-01T00:00:00Z'),
('33333333-3333-3333-3333-333333040110', '11111111-1111-1111-1111-111111111104', 'Prachi Soni',         'HR Coordinator',            'Coordinator',  'HR',               'People Ops',         '22222222-2222-2222-2222-222222222201', 'active', 2600,  '2023-09-01', '2023-09-01T00:00:00Z');

-- ---- Hub 5: Athens, Greece (Internal) — 10 records ----
INSERT INTO sq_headcount (id, hub_id, employee_name, role_title, role_type, department, function_area, country_leader_user_id, status, cost_per_month, start_date, created_at) VALUES
('33333333-3333-3333-3333-333333050101', '11111111-1111-1111-1111-111111111105', 'Dimitris Papadopoulos','Project Manager',           'Manager',      'Operations',       'PMO',                '22222222-2222-2222-2222-222222222201', 'active', 7000,  '2023-03-01', '2023-03-01T00:00:00Z'),
('33333333-3333-3333-3333-333333050102', '11111111-1111-1111-1111-111111111105', 'Sofia Nikolaou',      'Customer Success Specialist','Specialist',  'Customer Success', 'Client Services',    '22222222-2222-2222-2222-222222222201', 'active', 4500,  '2023-03-15', '2023-03-15T00:00:00Z'),
('33333333-3333-3333-3333-333333050103', '11111111-1111-1111-1111-111111111105', 'Georgios Alexiou',    'Business Analyst',          'Analyst',      'Operations',       'Business Analysis',  '22222222-2222-2222-2222-222222222201', 'active', 4500,  '2023-04-01', '2023-04-01T00:00:00Z'),
('33333333-3333-3333-3333-333333050104', '11111111-1111-1111-1111-111111111105', 'Maria Konstantinou',  'QA Specialist',             'Specialist',   'Operations',       'Quality',            '22222222-2222-2222-2222-222222222201', 'active', 4200,  '2023-05-01', '2023-05-01T00:00:00Z'),
('33333333-3333-3333-3333-333333050105', '11111111-1111-1111-1111-111111111105', 'Alexandros Petrou',   'Team Lead',                 'Lead',         'Customer Success', 'Client Services',    '22222222-2222-2222-2222-222222222201', 'active', 9500,  '2023-02-15', '2023-02-15T00:00:00Z'),
('33333333-3333-3333-3333-333333050106', '11111111-1111-1111-1111-111111111105', 'Eleni Vassiliou',     'Operations Analyst',        'Analyst',      'Operations',       'Ops Analytics',      '22222222-2222-2222-2222-222222222201', 'active', 3000,  '2023-06-01', '2023-06-01T00:00:00Z'),
('33333333-3333-3333-3333-333333050107', '11111111-1111-1111-1111-111111111105', 'Nikos Antoniou',      'Financial Analyst',         'Analyst',      'Finance',          'FP&A',               '22222222-2222-2222-2222-222222222201', 'active', 4500,  '2023-07-15', '2023-07-15T00:00:00Z'),
('33333333-3333-3333-3333-333333050108', '11111111-1111-1111-1111-111111111105', NULL,                  'Senior Business Analyst',   'Analyst',      'Operations',       'Business Analysis',  '22222222-2222-2222-2222-222222222201', 'open',   7000,  NULL,         '2024-09-01T00:00:00Z'),
('33333333-3333-3333-3333-333333050109', '11111111-1111-1111-1111-111111111105', NULL,                  'Customer Success Specialist','Specialist',  'Customer Success', 'Client Services',    '22222222-2222-2222-2222-222222222201', 'open',   4500,  NULL,         '2024-10-15T00:00:00Z'),
('33333333-3333-3333-3333-333333050110', '11111111-1111-1111-1111-111111111105', 'Katerina Vlachou',    'Process Specialist',        'Specialist',   'Operations',       'Process Improvement', '22222222-2222-2222-2222-222222222201', 'active', 4200,  '2023-10-01', '2023-10-01T00:00:00Z');

-- ---- Hub 6: Johannesburg, South Africa (Internal) — 11 records ----
INSERT INTO sq_headcount (id, hub_id, employee_name, role_title, role_type, department, function_area, country_leader_user_id, status, cost_per_month, start_date, created_at) VALUES
('33333333-3333-3333-3333-333333060101', '11111111-1111-1111-1111-111111111106', 'Sipho Ndlovu',        'Customer Success Specialist','Specialist',  'Customer Success', 'Client Services',    '22222222-2222-2222-2222-222222222201', 'active', 3800,  '2023-06-01', '2023-06-01T00:00:00Z'),
('33333333-3333-3333-3333-333333060102', '11111111-1111-1111-1111-111111111106', 'Nomsa Khumalo',       'Operations Analyst',        'Analyst',      'Operations',       'Ops Analytics',      '22222222-2222-2222-2222-222222222201', 'active', 2200,  '2023-06-15', '2023-06-15T00:00:00Z'),
('33333333-3333-3333-3333-333333060103', '11111111-1111-1111-1111-111111111106', 'Willem Botha',        'Team Lead',                 'Lead',         'Customer Success', 'Client Services',    '22222222-2222-2222-2222-222222222201', 'active', 7800,  '2023-05-20', '2023-05-20T00:00:00Z'),
('33333333-3333-3333-3333-333333060104', '11111111-1111-1111-1111-111111111106', 'Lerato Moloi',        'Financial Analyst',         'Analyst',      'Finance',          'Financial Ops',      '22222222-2222-2222-2222-222222222201', 'active', 3800,  '2023-07-01', '2023-07-01T00:00:00Z'),
('33333333-3333-3333-3333-333333060105', '11111111-1111-1111-1111-111111111106', 'David Pretorius',     'Data Analyst',              'Analyst',      'Operations',       'Data & Reporting',   '22222222-2222-2222-2222-222222222201', 'active', 3600,  '2023-08-01', '2023-08-01T00:00:00Z'),
('33333333-3333-3333-3333-333333060106', '11111111-1111-1111-1111-111111111106', 'Thandiwe Mthembu',    'HR Coordinator',            'Coordinator',  'HR',               'People Ops',         '22222222-2222-2222-2222-222222222201', 'active', 3400,  '2023-09-01', '2023-09-01T00:00:00Z'),
('33333333-3333-3333-3333-333333060107', '11111111-1111-1111-1111-111111111106', 'Johan van Wyk',       'QA Specialist',             'Specialist',   'Operations',       'Quality',            '22222222-2222-2222-2222-222222222201', 'active', 3600,  '2023-10-01', '2023-10-01T00:00:00Z'),
('33333333-3333-3333-3333-333333060108', '11111111-1111-1111-1111-111111111106', 'Ayanda Zulu',         'Process Specialist',        'Specialist',   'Operations',       'Process Improvement', '22222222-2222-2222-2222-222222222201', 'active', 3800,  '2023-11-01', '2023-11-01T00:00:00Z'),
('33333333-3333-3333-3333-333333060109', '11111111-1111-1111-1111-111111111106', NULL,                  'Senior Customer Success Specialist','Specialist','Customer Success','Client Services', '22222222-2222-2222-2222-222222222201', 'open',   5800,  NULL,         '2024-09-15T00:00:00Z'),
('33333333-3333-3333-3333-333333060110', '11111111-1111-1111-1111-111111111106', NULL,                  'Operations Analyst',        'Analyst',      'Operations',       'Ops Analytics',      '22222222-2222-2222-2222-222222222201', 'open',   2200,  NULL,         '2024-10-01T00:00:00Z'),
('33333333-3333-3333-3333-333333060111', '11111111-1111-1111-1111-111111111106', 'Fatima Isaacs',       'Business Analyst',          'Analyst',      'Operations',       'Business Analysis',  '22222222-2222-2222-2222-222222222201', 'active', 4000,  '2024-01-15', '2024-01-15T00:00:00Z');

-- ---------------------------------------------------------------------------
-- 6. Change Orders  (3-5 per hub = 24 total)
-- ---------------------------------------------------------------------------

-- Hub 1: Bogota
INSERT INTO sq_change_orders (id, hub_id, title, change_type, description, status, requested_by, created_at) VALUES
('44444444-4444-4444-4444-444444010101', '11111111-1111-1111-1111-111111111101', 'Add Senior Financial Analyst',         'add',    'Backfill for Valentina''s promotion. Need senior-level FP&A support to handle expanded reporting scope.',                'approved',     '22222222-2222-2222-2222-222222222201', '2024-09-15T00:00:00Z'),
('44444444-4444-4444-4444-444444010102', '11111111-1111-1111-1111-111111111101', 'Add Operations Analyst',               'add',    'New headcount to support Q1 2025 volume increase in reconciliation processing.',                                         'submitted',    '22222222-2222-2222-2222-222222222201', '2024-10-10T00:00:00Z'),
('44444444-4444-4444-4444-444444010103', '11111111-1111-1111-1111-111111111101', 'Modify Team Lead compensation',        'modify', 'Adjust Santiago Herrera''s compensation to match market rate. Current rate below Vendor C benchmark by 12%.',             'under_review', '22222222-2222-2222-2222-222222222201', '2024-10-25T00:00:00Z'),
('44444444-4444-4444-4444-444444010104', '11111111-1111-1111-1111-111111111101', 'Remove open QA position',              'remove', 'QA function being consolidated into Bangalore vendor hub. Cancel open requisition.',                                     'draft',        '22222222-2222-2222-2222-222222222201', '2024-11-01T00:00:00Z');

-- Hub 2: Bangalore Vendor
INSERT INTO sq_change_orders (id, hub_id, title, change_type, description, status, requested_by, created_at) VALUES
('44444444-4444-4444-4444-444444020101', '11111111-1111-1111-1111-111111111102', 'Add Senior Software Developer',        'add',    'Need senior-level Java/Spring developer for payment processing platform.',                                               'approved',     '22222222-2222-2222-2222-222222222203', '2024-08-20T00:00:00Z'),
('44444444-4444-4444-4444-444444020102', '11111111-1111-1111-1111-111111111102', 'Add Data Analyst',                     'add',    'Additional data analyst for new business intelligence initiative launching in Q1 2025.',                                 'submitted',    '22222222-2222-2222-2222-222222222203', '2024-09-25T00:00:00Z'),
('44444444-4444-4444-4444-444444020103', '11111111-1111-1111-1111-111111111102', 'Modify QA Specialist to Senior level', 'modify', 'Promote Divya Natarajan from QA Specialist to Senior QA Specialist. Performance consistently exceeds expectations.',     'approved',     '22222222-2222-2222-2222-222222222203', '2024-10-05T00:00:00Z'),
('44444444-4444-4444-4444-444444020104', '11111111-1111-1111-1111-111111111102', 'Add DevOps Engineer',                  'add',    'New role to support CI/CD pipeline automation and cloud infrastructure management.',                                     'under_review', '22222222-2222-2222-2222-222222222203', '2024-10-30T00:00:00Z'),
('44444444-4444-4444-4444-444444020105', '11111111-1111-1111-1111-111111111102', 'Remove open Project Manager position', 'remove', 'PMO restructuring — combining two PM roles into one senior PM role.',                                                    'rejected',     '22222222-2222-2222-2222-222222222202', '2024-11-05T00:00:00Z');

-- Hub 3: Bangalore Internal
INSERT INTO sq_change_orders (id, hub_id, title, change_type, description, status, requested_by, created_at) VALUES
('44444444-4444-4444-4444-444444030101', '11111111-1111-1111-1111-111111111103', 'Add Senior Financial Analyst',         'add',    'Growing FP&A workload requires additional senior-level support for quarterly close process.',                            'approved',     '22222222-2222-2222-2222-222222222203', '2024-09-01T00:00:00Z'),
('44444444-4444-4444-4444-444444030102', '11111111-1111-1111-1111-111111111103', 'Add Customer Success Specialist',      'add',    'Expanding client services team to support APAC region growth.',                                                          'submitted',    '22222222-2222-2222-2222-222222222203', '2024-10-15T00:00:00Z'),
('44444444-4444-4444-4444-444444030103', '11111111-1111-1111-1111-111111111103', 'Modify Process Specialist role scope', 'modify', 'Expand Anita Rao''s scope to include vendor management responsibilities. Adjust title and compensation accordingly.',     'draft',        '22222222-2222-2222-2222-222222222203', '2024-11-01T00:00:00Z');

-- Hub 4: Baroda
INSERT INTO sq_change_orders (id, hub_id, title, change_type, description, status, requested_by, created_at) VALUES
('44444444-4444-4444-4444-444444040101', '11111111-1111-1111-1111-111111111104', 'Add Financial Analyst',                'add',    'Additional AP support needed for new ERP migration data validation project.',                                            'submitted',    '22222222-2222-2222-2222-222222222201', '2024-09-20T00:00:00Z'),
('44444444-4444-4444-4444-444444040102', '11111111-1111-1111-1111-111111111104', 'Add Operations Analyst',               'add',    'Volume growth in data processing team requires additional junior analyst.',                                              'approved',     '22222222-2222-2222-2222-222222222201', '2024-10-01T00:00:00Z'),
('44444444-4444-4444-4444-444444040103', '11111111-1111-1111-1111-111111111104', 'Modify Team Lead to Manager',          'modify', 'Promote Manish Shah from Team Lead to Operations Manager given expanded scope and direct reports.',                      'under_review', '22222222-2222-2222-2222-222222222201', '2024-10-20T00:00:00Z'),
('44444444-4444-4444-4444-444444040104', '11111111-1111-1111-1111-111111111104', 'Remove QA Specialist position',        'remove', 'QA responsibilities being absorbed by process specialists. Chirag Mehta transitioning to process role.',                 'draft',        '22222222-2222-2222-2222-222222222201', '2024-11-05T00:00:00Z');

-- Hub 5: Athens
INSERT INTO sq_change_orders (id, hub_id, title, change_type, description, status, requested_by, created_at) VALUES
('44444444-4444-4444-4444-444444050101', '11111111-1111-1111-1111-111111111105', 'Add Senior Business Analyst',          'add',    'Strategic hire to lead new European regulatory compliance workstream.',                                                  'approved',     '22222222-2222-2222-2222-222222222201', '2024-08-15T00:00:00Z'),
('44444444-4444-4444-4444-444444050102', '11111111-1111-1111-1111-111111111105', 'Add Customer Success Specialist',      'add',    'Expanding EMEA client coverage. Multilingual candidate preferred (English + French or German).',                         'submitted',    '22222222-2222-2222-2222-222222222201', '2024-10-10T00:00:00Z'),
('44444444-4444-4444-4444-444444050103', '11111111-1111-1111-1111-111111111105', 'Modify Project Manager compensation',  'modify', 'Annual compensation review — Dimitris Papadopoulos due for market adjustment.',                                          'approved',     '22222222-2222-2222-2222-222222222201', '2024-09-20T00:00:00Z');

-- Hub 6: South Africa
INSERT INTO sq_change_orders (id, hub_id, title, change_type, description, status, requested_by, created_at) VALUES
('44444444-4444-4444-4444-444444060101', '11111111-1111-1111-1111-111111111106', 'Add Senior Customer Success Specialist','add',   'Need experienced team member to mentor junior CSS team and handle escalations.',                                         'submitted',    '22222222-2222-2222-2222-222222222201', '2024-09-10T00:00:00Z'),
('44444444-4444-4444-4444-444444060102', '11111111-1111-1111-1111-111111111106', 'Add Operations Analyst',               'add',    'Second analyst for growing ops analytics function. Will focus on reporting automation.',                                 'approved',     '22222222-2222-2222-2222-222222222201', '2024-09-25T00:00:00Z'),
('44444444-4444-4444-4444-444444060103', '11111111-1111-1111-1111-111111111106', 'Modify Data Analyst to Senior',        'modify', 'Promote David Pretorius based on exceptional performance and expanded data engineering responsibilities.',               'under_review', '22222222-2222-2222-2222-222222222201', '2024-10-15T00:00:00Z'),
('44444444-4444-4444-4444-444444060104', '11111111-1111-1111-1111-111111111106', 'Add Technical Support Specialist',     'add',    'New function for the Johannesburg hub — pilot for technical support delivery from South Africa.',                        'draft',        '22222222-2222-2222-2222-222222222201', '2024-11-01T00:00:00Z');

-- ---------------------------------------------------------------------------
-- 7. Contracts (2, one per vendor hub)
-- ---------------------------------------------------------------------------
INSERT INTO sq_contracts (id, hub_id, vendor_name, contract_number, total_value, currency, start_date, end_date, access_level, status, created_at) VALUES
('55555555-5555-5555-5555-555555550101', '11111111-1111-1111-1111-111111111101', 'Vendor C', 'SOW-2024-001', 2400000.00, 'USD', '2024-01-01', '2025-12-31', 'standard',   'active', '2023-12-15T00:00:00Z'),
('55555555-5555-5555-5555-555555550201', '11111111-1111-1111-1111-111111111102', 'Vendor G', 'SOW-2024-002', 3200000.00, 'USD', '2024-03-01', '2026-02-28', 'restricted', 'active', '2024-02-15T00:00:00Z');

-- ---------------------------------------------------------------------------
-- 8. Invoices + Line Items
-- ---------------------------------------------------------------------------

-- Invoice 1: Hub 1 / Vendor C
INSERT INTO sq_invoices (id, hub_id, vendor_name, invoice_number, total_amount, currency, invoice_date, due_date, status, created_at) VALUES
('66666666-6666-6666-6666-666666660101', '11111111-1111-1111-1111-111111111101', 'Vendor C', 'INV-2024-0089', 185000.00, 'USD', '2024-11-01', '2024-11-30', 'in_review', '2024-11-02T00:00:00Z');

INSERT INTO sq_invoice_line_items (id, invoice_id, employee_name, role_title, days_worked, daily_rate, amount, approval_status, created_at) VALUES
('77777777-7777-7777-7777-777777010101', '66666666-6666-6666-6666-666666660101', 'Alejandro Gomez',     'Operations Analyst',         21, 160.00, 3360.00,  'approved', '2024-11-02T00:00:00Z'),
('77777777-7777-7777-7777-777777010102', '66666666-6666-6666-6666-666666660101', 'Valentina Torres',    'Financial Analyst',          22, 250.00, 5500.00,  'approved', '2024-11-02T00:00:00Z'),
('77777777-7777-7777-7777-777777010103', '66666666-6666-6666-6666-666666660101', 'Santiago Herrera',     'Team Lead',                  22, 400.00, 8800.00,  'approved', '2024-11-02T00:00:00Z'),
('77777777-7777-7777-7777-777777010104', '66666666-6666-6666-6666-666666660101', 'Camila Restrepo',     'Data Analyst',               20, 240.00, 4800.00,  'pending',  '2024-11-02T00:00:00Z'),
('77777777-7777-7777-7777-777777010105', '66666666-6666-6666-6666-666666660101', 'Mateo Ramirez',       'Process Specialist',         21, 260.00, 5460.00,  'approved', '2024-11-02T00:00:00Z'),
('77777777-7777-7777-7777-777777010106', '66666666-6666-6666-6666-666666660101', 'Laura Jimenez',       'HR Coordinator',             22, 220.00, 4840.00,  'pending',  '2024-11-02T00:00:00Z'),
('77777777-7777-7777-7777-777777010107', '66666666-6666-6666-6666-666666660101', 'Andres Castillo',     'QA Specialist',              19, 230.00, 4370.00,  'disputed', '2024-11-02T00:00:00Z'),
('77777777-7777-7777-7777-777777010108', '66666666-6666-6666-6666-666666660101', 'Carolina Vargas',     'Customer Success Specialist',22, 210.00, 4620.00,  'approved', '2024-11-02T00:00:00Z'),
('77777777-7777-7777-7777-777777010109', '66666666-6666-6666-6666-666666660101', 'Felipe Diaz',         'Business Analyst',           21, 260.00, 5460.00,  'pending',  '2024-11-02T00:00:00Z');

-- Invoice 2: Hub 2 / Vendor G
INSERT INTO sq_invoices (id, hub_id, vendor_name, invoice_number, total_amount, currency, invoice_date, due_date, status, created_at) VALUES
('66666666-6666-6666-6666-666666660201', '11111111-1111-1111-1111-111111111102', 'Vendor G', 'INV-2024-0156', 245000.00, 'USD', '2024-11-15', '2024-12-15', 'pending', '2024-11-16T00:00:00Z');

INSERT INTO sq_invoice_line_items (id, invoice_id, employee_name, role_title, days_worked, daily_rate, amount, approval_status, created_at) VALUES
('77777777-7777-7777-7777-777777020101', '66666666-6666-6666-6666-666666660201', 'Arun Kumar',          'Software Developer',         22, 220.00, 4840.00,  'pending',  '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020102', '66666666-6666-6666-6666-666666660201', 'Deepika Menon',       'QA Specialist',              21, 190.00, 3990.00,  'pending',  '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020103', '66666666-6666-6666-6666-666666660201', 'Suresh Venkatesh',    'Team Lead',                  22, 380.00, 8360.00,  'approved', '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020104', '66666666-6666-6666-6666-666666660201', 'Lakshmi Iyer',        'Data Analyst',               20, 200.00, 4000.00,  'pending',  '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020105', '66666666-6666-6666-6666-666666660201', 'Ravi Shankar',        'Software Developer',         22, 340.00, 7480.00,  'approved', '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020106', '66666666-6666-6666-6666-666666660201', 'Meena Krishnan',      'Business Analyst',           21, 240.00, 5040.00,  'disputed', '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020107', '66666666-6666-6666-6666-666666660201', 'Prasad Rao',          'Project Manager',            22, 310.00, 6820.00,  'pending',  '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020108', '66666666-6666-6666-6666-666666660201', 'Kavitha Sundaram',    'Operations Analyst',         18, 150.00, 2700.00,  'approved', '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020109', '66666666-6666-6666-6666-666666660201', 'Ajay Pillai',         'Software Developer',         22, 220.00, 4840.00,  'pending',  '2024-11-16T00:00:00Z'),
('77777777-7777-7777-7777-777777020110', '66666666-6666-6666-6666-666666660201', 'Divya Natarajan',     'QA Specialist',              21, 200.00, 4200.00,  'approved', '2024-11-16T00:00:00Z');

-- ---------------------------------------------------------------------------
-- 9. Release Notes
-- ---------------------------------------------------------------------------
INSERT INTO sq_release_notes (id, version, release_date, features, bug_fixes, created_at) VALUES
('88888888-8888-8888-8888-888888880101', '1.0.0', '2024-12-01',
 '["Hub profile management with 6 structured sections (overview, cost summary, talent profile, HR processes, key contacts, notes)","Executive dashboard with headcount analytics and cost breakdowns by hub, department, and role type","Change order workflow supporting draft, submitted, under review, approved, and rejected statuses","Contract and SOW management with standard and restricted access levels","Invoice approval workflow with line-item level approvals and dispute tracking","Role-based access control with 4 roles: functional leader, central ops, hub leader, and executive","Demo mode with comprehensive sample data for evaluation and training","Self-registration with admin approval workflow","Release notes and user guide accessible from within the application","Email notifications for invoice approval requests and status changes"]',
 '[]',
 '2024-12-01T00:00:00Z');

-- ---------------------------------------------------------------------------
-- 10. User Guide Sections
-- ---------------------------------------------------------------------------
INSERT INTO sq_user_guide (id, section_title, section_order, content_markdown, created_at) VALUES

('99999999-9999-9999-9999-999999990101', 'Getting Started', 1,
'## Getting Started

Welcome to Squarecana Talent Hub Manager. This application helps you manage your global talent hubs, track headcount, process change orders, and handle vendor invoices all in one place.

To get started, you will need to register for an account. Visit the login page and click the "Register" link. Fill in your name, email address, and select the role that best describes your position. If you are associated with a specific hub, select it during registration.

After submitting your registration, an administrator will review and approve your account. You will receive an email notification once your account has been activated. This approval step ensures that only authorized personnel have access to hub data and financial information.

Once logged in, you will see a navigation menu on the left side of the screen. The options available to you depend on your assigned role. All users can view hub profiles and release notes. Additional features like change orders, contracts, and invoice approvals are available based on your role and permissions.

If your organization has demo mode enabled, you will see sample data throughout the application. This is useful for training and evaluation purposes. Your administrator can toggle demo mode off when you are ready to work with real data.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990102', 'Understanding Roles', 2,
'## Understanding Roles

Squarecana Talent Hub Manager uses four roles to control what each user can see and do. Your role is assigned during the registration approval process and can be changed by an administrator at any time.

**Functional Leader** is the most common role. Functional leaders are responsible for the day-to-day management of talent within their assigned hub. They can view and edit hub profiles, submit change orders, review invoices for their hub, and access headcount details. They typically work closely with vendor or hub managers to ensure staffing levels meet business needs.

**Hub Leader** has similar capabilities to a functional leader but with a focus on the operational management of a specific hub location. Hub leaders can manage hub profiles, review and approve change orders for their hub, and coordinate with HR and vendor contacts. They serve as the primary point of contact for hub-related decisions.

**Central Operations** users have a broader view across all hubs. They can access all hub profiles, review change orders from any hub, manage contracts and SOWs, and process invoices. Central ops users often have admin privileges, allowing them to approve new user registrations and manage application settings.

**Executive** users have read-only access to high-level dashboards and analytics. They can view the executive dashboard with headcount summaries, cost breakdowns, and trend data across all hubs. Executives do not typically create or modify records but use the application for strategic oversight and decision-making.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990103', 'Hub Profiles', 3,
'## Hub Profiles

Hub profiles contain all the essential information about each talent hub location. Each profile is organized into six sections to make it easy to find what you need.

The **Overview** section provides basic information about the hub including its location, type (internal or vendor-managed), time zone, and a general description. For vendor-managed hubs, you will also see the vendor name. This section gives anyone a quick understanding of what the hub does and where it fits in the global delivery model.

The **Cost Summary** section shows average monthly costs by seniority level (Junior, Mid, Senior, and Lead). These figures help with budgeting and comparing costs across hubs. The last updated date tells you how current the information is. Costs are displayed in USD for easy comparison.

The **Talent Profile** section describes the types of work performed at the hub, along with its strengths, weaknesses, and local talent market conditions. This information is valuable when deciding where to place new roles or expand existing functions. It is written in a narrative format to provide context beyond simple lists.

The **HR Processes** section documents the requisition process for adding new roles, the performance review cycle, and offboarding procedures. This is especially important for vendor-managed hubs where processes may differ from internal practices.

The **Key Contacts** section lists the primary people to reach out to for hub-related matters, including their titles, email addresses, and phone numbers. The **Notes** section is a free-form area for any additional information, historical context, or action items related to the hub.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990104', 'Executive Dashboard', 4,
'## Executive Dashboard

The Executive Dashboard provides a high-level view of your global talent hub operations. It is designed for quick insights without requiring you to drill into individual hubs.

The top of the dashboard shows summary cards with key metrics: total headcount across all hubs, number of open positions, total monthly cost, and the number of active hubs. These numbers update in real time as changes are made throughout the application.

Below the summary cards, you will find charts that break down headcount and costs by different dimensions. The hub breakdown chart shows how headcount is distributed across your locations. The department breakdown shows the mix of Operations, Finance, Technology, HR, and Customer Success roles. The role type breakdown categorizes employees as Analysts, Specialists, Developers, Managers, Leads, or Coordinators.

You can filter the dashboard by hub, department, status (active vs. open positions), and date range. Filters apply to all charts and tables on the page simultaneously. Use the reset button to clear all filters and return to the default view.

The dashboard also includes a cost comparison view that shows average costs by seniority level across hubs. This makes it easy to identify which locations offer the best value for different role levels. The data behind the dashboard comes from the headcount records and hub profile cost summaries.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990105', 'Change Orders', 5,
'## Change Orders

Change orders are the formal process for requesting changes to hub staffing. Whether you need to add a new role, modify an existing position, or remove a headcount slot, it all starts with a change order.

To create a change order, navigate to the Change Orders page and click "New Change Order." Select the hub, choose the change type (Add, Modify, or Remove), and provide a descriptive title and detailed explanation. Be as specific as possible in the description — include the role level, function area, justification, and any timing requirements. Well-written change orders are processed faster.

Once created, a change order starts in **Draft** status. You can edit drafts as many times as needed before submitting. When you are satisfied, click "Submit" to move it to **Submitted** status. At this point, the appropriate reviewers are notified.

Reviewers (typically central ops or hub leaders) will move the change order to **Under Review** while they evaluate it. They may reach out with questions or request modifications. The final outcome is either **Approved** or **Rejected**. Approved change orders result in updates to the headcount records — new positions are created, existing ones are modified, or slots are removed.

You can track the status of all your change orders from the Change Orders list page. Use the filters to view by hub, status, or change type. Each change order maintains a complete history of who created it and when status changes occurred.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990106', 'Contracts and SOW Management', 6,
'## Contracts and SOW Management

The Contracts section manages the formal agreements with your vendor partners. Each vendor-managed hub has an associated contract or Statement of Work (SOW) that governs the relationship, pricing, and terms.

Contract records include the vendor name, contract number (typically a SOW reference), total contract value, currency, and the start and end dates. The status field indicates whether a contract is active, expired, or under renewal. This information helps you track your financial commitments and plan for upcoming renewals.

An important feature is the **access level** setting on each contract. Contracts can be set to "Standard" access, which allows all authorized users to view contract details, or "Restricted" access, which limits visibility to hub leaders and central ops users only. This is useful when vendor pricing is confidential or when different stakeholders should see different levels of detail.

Contract management is a view-and-track function in the current version. Creating and editing contracts is available to central ops users and administrators. Future versions will add document attachment capabilities, clause-level tracking, and automated renewal reminders.

To view contracts, navigate to the Contracts page from the main menu. You will see a list of all contracts you have access to, with key details visible at a glance. Click on any contract to view its full details. If you do not see a contract you expect, check with your administrator — it may be set to restricted access.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990107', 'Invoice Approval', 7,
'## Invoice Approval

The Invoice Approval workflow helps you review and approve vendor invoices at the line-item level. This ensures accuracy and accountability for every charge on a vendor bill.

When a new invoice is entered, it appears with a status of "Pending." Each invoice contains line items that represent individual employees or services billed for that period. Line items include the employee name, role title, number of days worked, daily rate, and total amount.

Each line item has its own approval status: **Pending**, **Approved**, or **Disputed**. Reviewers go through each line item and verify the details against their records. If everything looks correct, they approve the line item. If there is a discrepancy — such as incorrect days worked, wrong rate, or an unrecognized employee — they can mark it as disputed and add a note explaining the issue.

Once all line items have been reviewed, the invoice status can be updated accordingly. If all items are approved, the invoice moves to an approved state. If any items are disputed, the invoice is flagged for follow-up with the vendor. The vendor contact listed in the hub profile is typically the person to reach out to for dispute resolution.

Invoice notifications are sent via email when new invoices are ready for review and when disputed items need attention. You can configure your notification preferences in your account settings. The invoice list page shows all invoices with filters for hub, vendor, status, and date range.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990108', 'Demo Mode', 8,
'## Demo Mode

Demo mode is a special feature that populates the application with realistic sample data. It is designed for training new users, evaluating the application, and demonstrating features to stakeholders without affecting real data.

When demo mode is enabled, you will see six sample hubs across multiple countries, four demo user accounts representing each role, headcount records with realistic names and costs, sample change orders in various statuses, vendor contracts, and invoices with line items. All of this data is clearly marked as demo data.

Demo mode is controlled by an administrator through the Settings page. When toggled on, the sample data becomes visible throughout the application. When toggled off, only your real data is displayed. Enabling or disabling demo mode does not affect any real data in the system — it simply controls the visibility of the sample records.

Demo mode is particularly useful during onboarding. New users can explore all features of the application, practice submitting change orders, and review sample invoices without worrying about making mistakes with real data. Trainers can walk through realistic scenarios using the sample hubs and headcount records.

If you are unsure whether you are looking at demo data or real data, check the Settings page or ask your administrator. In a future update, demo records will include a visual indicator to make them easy to distinguish from real records at a glance.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990109', 'Settings and Administration', 9,
'## Settings and Administration

The Settings area is available to users with admin privileges (typically central ops users). It provides tools for managing users, hubs, and application-wide settings.

**User Management** allows administrators to view all registered users, approve pending registrations, change user roles, assign users to hubs, and deactivate accounts. When a new user registers, they appear in the pending list. Administrators should verify the person''s identity and appropriate role before approving access. You can also change a user''s role or hub assignment at any time if their responsibilities change.

**Hub Management** lets administrators create new hubs, update hub details, and archive hubs that are no longer active. When creating a new hub, you will specify the location, type (internal or vendor-managed), and if applicable, the vendor name. The hub then becomes available for profile editing, headcount tracking, and other features.

**Application Settings** include the demo mode toggle and other system-wide configurations. Changes to application settings take effect immediately for all users. Use caution when toggling demo mode in a production environment, as it may confuse users who are not expecting to see sample data.

The Settings page also provides access to release notes and the user guide you are reading now. These resources are maintained by the application team and updated with each new version. Administrators are encouraged to review release notes after each update and communicate relevant changes to their users.', '2024-12-01T00:00:00Z'),

('99999999-9999-9999-9999-999999990110', 'FAQ', 10,
'## Frequently Asked Questions

**How do I get access to the application?**
Visit the login page and click Register. Fill in your details and submit the form. An administrator will review and approve your account, usually within one business day. You will receive an email when your account is activated.

**I cannot see a hub that I should have access to. What should I do?**
Your visibility depends on your assigned role and hub. Functional leaders and hub leaders see hubs they are assigned to. Central ops and executive users see all hubs. If you believe your access is incorrect, contact your administrator to review your role and hub assignment.

**How do I submit a change order?**
Navigate to Change Orders, click New Change Order, fill in the required fields (hub, change type, title, description), and save it as a draft. Review your draft, then click Submit when ready. Your change order will be routed to the appropriate reviewer.

**What happens when a change order is approved?**
Approved change orders trigger updates to the headcount records. For "Add" orders, a new open position is created. For "Modify" orders, the existing record is updated. For "Remove" orders, the position is closed. These changes are reflected in the dashboard and headcount views.

**How do I dispute an invoice line item?**
Open the invoice, find the line item in question, and change its approval status to Disputed. Add a note explaining the discrepancy. The vendor contact and central ops team will be notified to follow up.

**Can I export data from the application?**
Data export features are planned for a future release. In the current version, you can use your browser''s print function to save pages as PDF for offline reference.

**Who do I contact for technical support?**
For application issues, contact your central ops administrator. For account access problems, reach out to your local hub leader or the central ops team. Bug reports and feature requests can be submitted through your administrator.', '2024-12-01T00:00:00Z');

-- =============================================================================
-- End of seed data
-- =============================================================================

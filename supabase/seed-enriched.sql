-- seed-enriched.sql
-- UPDATE existing demo data with richer, more realistic content.
-- Run AFTER seed.sql has loaded the base data.

-- ============================================================
-- 1. UPDATE Hub Profiles (sq_hub_profiles)
-- ============================================================

-- ---- Hub 1: Bogota, Colombia (Vendor C) ----

UPDATE sq_hub_profiles
SET content_json = '{"location":"Bogota, Colombia","type":"Vendor-Managed","vendor":"Vendor C","timezone":"GMT-5 (Colombia Time)","hub_size":"~120 FTE","description":"Primary operations and analytics hub for Latin America coverage. Vendor C manages day-to-day operations including recruiting, onboarding, and performance management. The hub serves as the anchor delivery center for all LATAM-facing processes including financial reconciliation, data entry, and customer operations support. Established in 2021, the hub has grown from 40 to 120 FTEs over three years."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111101' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = '{"tiers":[{"level":"Junior","avg_cost":1800,"currency":"USD"},{"level":"Mid","avg_cost":2800,"currency":"USD"},{"level":"Senior","avg_cost":4200,"currency":"USD"},{"level":"Lead","avg_cost":5500,"currency":"USD"}],"last_updated":"2025-01-15","notes":"Rates reflect Vendor C contracted rates as of SOW-2024-001. Rate renegotiation scheduled for Q3 2025 renewal."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111101' AND section_key = 'cost_summary';

UPDATE sq_hub_profiles
SET content_json = '{"types_of_work":"<p>Financial analysis and reconciliation, data entry and validation, customer operations support, process documentation, accounts payable/receivable processing, LATAM regulatory compliance support, bilingual (Spanish/English) customer service.</p>","strengths":"<p>Strong bilingual (Spanish/English) analyst talent pool. High retention rate (~92% annually). Competitive cost structure for LATAM market. Vendor C has deep local recruiting network. Team culture is collaborative with strong institutional knowledge. Quick ramp-up capability — average time-to-productivity is 3 weeks.</p>","weaknesses":"<p>Limited availability of senior technology talent. Most tech roles need to be sourced from Bangalore hubs. Timezone gap with APAC teams can slow cross-hub collaboration. Vendor C''s recruiting SLA (10 business days to shortlist) can be slow for urgent backfills.</p>","talent_market":"<p>Bogota''s talent market is growing rapidly. Major competitors for talent include Teleperformance, Accenture, EY, and KPMG — all of whom have significant operations in the city. The Colombian government offers tax incentives for BPO operations which keeps the market competitive. English proficiency is improving across the market, with ~35% of university graduates achieving B2+ level. Average market salary inflation is running at 8-10% annually.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111101' AND section_key = 'talent_profile';

UPDATE sq_hub_profiles
SET content_json = '{"requisition":"<p>All new requisitions must be submitted via a Change Order in this system. Once approved, Central Ops forwards the request to Vendor C''s recruiting team via the vendor portal. Vendor C SLA is 10 business days to present a shortlist of 3 qualified candidates. Interview scheduling is coordinated between the hiring manager and Vendor C''s talent acquisition lead. Average time-to-fill is 25 business days from change order approval.</p>","performance":"<p>Performance is managed via Vendor C''s quarterly scorecard system. Scorecards include KPIs for productivity, quality, attendance, and stakeholder feedback. Central Ops reviews scorecards quarterly during the QBR (Quarterly Business Review). Individual performance issues are escalated through Vendor C''s HR team with a formal PIP process if needed. Annual compensation adjustments are proposed by Vendor C during contract renewal discussions.</p>","offboarding":"<p>Vendor C manages all offboarding per Colombian labor law requirements. Standard notice period is 30 days written notice. Severance calculations follow Colombian statutory requirements (15 days per year of service for the first year, additional days for subsequent years). Knowledge transfer must be completed before the last working day. IT asset return is coordinated by Vendor C''s local office. Central Ops must be notified within 24 hours of any resignation or termination.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111101' AND section_key = 'hr_processes';

UPDATE sq_hub_profiles
SET content_json = '{"contacts":[{"name":"Ricardo Mendoza","title":"Account Manager, Vendor C","email":"r.mendoza@vendorc.com","phone":"+57 1 555 0101"},{"name":"Isabella Gutierrez","title":"Talent Acquisition Lead, Vendor C","email":"i.gutierrez@vendorc.com","phone":"+57 1 555 0102"},{"name":"James Mitchell","title":"Central Ops Owner","email":"james.mitchell@example.com","phone":"+1 555 0200"},{"name":"Maria Santos","title":"Functional Leader, LATAM Operations","email":"maria.santos@example.com","phone":"+1 555 0201"}]}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111101' AND section_key = 'key_contacts';

UPDATE sq_hub_profiles
SET content_json = '{"content":"<p><strong>Contract Renewal:</strong> Vendor C contract (SOW-2024-001) expires December 2025. Rate renegotiation is in progress — target is a 3-5% reduction on Senior and Lead tiers given market conditions. Vendor C has proposed a 2-year extension with 2% annual escalation.</p><p><strong>Facility:</strong> Hub operates from Vendor C''s Bogota office in Zona T (Calle 82). Current capacity is 150 seats; 120 occupied. No immediate space constraints.</p><p><strong>Risk Items:</strong> Two senior analysts have expressed interest in relocation to other Vendor C clients. Retention bonuses under discussion. Currency risk is moderate — Colombian peso has been stable but inflation is a concern.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111101' AND section_key = 'notes';

-- ---- Hub 2: Bangalore, India (Vendor G) ----

UPDATE sq_hub_profiles
SET content_json = '{"location":"Bangalore, India","type":"Vendor-Managed","vendor":"Vendor G","timezone":"IST (UTC+5:30)","hub_size":"~95 FTE","description":"Primary hub for technology and data roles. Vendor G provides end-to-end delivery management for software development, QA, data engineering, and technical support functions. The hub handles critical platform development work including the payment processing system and business intelligence infrastructure. Established in 2022 as part of the APAC delivery expansion strategy."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111102' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = '{"tiers":[{"level":"Junior","avg_cost":1200,"currency":"USD"},{"level":"Mid","avg_cost":2000,"currency":"USD"},{"level":"Senior","avg_cost":3200,"currency":"USD"},{"level":"Lead","avg_cost":4400,"currency":"USD"}],"last_updated":"2025-01-10","notes":"Rates per Vendor G SOW-2024-002 rate card. Restricted access contract — rates are confidential. Annual escalation clause of 4% applies."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111102' AND section_key = 'cost_summary';

UPDATE sq_hub_profiles
SET content_json = '{"types_of_work":"<p>Software development (Java, Python, React), QA automation and manual testing, data engineering and ETL pipeline development, business intelligence and analytics, technical support (L2/L3), DevOps and cloud infrastructure management (AWS), API development and integration.</p>","strengths":"<p>Deep technology talent pool — Bangalore is India''s premier tech hub. Strong data engineering capabilities with experienced Spark/Airflow engineers. Vendor G has a dedicated recruiting team for our account with access to a 50,000+ candidate database. Cost-effective for senior tech talent compared to US/EU markets. Team has built strong domain knowledge of our platform architecture.</p>","weaknesses":"<p>High attrition rate — currently running at 18% annually, above the 15% target. Competitive market means counter-offers are common during the notice period. Senior developers are particularly hard to retain. Vendor G''s notice period enforcement is inconsistent — some resources leave before completing knowledge transfer.</p>","talent_market":"<p>Bangalore''s tech talent market is extremely competitive. Major competitors include Infosys, Wipro, Capgemini, TCS, and numerous startups offering equity compensation. Demand for senior full-stack developers and data engineers significantly exceeds supply. Average tech salary inflation is 12-15% annually for mid-to-senior roles. Remote work has expanded the competitive landscape — Bangalore engineers are now recruited by US companies offering USD-benchmarked salaries.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111102' AND section_key = 'talent_profile';

UPDATE sq_hub_profiles
SET content_json = '{"requisition":"<p>Change orders for Vendor G roles are submitted through this system. Once approved, the request is forwarded to Vendor G''s dedicated recruiting pod via their delivery portal. SLA is 15 business days to present a shortlist of 3-5 candidates. Technical assessments are conducted by Vendor G''s assessment team before candidates are presented. Final interviews are conducted by the hiring manager via video call. Average time-to-fill is 35 business days due to notice period requirements (most candidates have 60-90 day notice periods at their current employer).</p>","performance":"<p>Performance is tracked via monthly KPI dashboards covering code quality metrics, sprint velocity, defect rates, and delivery milestones. Vendor G provides monthly performance reports reviewed during the Monthly Operating Review (MOR). Underperformers are placed on a 30-day improvement plan managed by Vendor G''s delivery manager. Annual performance calibration is conducted jointly between Central Ops and Vendor G leadership.</p>","offboarding":"<p>Indian labor law requires a minimum notice period, but Vendor G contracts specify 45 days written notice for all roles. Senior roles (Lead and above) require 60 days notice. During the notice period, knowledge transfer must be documented in Confluence. Vendor G facilitates exit interviews and provides a summary report to Central Ops. Background verification records are retained per Indian IT Act compliance requirements. All client-related IP and access credentials must be revoked on the last working day.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111102' AND section_key = 'hr_processes';

UPDATE sq_hub_profiles
SET content_json = '{"contacts":[{"name":"Suresh Venkatesh","title":"Delivery Manager, Vendor G","email":"s.venkatesh@vendorg.com","phone":"+91 80 5555 0101"},{"name":"Kavitha Sundaram","title":"Talent Acquisition Lead, Vendor G","email":"k.sundaram@vendorg.com","phone":"+91 80 5555 0102"},{"name":"James Mitchell","title":"Central Ops Owner","email":"james.mitchell@example.com","phone":"+1 555 0200"},{"name":"Priya Sharma","title":"Hub Operations Lead","email":"priya.sharma@example.com","phone":"+91 80 5555 0200"}]}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111102' AND section_key = 'key_contacts';

UPDATE sq_hub_profiles
SET content_json = '{"content":"<p><strong>Attrition Risk:</strong> Flagged in the last QBR (Q4 2024). Three senior developers and one team lead have received external offers. Vendor G has proposed retention bonuses of 15% of annual CTC for critical roles. Succession planning is in progress for all Lead-level positions.</p><p><strong>Contract:</strong> SOW-2024-002 is classified as restricted access. Total contract value and rate card details are visible only to Central Ops and admin users. Contract runs through Feb 2026.</p><p><strong>Facility:</strong> Vendor G''s Electronic City Phase 2 office. Capacity for 120 seats; 95 currently occupied. Vendor G is renovating an additional floor — capacity will increase to 180 seats by Q2 2025.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111102' AND section_key = 'notes';

-- ---- Hub 3: Bangalore, India (Internal) ----

UPDATE sq_hub_profiles
SET content_json = '{"location":"Bangalore, India","type":"Internal","vendor":null,"timezone":"IST (UTC+5:30)","hub_size":"~60 FTE","description":"Internal team focused on finance operations and HR shared services. This hub handles core back-office functions including accounts payable/receivable, payroll processing, financial reporting, and HR operations support. Established in 2022 as part of the global shared services strategy. Team operates under direct management with no vendor intermediary."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111103' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = '{"tiers":[{"level":"Junior","avg_cost":900,"currency":"USD"},{"level":"Mid","avg_cost":1600,"currency":"USD"},{"level":"Senior","avg_cost":2600,"currency":"USD"},{"level":"Lead","avg_cost":3800,"currency":"USD"}],"last_updated":"2025-01-12","notes":"Internal cost-to-company (CTC) rates. Inclusive of benefits, PF, and gratuity. Significantly lower than vendor-managed rates due to no vendor markup."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111103' AND section_key = 'cost_summary';

UPDATE sq_hub_profiles
SET content_json = '{"types_of_work":"<p>Accounts payable and receivable processing, payroll operations for 5 countries, financial reporting and month-end close activities, HR operations (onboarding, benefits administration, employee records management), internal audit support, compliance documentation.</p>","strengths":"<p>Strong institutional knowledge — average tenure is 2.8 years, well above industry average. Low attrition rate (~8% annually). Team has deep understanding of internal systems and processes. Cost-effective compared to vendor-managed alternatives (no vendor markup). Direct management enables faster decision-making and process changes.</p>","weaknesses":"<p>Slower hiring cycle compared to vendor hubs — internal HR recruiting SLA is 25+ business days. Limited flexibility to scale quickly for project-based work. Team members occasionally get pulled into internal transfer requests from other departments, creating backfill needs.</p>","talent_market":"<p>Bangalore''s finance and HR talent market is competitive but more accessible than the technology market. CA (Chartered Accountant) and MBA graduates are available in good supply. Competition for finance talent comes primarily from internal transfers to tech companies offering higher compensation. Average salary inflation for finance/ops roles is 8-10% annually — lower than tech roles.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111103' AND section_key = 'talent_profile';

UPDATE sq_hub_profiles
SET content_json = '{"requisition":"<p>All requisitions are opened in Workday ATS. The hiring manager submits a requisition with job description, level, and budget approval. HR Business Partner reviews and posts the role within 3 business days. Sourcing uses a mix of job boards (Naukri, LinkedIn), internal referrals, and campus recruiting. Average time-to-fill is 40 business days including notice period buyouts where applicable.</p>","performance":"<p>Performance follows the global annual cycle: goal-setting in January, mid-year check-in in July, annual review in December. Ratings use a 5-point scale. Promotion and compensation decisions are made during the February calibration cycle. PIPs are managed through HR Business Partner with a standard 60-day improvement window.</p>","offboarding":"<p>Per Indian labor law, notice periods range from 30 to 90 days based on tenure and level. Standard practice is 30 days for Junior/Mid levels, 60 days for Senior, and 90 days for Lead. Notice period buyout is available at manager discretion and HR approval. Exit interviews are conducted by HR BP. All company assets (laptop, ID badge, access cards) must be returned on the last working day. Final settlement is processed within 45 days of separation.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111103' AND section_key = 'hr_processes';

UPDATE sq_hub_profiles
SET content_json = '{"contacts":[{"name":"Priya Sharma","title":"Hub Operations Lead","email":"priya.sharma@example.com","phone":"+91 80 5555 0200"},{"name":"Ananya Krishnamurthy","title":"HR Business Partner","email":"a.krishnamurthy@example.com","phone":"+91 80 5555 0201"},{"name":"James Mitchell","title":"Central Ops Owner","email":"james.mitchell@example.com","phone":"+1 555 0200"}]}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111103' AND section_key = 'key_contacts';

UPDATE sq_hub_profiles
SET content_json = '{"content":"<p><strong>Headcount Freeze:</strong> A headcount freeze is in effect for Q1 2025. Four open requisitions are pending budget approval — expected to be released in April 2025. Existing team members are covering critical gaps through overtime (tracked and compensated).</p><p><strong>Facility:</strong> Co-located in the company''s Bangalore office in Whitefield. Current seat allocation is 70; 60 occupied. Shared cafeteria and meeting rooms with other departments.</p><p><strong>Upcoming:</strong> SAP S/4HANA migration scheduled for H2 2025 will require upskilling of the finance team. Training budget approved for 12 team members.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111103' AND section_key = 'notes';

-- ---- Hub 4: Baroda, India (Internal) ----

UPDATE sq_hub_profiles
SET content_json = '{"location":"Baroda (Vadodara), India","type":"Internal","vendor":null,"timezone":"IST (UTC+5:30)","hub_size":"~45 FTE","description":"Internal hub for customer success and operations support. The Baroda hub was established in 2022 to provide cost-effective customer-facing operations and back-office support. The team specializes in customer onboarding, account management support, data processing, and operational analytics. Baroda was chosen for its lower cost base compared to Bangalore while maintaining access to quality talent."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111104' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = '{"tiers":[{"level":"Junior","avg_cost":800,"currency":"USD"},{"level":"Mid","avg_cost":1400,"currency":"USD"},{"level":"Senior","avg_cost":2400,"currency":"USD"},{"level":"Lead","avg_cost":3500,"currency":"USD"}],"last_updated":"2025-01-14","notes":"Internal CTC rates. Baroda offers 15-20% cost savings compared to Bangalore for equivalent roles. This advantage is a key driver for hub expansion."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111104' AND section_key = 'cost_summary';

UPDATE sq_hub_profiles
SET content_json = '{"types_of_work":"<p>Customer onboarding and setup, account management support, data processing and validation, operational analytics and reporting, quality assurance for customer-facing processes, knowledge base and documentation management.</p>","strengths":"<p>Highly cost-effective — 15-20% cheaper than Bangalore for equivalent skill levels. Stable, loyal workforce with low attrition (~7%). Strong work ethic and willingness to work flexible hours. Growing talent pool as Baroda''s service sector expands. Successful campus recruiting pipeline from MS University of Baroda.</p>","weaknesses":"<p>Limited talent pool for specialized roles — senior data analysts and experienced managers often need to be sourced from Ahmedabad or Bangalore, requiring relocation incentives. Ahmedabad (1 hour away) is increasingly drawing talent with its larger market and higher salaries. English communication skills require more development investment compared to Bangalore hires.</p>","talent_market":"<p>Baroda is a Tier-2 city with a developing services sector. Competition for talent is limited compared to metros — main competitors are TCS''s Baroda office and a few mid-size IT companies. MS University of Baroda provides a steady pipeline of commerce and business graduates. Salary inflation is moderate at 6-8% annually. The Ahmedabad market (~100km away) is the primary competitive threat as it offers more career options and higher pay.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111104' AND section_key = 'talent_profile';

UPDATE sq_hub_profiles
SET content_json = '{"requisition":"<p>Requisitions follow the same Workday ATS process as Bangalore internal. For Baroda-specific roles, sourcing includes partnerships with MS University of Baroda and local job fairs. Relocation packages are available for candidates from Ahmedabad and other Gujarat cities (INR 50,000 relocation allowance). Average time-to-fill is 35 business days.</p>","performance":"<p>Same as global annual cycle (Workday). Additional quarterly check-ins are conducted by the Hub Lead for all team members given the smaller team size. High performers are identified for the internal talent mobility program, which offers 6-month assignments at other hubs.</p>","offboarding":"<p>Standard 30-day notice period for all levels. Notice period buyout is generally not offered given the local market conditions. Exit interviews conducted by Hub Lead and HR BP. Knowledge transfer documentation is mandatory and reviewed before clearance.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111104' AND section_key = 'hr_processes';

UPDATE sq_hub_profiles
SET content_json = '{"contacts":[{"name":"Manish Shah","title":"Hub Operations Lead","email":"m.shah@example.com","phone":"+91 265 555 0101"},{"name":"Sneha Patel","title":"HR Business Partner","email":"s.patel@example.com","phone":"+91 265 555 0102"},{"name":"James Mitchell","title":"Central Ops Owner","email":"james.mitchell@example.com","phone":"+1 555 0200"}]}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111104' AND section_key = 'key_contacts';

UPDATE sq_hub_profiles
SET content_json = '{"content":"<p><strong>Campus Recruiting:</strong> Partnership with MS University of Baroda launched in January 2025. First cohort of 6 interns starts in June 2025 with a conversion target of 80%. This pipeline is expected to fill 4-5 Junior roles annually.</p><p><strong>Facility:</strong> Leased office space in Alkapuri, Baroda. Capacity is 60 seats; 45 currently occupied. Lease renewal due in March 2026 — exploring options for a larger space in the IT Park area.</p><p><strong>Growth:</strong> Hub expansion approved for FY2026 — target is to grow from 45 to 70 FTE by December 2025, primarily in customer success and data processing roles.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111104' AND section_key = 'notes';

-- ---- Hub 5: Athens, Greece (Internal) ----

UPDATE sq_hub_profiles
SET content_json = '{"location":"Athens, Greece","type":"Internal","vendor":null,"timezone":"EET (UTC+2) / EEST (UTC+3 summer)","hub_size":"~35 FTE","description":"Internal hub covering EMEA operations and compliance roles. The Athens hub was established in 2023 to provide European-based delivery for regulatory compliance, multilingual customer operations, and EMEA-specific reporting. The hub serves as the center of excellence for GDPR compliance and EU regulatory work. Athens was selected for its multilingual workforce, favorable labor costs compared to Western Europe, and EU membership."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111105' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = '{"tiers":[{"level":"Junior","avg_cost":2200,"currency":"USD"},{"level":"Mid","avg_cost":3400,"currency":"USD"},{"level":"Senior","avg_cost":5000,"currency":"USD"},{"level":"Lead","avg_cost":6800,"currency":"USD"}],"last_updated":"2025-01-08","notes":"Internal EUR-denominated CTC converted to USD at EUR/USD 1.08. Higher than APAC hubs but significantly lower than Western European alternatives (London, Amsterdam, Frankfurt). EU presence provides regulatory and data residency advantages."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111105' AND section_key = 'cost_summary';

UPDATE sq_hub_profiles
SET content_json = '{"types_of_work":"<p>GDPR compliance management and DPO support, EU regulatory reporting, multilingual customer operations (Greek, English, French, German), EMEA financial reporting and consolidation, legal operations support, vendor compliance auditing for European suppliers.</p>","strengths":"<p>Highly multilingual workforce — most team members speak 3+ languages (Greek, English, plus one or more of French, German, Italian, Spanish). Strong compliance and regulatory expertise — team includes certified DPOs and EU regulatory specialists. Located within the EU, enabling compliant processing of EU personal data. Low local competition for this specific skill combination. High employee loyalty and engagement scores.</p>","weaknesses":"<p>Higher cost than APAC hubs — justified by EU presence requirement but impacts budget comparisons. Small local talent pool for very specialized roles (e.g., senior compliance architects). Greek labor law provides strong employee protections which can complicate performance management and offboarding. Seasonal productivity dip during August (vacation culture).</p>","talent_market":"<p>Athens has a limited but high-quality professional services talent pool. The Greek economic recovery has improved talent availability, with many professionals returning from abroad. Competition is limited — few multinational companies have compliance-focused operations in Athens. Main competitors for talent are the Big 4 firms and EU institutions. Salary inflation is moderate at 5-7% annually. The Greek government offers incentives for digital economy roles which benefits recruiting.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111105' AND section_key = 'talent_profile';

UPDATE sq_hub_profiles
SET content_json = '{"requisition":"<p>Requisitions through Workday ATS. Sourcing leverages LinkedIn, Greek professional networks (e.g., ALBA Business School alumni network), and referrals. For multilingual roles, language proficiency is tested during the screening phase (minimum B2 level required for working languages). Average time-to-fill is 45 business days — longer due to the specialized skill requirements.</p>","performance":"<p>Global annual cycle with local adaptations for Greek labor law requirements. Performance reviews must be documented in both English and Greek. Under Greek labor law, negative performance feedback must follow specific procedural requirements. PIPs require consultation with legal counsel. Annual salary adjustments are benchmarked against the Mercer Greece salary survey.</p>","offboarding":"<p>Greek labor law governs all separations. Mandatory notice periods range from 1 month (tenure under 2 years) to 4 months (tenure over 10 years). Severance pay is required for employer-initiated separations — calculated per statutory formula based on tenure and last salary. All termination documentation must comply with Greek labor code Articles 669-670. OAED (Greek labor authority) notification is required within 8 days of separation. Legal review is mandatory for all involuntary separations.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111105' AND section_key = 'hr_processes';

UPDATE sq_hub_profiles
SET content_json = '{"contacts":[{"name":"Dimitris Papadopoulos","title":"EMEA Hub Lead","email":"d.papadopoulos@example.com","phone":"+30 21 0555 0101"},{"name":"Elena Stavropoulou","title":"Legal & Compliance Manager","email":"e.stavropoulou@example.com","phone":"+30 21 0555 0102"},{"name":"Nikos Alexandros","title":"HR Business Partner","email":"n.alexandros@example.com","phone":"+30 21 0555 0103"},{"name":"James Mitchell","title":"Central Ops Owner","email":"james.mitchell@example.com","phone":"+1 555 0200"}]}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111105' AND section_key = 'key_contacts';

UPDATE sq_hub_profiles
SET content_json = '{"content":"<p><strong>GDPR Center of Excellence:</strong> The Athens hub serves as the GDPR compliance center for the entire organization. The team processes all EU data subject requests (DSARs) and manages the Record of Processing Activities (ROPA). Two certified Data Protection Officers are based here.</p><p><strong>Facility:</strong> Modern office space in Maroussi business district (near the former Olympic complex). Capacity is 50 seats; 35 occupied. Excellent public transit access via Metro Line 1.</p><p><strong>EU Regulatory:</strong> The hub is critical for upcoming EU AI Act compliance work starting Q3 2025. Two additional compliance specialists will be needed — change orders to be submitted in Q2.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111105' AND section_key = 'notes';

-- ---- Hub 6: South Africa (Internal) ----

UPDATE sq_hub_profiles
SET content_json = '{"location":"Cape Town, South Africa","type":"Internal","vendor":null,"timezone":"SAST (UTC+2)","hub_size":"~50 FTE","description":"Internal hub for customer-facing operations and data roles. The Cape Town hub was established in 2023 to provide English-first customer operations and growing data analytics capability. The hub leverages South Africa''s strong English proficiency, cultural alignment with UK/US markets, and competitive cost structure. It serves as the primary delivery center for customer success, technical support, and operational data analytics."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111106' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = '{"tiers":[{"level":"Junior","avg_cost":1100,"currency":"USD"},{"level":"Mid","avg_cost":1900,"currency":"USD"},{"level":"Senior","avg_cost":3000,"currency":"USD"},{"level":"Lead","avg_cost":4200,"currency":"USD"}],"last_updated":"2025-01-10","notes":"Internal ZAR-denominated CTC converted to USD at ZAR/USD 18.5. BEE (Broad-Based Black Economic Empowerment) compliance is maintained — current BEE scorecard level 3."}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111106' AND section_key = 'cost_summary';

UPDATE sq_hub_profiles
SET content_json = '{"types_of_work":"<p>Customer success management and onboarding, L1/L2 technical support, operational data analytics and dashboarding (Tableau, Power BI), quality assurance for customer processes, knowledge management and training content development, social media monitoring and response.</p>","strengths":"<p>English-first workforce with neutral accents well-received by UK/US clients. Strong customer service culture and empathy-driven communication skills. Growing data analytics capability — hired 8 data analysts in 2024. Favorable timezone overlap with both Europe (same time) and US East Coast (6-hour overlap). BEE compliance supports client procurement requirements. Competitive cost structure with good value for quality.</p>","weaknesses":"<p>Power instability (load shedding) has historically affected uptime, though generator backup installed Q4 2024 has largely mitigated this. Limited depth of senior data engineering talent — most advanced analytics work still handled by Bangalore. Infrastructure (internet connectivity) is improving but still below Tier-1 city standards. Currency volatility (ZAR) creates budget forecasting challenges.</p>","talent_market":"<p>Cape Town''s talent market is strong for customer-facing and operations roles. Competition comes from Concentrix, Amazon (expanding Cape Town operations), and Capita. Data analytics talent is emerging but still developing — UCT and Stellenbosch graduates are in high demand. BEE requirements influence hiring decisions — maintaining scorecard compliance requires intentional sourcing strategy. Average salary inflation is 6-8% in ZAR terms, but USD-equivalent costs fluctuate with exchange rate.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111106' AND section_key = 'talent_profile';

UPDATE sq_hub_profiles
SET content_json = '{"requisition":"<p>Requisitions through Workday ATS. South African sourcing includes LinkedIn, PNet, CareerJunction, and university partnerships (UCT, Stellenbosch, CPUT). BEE considerations are factored into sourcing strategy to maintain scorecard compliance. Average time-to-fill is 30 business days — faster than other hubs due to shorter notice periods in the local market.</p>","performance":"<p>Global annual cycle with quarterly check-ins added for the South Africa hub. Performance management must comply with South African labour law — the CCMA (Commission for Conciliation, Mediation and Arbitration) governs all workplace disputes. PIPs must follow a fair process (counseling → verbal warning → written warning → final warning) before any separation action. Annual increases are benchmarked against the RemChannel South Africa salary survey.</p>","offboarding":"<p>South African Basic Conditions of Employment Act (BCEA) governs notice periods. Standard notice is 4 weeks for all employees with more than 1 year of tenure. Operational requirements (retrenchment) dismissals require Section 189 consultation process — minimum 30-day consultation period with affected employees. CCMA referrals are common and must be responded to within 30 days. All documentation must be retained for 3 years post-separation per BCEA requirements.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111106' AND section_key = 'hr_processes';

UPDATE sq_hub_profiles
SET content_json = '{"contacts":[{"name":"Thabo Molefe","title":"SA Hub Lead","email":"t.molefe@example.com","phone":"+27 21 555 0101"},{"name":"Zinhle Ndaba","title":"HR Business Partner","email":"z.ndaba@example.com","phone":"+27 21 555 0102"},{"name":"James Mitchell","title":"Central Ops Owner","email":"james.mitchell@example.com","phone":"+1 555 0200"}]}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111106' AND section_key = 'key_contacts';

UPDATE sq_hub_profiles
SET content_json = '{"content":"<p><strong>Load Shedding Mitigation:</strong> 100kVA generator backup was installed in Q4 2024. Starlink satellite internet was added as backup connectivity in January 2025. Since these installations, uptime has been 99.7% — up from 94% in H1 2024. UPS systems protect all workstations.</p><p><strong>BEE Compliance:</strong> Current BEE scorecard is Level 3. Target is Level 2 by December 2025. Skills development spend is tracking above target (3.2% of payroll vs 3% target). Enterprise development program launched with 2 local SME partners.</p><p><strong>Growth:</strong> Hub expansion from 50 to 75 FTE approved for FY2026, focused on data analytics and customer success roles. Office expansion to additional floor is planned for Q3 2025.</p>"}'::jsonb
WHERE hub_id = '11111111-1111-1111-1111-111111111106' AND section_key = 'notes';


-- ============================================================
-- 2. INSERT SOW Clauses (sq_sow_clauses)
-- ============================================================

-- Contract 1: Vendor C (SOW-2024-001)
INSERT INTO sq_sow_clauses (contract_id, clause_type, description, threshold_value, threshold_unit, notice_period_days, cost_impact, is_active)
VALUES
  ('55555555-5555-5555-5555-555555550101', 'minimum_volume',
   'Minimum volume commitment: if headcount drops below 80% of contracted baseline (96 FTE), a penalty fee of 5% of the monthly invoice total applies. This clause protects Vendor C''s investment in dedicated infrastructure and recruiting capacity.',
   96, 'FTE', 60, 5.0, true),
  ('55555555-5555-5555-5555-555555550101', 'ramp_up',
   'Ramp-up clause: if headcount increases by more than 15% within any 30-day period, the applicable rate card increases by 3% for the incremental headcount for the first 6 months. This reflects Vendor C''s increased recruiting and onboarding costs for rapid scaling.',
   15, 'percent', 30, 3.0, true),
  ('55555555-5555-5555-5555-555555550101', 'reduction',
   'Reduction clause: reductions exceeding 10 FTE within any 60-day period require 45 calendar days written notice to Vendor C. Failure to provide adequate notice results in an early termination fee equal to 1 month''s fully loaded cost per reduced FTE. This clause ensures Vendor C can manage workforce transitions responsibly.',
   10, 'FTE', 45, 100.0, true);

-- Contract 2: Vendor G (SOW-2024-002)
INSERT INTO sq_sow_clauses (contract_id, clause_type, description, threshold_value, threshold_unit, notice_period_days, cost_impact, is_active)
VALUES
  ('55555555-5555-5555-5555-555555550201', 'minimum_volume',
   'Minimum volume commitment: headcount must remain above 75% of contracted baseline (71 FTE). If headcount drops below this threshold for two consecutive months, a standby fee of 8% of the monthly invoice applies. Vendor G maintains dedicated project infrastructure and bench resources that require minimum utilization.',
   71, 'FTE', 60, 8.0, true),
  ('55555555-5555-5555-5555-555555550201', 'ramp_up',
   'Ramp-up clause: if headcount increases by more than 20% in any 30-day period, Vendor G may invoke a temporary rate increase of 5% for the incremental headcount for up to 3 months. Accelerated hiring requires premium sourcing channels and expedited onboarding.',
   20, 'percent', 30, 5.0, true),
  ('55555555-5555-5555-5555-555555550201', 'ip_and_transition',
   'IP and transition clause: upon contract termination or non-renewal, a 90-day transition period is required during which Vendor G will facilitate knowledge transfer, code repository handover, and documentation. Transition services are billed at 75% of the applicable rate card. All intellectual property developed during the engagement is owned by the client.',
   90, 'days', 90, 75.0, true);


-- ============================================================
-- 3. INSERT Invoice Reminders (sq_invoice_reminders)
-- ============================================================

INSERT INTO sq_invoice_reminders (invoice_id, sent_to, reminder_type, sent_at)
VALUES
  ('66666666-6666-6666-6666-666666660101', '22222222-2222-2222-2222-222222222201', 'initial_notification', '2024-11-02T09:00:00Z'),
  ('66666666-6666-6666-6666-666666660101', '22222222-2222-2222-2222-222222222201', 'follow_up', '2024-11-27T09:00:00Z'),
  ('66666666-6666-6666-6666-666666660201', '22222222-2222-2222-2222-222222222203', 'initial_notification', '2024-11-16T09:00:00Z'),
  ('66666666-6666-6666-6666-666666660201', '22222222-2222-2222-2222-222222222203', 'follow_up', '2024-12-12T09:00:00Z');

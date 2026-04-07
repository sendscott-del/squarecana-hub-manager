-- Update hub sizes in hub profile overviews

-- Bogota: 150 FTEs
UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{hub_size}', '"~150 FTE"')
WHERE hub_id = '11111111-1111-1111-1111-111111111101' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{description}', '"Primary operations and analytics hub for Latin America coverage. Vendor C manages day-to-day operations including recruiting, onboarding, and performance management. The hub serves as the anchor delivery center for all LATAM-facing processes including financial reconciliation, data entry, and customer operations support. Established in 2021, the hub has grown steadily to 150 FTEs."')
WHERE hub_id = '11111111-1111-1111-1111-111111111101' AND section_key = 'overview';

-- Bangalore Vendor: 800 FTEs
UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{hub_size}', '"~800 FTE"')
WHERE hub_id = '11111111-1111-1111-1111-111111111102' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{description}', '"Largest hub in the global delivery network. Vendor G provides end-to-end delivery management for software development, QA, data engineering, and technical support functions. The hub handles critical platform development work including the payment processing system and business intelligence infrastructure. Established in 2022, the hub has scaled rapidly to 800 FTEs as the primary hub for technology and data roles."')
WHERE hub_id = '11111111-1111-1111-1111-111111111102' AND section_key = 'overview';

-- Bangalore Internal: 50 FTEs
UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{hub_size}', '"~50 FTE"')
WHERE hub_id = '11111111-1111-1111-1111-111111111103' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{description}', '"Internal team focused on finance operations and HR shared services. This hub handles core back-office functions including accounts payable/receivable, payroll processing, financial reporting, and HR operations support. Established in 2022 as part of the global shared services strategy. Team of 50 FTEs operates under direct management with no vendor intermediary."')
WHERE hub_id = '11111111-1111-1111-1111-111111111103' AND section_key = 'overview';

-- Baroda: 100 FTEs
UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{hub_size}', '"~100 FTE"')
WHERE hub_id = '11111111-1111-1111-1111-111111111104' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{description}', '"Internal hub for customer success and operations support. The Baroda hub was established in 2022 to provide cost-effective customer-facing operations and back-office support. The team of 100 FTEs specializes in customer onboarding, account management support, data processing, and operational analytics. Baroda was chosen for its lower cost base compared to Bangalore while maintaining access to quality talent."')
WHERE hub_id = '11111111-1111-1111-1111-111111111104' AND section_key = 'overview';

-- Athens: 300 FTEs
UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{hub_size}', '"~300 FTE"')
WHERE hub_id = '11111111-1111-1111-1111-111111111105' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{description}', '"Largest European hub covering EMEA operations and compliance roles. The Athens hub was established in 2023 and has grown to 300 FTEs providing European-based delivery for regulatory compliance, multilingual customer operations, and EMEA-specific reporting. The hub serves as the center of excellence for GDPR compliance and EU regulatory work. Athens was selected for its multilingual workforce, favorable labor costs compared to Western Europe, and EU membership."')
WHERE hub_id = '11111111-1111-1111-1111-111111111105' AND section_key = 'overview';

-- South Africa: 100 FTEs
UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{hub_size}', '"~100 FTE"')
WHERE hub_id = '11111111-1111-1111-1111-111111111106' AND section_key = 'overview';

UPDATE sq_hub_profiles
SET content_json = jsonb_set(content_json, '{description}', '"Internal hub for customer-facing operations and data roles. The Cape Town hub was established in 2023 and has grown to 100 FTEs providing English-first customer operations and growing data analytics capability. The hub leverages South Africa''s strong English proficiency, cultural alignment with UK/US markets, and competitive cost structure. It serves as the primary delivery center for customer success, technical support, and operational data analytics."')
WHERE hub_id = '11111111-1111-1111-1111-111111111106' AND section_key = 'overview';

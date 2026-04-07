-- =============================================================================
-- Squarecana Talent Hub Manager - Complete Database Schema
-- All tables prefixed with sq_ to avoid conflicts
-- =============================================================================

-- ============================================================
-- TABLES (ordered by dependency)
-- ============================================================

-- 1. sq_settings
CREATE TABLE sq_settings (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  key        text        UNIQUE NOT NULL,
  value      text,
  updated_at timestamptz DEFAULT now()
);

-- 2. sq_hubs (must exist before sq_users)
CREATE TABLE sq_hubs (
  id               uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name             text        NOT NULL,
  location_city    text,
  location_country text,
  hub_type         text        CHECK (hub_type IN ('vendor', 'internal')),
  vendor_name      text,
  is_active        boolean     DEFAULT true,
  created_at       timestamptz DEFAULT now()
);

-- 3. sq_users
CREATE TABLE sq_users (
  id         uuid        PRIMARY KEY REFERENCES auth.users,
  email      text        NOT NULL,
  full_name  text,
  role       text        CHECK (role IN ('functional_leader', 'central_ops', 'hub_leader', 'executive')),
  hub_id     uuid        REFERENCES sq_hubs,
  is_admin   boolean     DEFAULT false,
  status     text        CHECK (status IN ('pending', 'active', 'inactive')) DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

-- 4. sq_hub_profiles
CREATE TABLE sq_hub_profiles (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  hub_id       uuid        REFERENCES sq_hubs NOT NULL,
  section_key  text        CHECK (section_key IN ('overview', 'cost_summary', 'talent_profile', 'hr_processes', 'key_contacts', 'notes')) NOT NULL,
  content_json jsonb,
  updated_by   uuid        REFERENCES sq_users,
  updated_at   timestamptz DEFAULT now(),
  UNIQUE (hub_id, section_key)
);

-- 5. sq_headcount
CREATE TABLE sq_headcount (
  id                      uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  hub_id                  uuid        REFERENCES sq_hubs NOT NULL,
  employee_name           text,
  role_title              text,
  role_type               text,
  department              text,
  function_area           text,
  country_leader_user_id  uuid        REFERENCES sq_users,
  status                  text        CHECK (status IN ('active', 'open', 'closed')) DEFAULT 'active',
  start_date              date,
  end_date                date,
  cost_per_month          numeric,
  notes                   text,
  created_at              timestamptz DEFAULT now()
);

-- 6. sq_change_orders
CREATE TABLE sq_change_orders (
  id                   uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  hub_id               uuid        REFERENCES sq_hubs NOT NULL,
  submitted_by_user_id uuid        REFERENCES sq_users,
  title                text        NOT NULL,
  description          text,
  change_type          text        CHECK (change_type IN ('add', 'remove', 'modify')),
  headcount_id         uuid        REFERENCES sq_headcount,
  status               text        CHECK (status IN ('draft', 'submitted', 'under_review', 'approved', 'rejected')) DEFAULT 'draft',
  reviewer_user_id     uuid        REFERENCES sq_users,
  review_notes         text,
  submitted_at         timestamptz,
  reviewed_at          timestamptz,
  created_at           timestamptz DEFAULT now()
);

-- 7. sq_contracts
CREATE TABLE sq_contracts (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  hub_id       uuid        REFERENCES sq_hubs NOT NULL,
  sow_number   text,
  vendor_name  text,
  start_date   date,
  end_date     date,
  total_value  numeric,
  currency     text        DEFAULT 'USD',
  document_url text,
  access_level text        CHECK (access_level IN ('restricted', 'standard')) DEFAULT 'standard',
  created_by   uuid        REFERENCES sq_users,
  created_at   timestamptz DEFAULT now()
);

-- 8. sq_sow_clauses
CREATE TABLE sq_sow_clauses (
  id                uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id       uuid        REFERENCES sq_contracts NOT NULL,
  clause_type       text,
  description       text,
  threshold_value   numeric,
  threshold_unit    text,
  notice_period_days integer,
  cost_impact       numeric,
  is_active         boolean     DEFAULT true,
  created_at        timestamptz DEFAULT now()
);

-- 9. sq_invoices
CREATE TABLE sq_invoices (
  id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  hub_id         uuid        REFERENCES sq_hubs NOT NULL,
  vendor_name    text,
  invoice_number text,
  invoice_date   date,
  due_date       date,
  total_amount   numeric,
  currency       text        DEFAULT 'USD',
  status         text        CHECK (status IN ('pending', 'in_review', 'approved', 'rejected', 'paid')) DEFAULT 'pending',
  submitted_by   uuid        REFERENCES sq_users,
  created_at     timestamptz DEFAULT now()
);

-- 10. sq_invoice_line_items
CREATE TABLE sq_invoice_line_items (
  id                  uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id          uuid        REFERENCES sq_invoices NOT NULL,
  employee_name       text,
  role_title          text,
  days_worked         numeric,
  rate                numeric,
  amount              numeric,
  approved_by_user_id uuid        REFERENCES sq_users,
  approval_status     text        CHECK (approval_status IN ('pending', 'approved', 'disputed')) DEFAULT 'pending',
  approval_note       text,
  created_at          timestamptz DEFAULT now()
);

-- 11. sq_invoice_reminders
CREATE TABLE sq_invoice_reminders (
  id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id      uuid        REFERENCES sq_invoices NOT NULL,
  sent_to_user_id uuid        REFERENCES sq_users,
  sent_at         timestamptz DEFAULT now(),
  reminder_type   text
);

-- 12. sq_release_notes
CREATE TABLE sq_release_notes (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  version      text        NOT NULL,
  release_date date        NOT NULL,
  features     jsonb,
  bug_fixes    jsonb,
  created_at   timestamptz DEFAULT now()
);

-- 13. sq_user_guide_sections
CREATE TABLE sq_user_guide_sections (
  id               uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  section_order    integer     NOT NULL,
  title            text        NOT NULL,
  content_markdown text,
  updated_at       timestamptz DEFAULT now()
);


-- ============================================================
-- INDEXES
-- ============================================================

-- sq_users
CREATE INDEX idx_sq_users_hub_id   ON sq_users (hub_id);
CREATE INDEX idx_sq_users_role     ON sq_users (role);
CREATE INDEX idx_sq_users_status   ON sq_users (status);
CREATE INDEX idx_sq_users_email    ON sq_users (email);

-- sq_hub_profiles
CREATE INDEX idx_sq_hub_profiles_hub_id ON sq_hub_profiles (hub_id);

-- sq_headcount
CREATE INDEX idx_sq_headcount_hub_id                 ON sq_headcount (hub_id);
CREATE INDEX idx_sq_headcount_status                 ON sq_headcount (status);
CREATE INDEX idx_sq_headcount_country_leader_user_id ON sq_headcount (country_leader_user_id);
CREATE INDEX idx_sq_headcount_department             ON sq_headcount (department);
CREATE INDEX idx_sq_headcount_function_area          ON sq_headcount (function_area);

-- sq_change_orders
CREATE INDEX idx_sq_change_orders_hub_id               ON sq_change_orders (hub_id);
CREATE INDEX idx_sq_change_orders_submitted_by_user_id ON sq_change_orders (submitted_by_user_id);
CREATE INDEX idx_sq_change_orders_status               ON sq_change_orders (status);
CREATE INDEX idx_sq_change_orders_headcount_id         ON sq_change_orders (headcount_id);
CREATE INDEX idx_sq_change_orders_reviewer_user_id     ON sq_change_orders (reviewer_user_id);

-- sq_contracts
CREATE INDEX idx_sq_contracts_hub_id       ON sq_contracts (hub_id);
CREATE INDEX idx_sq_contracts_access_level ON sq_contracts (access_level);
CREATE INDEX idx_sq_contracts_created_by   ON sq_contracts (created_by);

-- sq_sow_clauses
CREATE INDEX idx_sq_sow_clauses_contract_id ON sq_sow_clauses (contract_id);

-- sq_invoices
CREATE INDEX idx_sq_invoices_hub_id       ON sq_invoices (hub_id);
CREATE INDEX idx_sq_invoices_status       ON sq_invoices (status);
CREATE INDEX idx_sq_invoices_submitted_by ON sq_invoices (submitted_by);

-- sq_invoice_line_items
CREATE INDEX idx_sq_invoice_line_items_invoice_id          ON sq_invoice_line_items (invoice_id);
CREATE INDEX idx_sq_invoice_line_items_approved_by_user_id ON sq_invoice_line_items (approved_by_user_id);
CREATE INDEX idx_sq_invoice_line_items_approval_status     ON sq_invoice_line_items (approval_status);

-- sq_invoice_reminders
CREATE INDEX idx_sq_invoice_reminders_invoice_id      ON sq_invoice_reminders (invoice_id);
CREATE INDEX idx_sq_invoice_reminders_sent_to_user_id ON sq_invoice_reminders (sent_to_user_id);

-- sq_user_guide_sections
CREATE INDEX idx_sq_user_guide_sections_order ON sq_user_guide_sections (section_order);


-- ============================================================
-- HELPER FUNCTIONS (used by RLS policies)
-- Must be created after tables exist
-- ============================================================

CREATE OR REPLACE FUNCTION get_user_role()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT role FROM sq_users WHERE id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    (SELECT is_admin FROM sq_users WHERE id = auth.uid() AND status = 'active'),
    false
  );
$$;

CREATE OR REPLACE FUNCTION get_user_hub_id()
RETURNS uuid
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT hub_id FROM sq_users WHERE id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION get_user_status()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT status FROM sq_users WHERE id = auth.uid();
$$;


-- ============================================================
-- ENABLE ROW LEVEL SECURITY ON ALL TABLES
-- ============================================================

ALTER TABLE sq_settings            ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_hubs                ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_users               ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_hub_profiles        ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_headcount           ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_change_orders       ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_contracts           ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_sow_clauses         ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_invoices            ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_invoice_line_items  ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_invoice_reminders   ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_release_notes       ENABLE ROW LEVEL SECURITY;
ALTER TABLE sq_user_guide_sections ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- RLS POLICIES
-- ============================================================

-- ----------------------------------------------------------
-- sq_settings: all authenticated read, admin insert/update
-- ----------------------------------------------------------
CREATE POLICY "sq_settings: authenticated read"
  ON sq_settings FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "sq_settings: admin insert"
  ON sq_settings FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "sq_settings: admin update"
  ON sq_settings FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_users
-- ----------------------------------------------------------
CREATE POLICY "sq_users: read own record"
  ON sq_users FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "sq_users: admin read all"
  ON sq_users FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "sq_users: admin update all"
  ON sq_users FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "sq_users: authenticated insert (self-registration)"
  ON sq_users FOR INSERT
  TO authenticated
  WITH CHECK (id = auth.uid());

-- ----------------------------------------------------------
-- sq_hubs: active authenticated read, central_ops/admin update
-- ----------------------------------------------------------
CREATE POLICY "sq_hubs: active users read"
  ON sq_hubs FOR SELECT
  TO authenticated
  USING (get_user_status() = 'active');

CREATE POLICY "sq_hubs: central_ops update"
  ON sq_hubs FOR UPDATE
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active')
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_hubs: admin update"
  ON sq_hubs FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "sq_hubs: central_ops insert"
  ON sq_hubs FOR INSERT
  TO authenticated
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_hubs: admin insert"
  ON sq_hubs FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_hub_profiles
-- ----------------------------------------------------------
CREATE POLICY "sq_hub_profiles: active users read"
  ON sq_hub_profiles FOR SELECT
  TO authenticated
  USING (get_user_status() = 'active');

CREATE POLICY "sq_hub_profiles: central_ops update"
  ON sq_hub_profiles FOR UPDATE
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active')
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_hub_profiles: hub_leader update own hub"
  ON sq_hub_profiles FOR UPDATE
  TO authenticated
  USING (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  )
  WITH CHECK (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  );

CREATE POLICY "sq_hub_profiles: central_ops insert"
  ON sq_hub_profiles FOR INSERT
  TO authenticated
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_hub_profiles: admin full access"
  ON sq_hub_profiles FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_headcount
-- ----------------------------------------------------------
CREATE POLICY "sq_headcount: active users read"
  ON sq_headcount FOR SELECT
  TO authenticated
  USING (get_user_status() = 'active');

CREATE POLICY "sq_headcount: central_ops full access"
  ON sq_headcount FOR ALL
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active')
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_headcount: hub_leader read own hub"
  ON sq_headcount FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  );

CREATE POLICY "sq_headcount: hub_leader update own hub"
  ON sq_headcount FOR UPDATE
  TO authenticated
  USING (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  )
  WITH CHECK (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  );

CREATE POLICY "sq_headcount: admin full access"
  ON sq_headcount FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_change_orders
-- ----------------------------------------------------------
CREATE POLICY "sq_change_orders: central_ops read all"
  ON sq_change_orders FOR SELECT
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_change_orders: functional_leader read own"
  ON sq_change_orders FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'functional_leader'
    AND get_user_status() = 'active'
    AND submitted_by_user_id = auth.uid()
  );

CREATE POLICY "sq_change_orders: hub_leader read own hub"
  ON sq_change_orders FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  );

CREATE POLICY "sq_change_orders: functional_leader insert"
  ON sq_change_orders FOR INSERT
  TO authenticated
  WITH CHECK (
    get_user_role() = 'functional_leader'
    AND get_user_status() = 'active'
    AND submitted_by_user_id = auth.uid()
  );

CREATE POLICY "sq_change_orders: hub_leader insert"
  ON sq_change_orders FOR INSERT
  TO authenticated
  WITH CHECK (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  );

CREATE POLICY "sq_change_orders: central_ops update"
  ON sq_change_orders FOR UPDATE
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active')
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_change_orders: admin full access"
  ON sq_change_orders FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_contracts
-- ----------------------------------------------------------
CREATE POLICY "sq_contracts: central_ops full access"
  ON sq_contracts FOR ALL
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active')
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_contracts: functional_leader read standard"
  ON sq_contracts FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'functional_leader'
    AND get_user_status() = 'active'
    AND access_level = 'standard'
  );

CREATE POLICY "sq_contracts: hub_leader read standard"
  ON sq_contracts FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND access_level = 'standard'
  );

CREATE POLICY "sq_contracts: executive read all"
  ON sq_contracts FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'executive'
    AND get_user_status() = 'active'
  );

CREATE POLICY "sq_contracts: admin full access"
  ON sq_contracts FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_sow_clauses (same access as sq_contracts)
-- ----------------------------------------------------------
CREATE POLICY "sq_sow_clauses: central_ops full access"
  ON sq_sow_clauses FOR ALL
  TO authenticated
  USING (
    get_user_role() = 'central_ops'
    AND get_user_status() = 'active'
  )
  WITH CHECK (
    get_user_role() = 'central_ops'
    AND get_user_status() = 'active'
  );

CREATE POLICY "sq_sow_clauses: functional_leader read standard"
  ON sq_sow_clauses FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'functional_leader'
    AND get_user_status() = 'active'
    AND EXISTS (
      SELECT 1 FROM sq_contracts c
      WHERE c.id = sq_sow_clauses.contract_id
        AND c.access_level = 'standard'
    )
  );

CREATE POLICY "sq_sow_clauses: hub_leader read standard"
  ON sq_sow_clauses FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND EXISTS (
      SELECT 1 FROM sq_contracts c
      WHERE c.id = sq_sow_clauses.contract_id
        AND c.access_level = 'standard'
    )
  );

CREATE POLICY "sq_sow_clauses: executive read all"
  ON sq_sow_clauses FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'executive'
    AND get_user_status() = 'active'
  );

CREATE POLICY "sq_sow_clauses: admin full access"
  ON sq_sow_clauses FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_invoices
-- ----------------------------------------------------------
CREATE POLICY "sq_invoices: central_ops full access"
  ON sq_invoices FOR ALL
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active')
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_invoices: hub_leader CRUD own hub"
  ON sq_invoices FOR ALL
  TO authenticated
  USING (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  )
  WITH CHECK (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND hub_id = get_user_hub_id()
  );

CREATE POLICY "sq_invoices: functional_leader read as approver"
  ON sq_invoices FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'functional_leader'
    AND get_user_status() = 'active'
    AND EXISTS (
      SELECT 1 FROM sq_invoice_line_items li
      WHERE li.invoice_id = sq_invoices.id
        AND li.approved_by_user_id = auth.uid()
    )
  );

CREATE POLICY "sq_invoices: admin full access"
  ON sq_invoices FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_invoice_line_items
-- ----------------------------------------------------------
CREATE POLICY "sq_invoice_line_items: central_ops full access"
  ON sq_invoice_line_items FOR ALL
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active')
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_invoice_line_items: hub_leader CRUD own hub"
  ON sq_invoice_line_items FOR ALL
  TO authenticated
  USING (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND EXISTS (
      SELECT 1 FROM sq_invoices inv
      WHERE inv.id = sq_invoice_line_items.invoice_id
        AND inv.hub_id = get_user_hub_id()
    )
  )
  WITH CHECK (
    get_user_role() = 'hub_leader'
    AND get_user_status() = 'active'
    AND EXISTS (
      SELECT 1 FROM sq_invoices inv
      WHERE inv.id = sq_invoice_line_items.invoice_id
        AND inv.hub_id = get_user_hub_id()
    )
  );

CREATE POLICY "sq_invoice_line_items: functional_leader read as approver"
  ON sq_invoice_line_items FOR SELECT
  TO authenticated
  USING (
    get_user_role() = 'functional_leader'
    AND get_user_status() = 'active'
    AND approved_by_user_id = auth.uid()
  );

CREATE POLICY "sq_invoice_line_items: functional_leader update as approver"
  ON sq_invoice_line_items FOR UPDATE
  TO authenticated
  USING (
    get_user_role() = 'functional_leader'
    AND get_user_status() = 'active'
    AND approved_by_user_id = auth.uid()
  )
  WITH CHECK (
    get_user_role() = 'functional_leader'
    AND get_user_status() = 'active'
    AND approved_by_user_id = auth.uid()
  );

CREATE POLICY "sq_invoice_line_items: admin full access"
  ON sq_invoice_line_items FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_invoice_reminders
-- ----------------------------------------------------------
CREATE POLICY "sq_invoice_reminders: central_ops full access"
  ON sq_invoice_reminders FOR ALL
  TO authenticated
  USING (get_user_role() = 'central_ops' AND get_user_status() = 'active')
  WITH CHECK (get_user_role() = 'central_ops' AND get_user_status() = 'active');

CREATE POLICY "sq_invoice_reminders: admin full access"
  ON sq_invoice_reminders FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "sq_invoice_reminders: user read own"
  ON sq_invoice_reminders FOR SELECT
  TO authenticated
  USING (sent_to_user_id = auth.uid());

-- ----------------------------------------------------------
-- sq_release_notes: all authenticated read, admin insert/update
-- ----------------------------------------------------------
CREATE POLICY "sq_release_notes: authenticated read"
  ON sq_release_notes FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "sq_release_notes: admin insert"
  ON sq_release_notes FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "sq_release_notes: admin update"
  ON sq_release_notes FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ----------------------------------------------------------
-- sq_user_guide_sections: all authenticated read, admin insert/update
-- ----------------------------------------------------------
CREATE POLICY "sq_user_guide_sections: authenticated read"
  ON sq_user_guide_sections FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "sq_user_guide_sections: admin insert"
  ON sq_user_guide_sections FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "sq_user_guide_sections: admin update"
  ON sq_user_guide_sections FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());


-- ============================================================
-- AUTO-CREATE sq_users RECORD ON AUTH SIGNUP
-- ============================================================

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO sq_users (id, email, status)
  VALUES (
    NEW.id,
    COALESCE(NEW.email, ''),
    'pending'
  );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

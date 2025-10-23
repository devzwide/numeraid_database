-- =====================================================
-- MIGRATION: V2__secure_user_schema_upgrade.sql
-- PURPOSE: Add tighter constraints, improved data integrity, and indexes
-- =====================================================

-- 1. Function to ensure updated_at auto-refreshes (recreate safely)
CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- STEP 2: Update "user" table safely
-- =====================================================

-- Ensure role constraint is strict and consistent
ALTER TABLE "user"
    DROP CONSTRAINT IF EXISTS "user_role_check",
    ADD CONSTRAINT "user_role_check" CHECK (role IN ('student', 'staff', 'admin'));

-- Enforce non-null values on critical fields
ALTER TABLE "user"
    ALTER COLUMN role SET NOT NULL,
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN surname SET NOT NULL;

-- Ensure created_at and updated_at have consistent defaults
ALTER TABLE "user"
    ALTER COLUMN created_at SET DEFAULT CURRENT_TIMESTAMP,
    ALTER COLUMN updated_at SET DEFAULT CURRENT_TIMESTAMP;

-- Add safety index if missing
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_email') THEN
            CREATE INDEX idx_user_email ON "user"(email);
        END IF;
    END $$;

-- =====================================================
-- STEP 3: Staff table adjustments
-- =====================================================
ALTER TABLE staff
    ALTER COLUMN created_at SET DEFAULT CURRENT_TIMESTAMP,
    ALTER COLUMN updated_at SET DEFAULT CURRENT_TIMESTAMP;

DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_staff_department') THEN
            CREATE INDEX idx_staff_department ON staff(department);
        END IF;
    END $$;

-- =====================================================
-- STEP 4: Student table adjustments
-- =====================================================
ALTER TABLE student
    ALTER COLUMN faculty SET NOT NULL,
    ALTER COLUMN course SET NOT NULL,
    ALTER COLUMN created_at SET DEFAULT CURRENT_TIMESTAMP,
    ALTER COLUMN updated_at SET DEFAULT CURRENT_TIMESTAMP;

DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_student_course') THEN
            CREATE INDEX idx_student_course ON student(course);
        END IF;
    END $$;

-- =====================================================
-- STEP 5: Recreate triggers to ensure they are consistent
-- =====================================================
DROP TRIGGER IF EXISTS update_user_updated_at ON "user";
CREATE TRIGGER update_user_updated_at
    BEFORE UPDATE ON "user"
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_staff_updated_at ON staff;
CREATE TRIGGER update_staff_updated_at
    BEFORE UPDATE ON staff
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_student_updated_at ON student;
CREATE TRIGGER update_student_updated_at
    BEFORE UPDATE ON student
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- END OF MIGRATION
-- =====================================================

CREATE TABLE "user" (
                        user_id SERIAL PRIMARY KEY,
                        email VARCHAR(120) UNIQUE NOT NULL,
                        username VARCHAR(100) UNIQUE,
                        password_hash VARCHAR(255) NOT NULL,
                        name VARCHAR(100) NOT NULL,
                        surname VARCHAR(100) NOT NULL,
                        role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'staff', 'admin')),
                        is_active BOOLEAN DEFAULT TRUE,
                        consent_given BOOLEAN DEFAULT FALSE,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        last_login TIMESTAMP NULL
);

CREATE TABLE staff (
                       staff_id INT PRIMARY KEY,
                       department VARCHAR(100),
                       feedback TEXT,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (staff_id) REFERENCES "user"(user_id) ON DELETE CASCADE
);

CREATE TABLE student (
                         student_id INT PRIMARY KEY,
                         faculty VARCHAR(100) NOT NULL,
                         course VARCHAR(100) NOT NULL,
                         year_of_study INT,
                         medical_proof_path VARCHAR(255),
                         application_status VARCHAR(50) DEFAULT 'Pending',
                         has_completed_onboarding BOOLEAN DEFAULT FALSE,
                         feedback TEXT,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (student_id) REFERENCES "user"(user_id) ON DELETE CASCADE
);

-- Indexes for fast lookups
CREATE INDEX idx_user_email ON "user"(email);
CREATE INDEX idx_user_username ON "user"(username);
CREATE INDEX idx_staff_department ON staff(department);
CREATE INDEX idx_student_course ON student(course);
CREATE INDEX idx_user_role ON "user"(role);

ALTER TABLE "user"
    ALTER COLUMN password_hash DROP NOT NULL,
    ALTER COLUMN username DROP NOT NULL,
    ADD COLUMN social_provider_id VARCHAR(255) UNIQUE NULL,
    ADD COLUMN social_provider VARCHAR(50) NULL;

CREATE INDEX idx_user_social_id ON "user"(social_provider_id);

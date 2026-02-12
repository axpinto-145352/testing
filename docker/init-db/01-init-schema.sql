-- Gap Analysis Tool - Database Schema
-- This script initializes the gap_analysis database with all required tables

-- Create gap_analysis database if running in single-db mode
-- (In multi-db mode, this is created by Docker entrypoint)

-- =============================================================================
-- CORE TABLES
-- =============================================================================

-- User roster with demographics
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(64) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    experience_years INTEGER DEFAULT 0,
    org_type VARCHAR(50), -- contractor, FBI, federal, military
    current_status VARCHAR(50), -- active_duty, contractor, federal
    sub_working_group VARCHAR(100),
    affiliations TEXT,
    skill_sets TEXT,
    demographics_complete BOOLEAN DEFAULT FALSE,
    demographics_date TIMESTAMPTZ,
    last_survey_date TIMESTAMPTZ,
    last_reminder_sent TIMESTAMPTZ,
    send_reminder BOOLEAN DEFAULT TRUE,
    reminder_schedule_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Survey configuration
CREATE TABLE IF NOT EXISTS surveys (
    id SERIAL PRIMARY KEY,
    survey_id VARCHAR(64) UNIQUE NOT NULL,
    survey_name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'scheduled', -- scheduled, active, closed
    target_groups TEXT, -- comma-separated list or 'ALL'
    form_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Gap definitions
CREATE TABLE IF NOT EXISTS gap_definitions (
    id SERIAL PRIMARY KEY,
    gap_id VARCHAR(64) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    factor VARCHAR(100),
    description TEXT,
    owner_group VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Survey responses (Likert 1-7)
CREATE TABLE IF NOT EXISTS survey_responses (
    id SERIAL PRIMARY KEY,
    submission_id UUID NOT NULL, -- For idempotency
    username VARCHAR(64) NOT NULL REFERENCES users(username),
    survey_id VARCHAR(64) NOT NULL REFERENCES surveys(survey_id),
    gap_id VARCHAR(64) NOT NULL REFERENCES gap_definitions(gap_id),
    score INTEGER NOT NULL CHECK (score >= 1 AND score <= 7),
    sub_working_group VARCHAR(100),
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    ip_hash VARCHAR(64), -- Hashed IP for audit
    UNIQUE(username, survey_id, gap_id) -- Prevent duplicate submissions
);

-- Demographics submissions (separate from users for audit trail)
CREATE TABLE IF NOT EXISTS demographics_submissions (
    id SERIAL PRIMARY KEY,
    submission_id UUID NOT NULL,
    username VARCHAR(64) NOT NULL REFERENCES users(username),
    experience_years INTEGER,
    org_type VARCHAR(50),
    current_status VARCHAR(50),
    sub_working_group VARCHAR(100),
    affiliations TEXT,
    skill_sets TEXT,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    ip_hash VARCHAR(64)
);

-- =============================================================================
-- ANALYTICS TABLES (Computed/Cached)
-- =============================================================================

-- Gap rankings (refreshed by analytics workflow)
CREATE TABLE IF NOT EXISTS analytics_gap_rankings (
    id SERIAL PRIMARY KEY,
    survey_id VARCHAR(64),
    gap_id VARCHAR(64),
    gap_name VARCHAR(255),
    category VARCHAR(100),
    factor VARCHAR(100),
    response_count INTEGER,
    mean_score DECIMAL(4,2),
    nps_score INTEGER,
    pct_1 DECIMAL(5,2),
    pct_2 DECIMAL(5,2),
    pct_3 DECIMAL(5,2),
    pct_4 DECIMAL(5,2),
    pct_5 DECIMAL(5,2),
    pct_6 DECIMAL(5,2),
    pct_7 DECIMAL(5,2),
    computed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Factor summary (refreshed by analytics workflow)
CREATE TABLE IF NOT EXISTS analytics_factor_summary (
    id SERIAL PRIMARY KEY,
    survey_id VARCHAR(64),
    factor VARCHAR(100),
    response_count INTEGER,
    mean_score DECIMAL(4,2),
    nps_score INTEGER,
    pct_1 DECIMAL(5,2),
    pct_2 DECIMAL(5,2),
    pct_3 DECIMAL(5,2),
    pct_4 DECIMAL(5,2),
    pct_5 DECIMAL(5,2),
    pct_6 DECIMAL(5,2),
    pct_7 DECIMAL(5,2),
    computed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Dashboard summary (refreshed by analytics workflow)
CREATE TABLE IF NOT EXISTS analytics_dashboard (
    id SERIAL PRIMARY KEY,
    survey_id VARCHAR(64),
    total_responses INTEGER,
    unique_respondents INTEGER,
    response_rate DECIMAL(5,2),
    top_critical_gaps JSONB,
    factor_overview JSONB,
    group_breakdown JSONB,
    computed_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- AUDIT LOG
-- =============================================================================

CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL, -- submission, login, export, etc.
    username VARCHAR(64),
    entity_type VARCHAR(50), -- survey, user, gap, etc.
    entity_id VARCHAR(64),
    action VARCHAR(50), -- create, update, delete, view
    details JSONB,
    ip_hash VARCHAR(64),
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_survey_responses_username ON survey_responses(username);
CREATE INDEX IF NOT EXISTS idx_survey_responses_survey_id ON survey_responses(survey_id);
CREATE INDEX IF NOT EXISTS idx_survey_responses_gap_id ON survey_responses(gap_id);
CREATE INDEX IF NOT EXISTS idx_survey_responses_submitted_at ON survey_responses(submitted_at);
CREATE INDEX IF NOT EXISTS idx_users_sub_working_group ON users(sub_working_group);
CREATE INDEX IF NOT EXISTS idx_surveys_status ON surveys(status);
CREATE INDEX IF NOT EXISTS idx_audit_log_event_type ON audit_log(event_type);
CREATE INDEX IF NOT EXISTS idx_audit_log_created_at ON audit_log(created_at);

-- =============================================================================
-- TRIGGERS
-- =============================================================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_surveys_updated_at BEFORE UPDATE ON surveys
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

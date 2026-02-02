# Gap Analysis Automation Platform
Secure, Scalable Survey-to-Insight Pipeline for Defense & Intelligence Operations

---

# Executive Summary

## The Problem

Current gap analysis operations rely on fragmented Microsoft tools — Forms, Excel, Power Automate, and Power BI — stitched together with manual handoffs. Data connections between Excel and Power BI are fragile and frequently break, requiring re-mapping. Over 10 separate Power Automate flows handle simple tasks. There is no automated report generation, no pathway to classified networks, and system knowledge is concentrated in a single operator.

## The Solution

A self-hosted n8n automation platform, containerized via Docker, delivering an end-to-end pipeline from survey distribution through data collection, analytics, and automated report generation. Designed from day one for CMMC compliance with a clear pathway to classified deployment via Game Warden (Second Front Systems). Eliminates manual bottlenecks so any trained operator can manage the system.

---

# Current State vs. Proposed State

## Current Architecture

Forms → Excel → Power Automate → Power BI → Manual Report

**Pain Points:**
- Excel-to-Power BI connections break and require re-mapping
- 10+ siloed Power Automate flows for simple tasks
- No automated report generation
- AI/narrative features blocked on classified (Copilot unavailable)
- No clear certification pathway for Secret or Top Secret networks
- Single operator bottleneck — system fails without one person

## Proposed Architecture

Web Form → n8n Automation Engine → Analytics Dashboard → Auto-Generated Report

**What Changes:**
- One platform replaces Forms + Power Automate + VBA scripts
- PostgreSQL replaces fragile Excel connections
- Automated Likert/NPS analytics replace manual calculations
- Templated consultancy reports generated on demand
- Docker containerized for deployment at any classification level

---

# How It Works: 5 Core Workflows

## 1. Survey Distribution & Reminders
Roster-driven automated distribution with scheduled and manual triggers. Checks who hasn't responded and sends reminders. Controlled via spreadsheet columns — no manual clicking in Power Automate.

## 2. Form Submission Handler
Secure webhook endpoint receives demographics and gap survey submissions. Validates and sanitizes all input, stores to database and archive, sends thank-you confirmations, and updates roster status automatically.

## 3. Data Processing & Analytics
Enriches responses with demographics data. Computes Likert scale distributions, NPS-weighted scoring per gap and factor, sub-working group breakdowns, and time-series tracking for gap trends across quarters.

## 4. Consultancy Report Generator
Produces a templated report with executive summary, methodology, top 10 priority gaps, factor analysis with full distribution tables, and actionable recommendations categorized as Immediate, Monitor, or Maintain.

## 5. Survey Lifecycle Manager
Automatically opens scheduled surveys, sends closing warnings 3 days out, closes expired surveys, and notifies analysts when data is ready for review.

---

# Core Capabilities

## Survey Management
- Roster-driven distribution — no manual email lists
- Schedule-based and manual trigger options
- Automatic delinquency tracking and reminders
- Survey lifecycle automation: open, warn, close

## Data Collection
- Demographics form filled once per user
- Gap analysis survey using Likert 1-7 scale across 100+ gaps
- Input validation and sanitization at point of entry
- Automatic archiving to encrypted long-term storage

## Analytics Engine
- Likert scale distribution analysis with percentage breakdowns per score
- Net Priority Score (NPS) weighted composite scoring
- Factor-level aggregation across all gaps
- Sub-working group filtered analysis
- Time-series gap tracking across survey periods (Q1 vs Q2 vs Q3)
- Complex filtering by experience, organization type, status, and working group

## Automated Report Generation
- Templated consultancy report in markdown format
- Executive summary with key metrics and response rates
- Top 10 priority gaps ranked by NPS
- Factor analysis with full Likert distribution tables
- Trend analysis across survey cycles
- Actionable recommendations: Immediate (NPS < -20), Monitor (-20 to 0), Maintain (> 0)

---

# Security & Compliance

## CMMC Level 2 Alignment
- **Access Control:** API key authentication on all webhooks; role-based access
- **Audit & Accountability:** All workflow executions logged with timestamps and user attribution
- **Configuration Management:** Infrastructure-as-code via Docker Compose; version-controlled
- **Identification & Authentication:** Unique usernames as identifiers; header-based API auth
- **Media Protection:** Data encrypted at rest via volume encryption; TLS 1.2+ in transit
- **System & Communications Protection:** Network isolation via Docker networks; zero external API calls on classified
- **System & Information Integrity:** Input sanitization; IP hashing; data validation at point of entry

## NIST 800-171 Controls
- CUI handling procedures built into the data flow
- Separation of duties between survey submitter and analyst roles
- Automated audit trail for all data processing steps
- Encrypted backup and archive workflow with 30-day retention

## FedRAMP Readiness
- Containerized architecture aligns with FedRAMP container security guidelines
- No third-party SaaS dependencies on classified networks
- All processing occurs within the authorization boundary

---

# Game Warden: Pathway to Classified

## What Is Game Warden?
Game Warden by Second Front Systems is a DoD-accredited DevSecOps Platform-as-a-Service built on AWS GovCloud. It runs on Big Bang (DoD Kubernetes platform) using Amazon EKS. Applications deployed on Game Warden inherit its Authority to Operate (ATO), reducing certification timelines from 6-18 months down to weeks.

## Supported Classification Levels
- **IL2** — Commercial internet
- **IL4** — NIPRNet (CUI)
- **IL5** — NIPRNet (higher CUI)
- **IL6** — SIPRNet (Secret) via AWS Secret Region
- **TS/SCI** — JWICS (Top Secret) via AWS Top Secret Region

## How Our Tool Deploys Through Game Warden
1. Push container images to Game Warden pipeline
2. Automated ClamAV virus scanning on every image
3. Anchore vulnerability scanning (NIST 800-53 aligned)
4. STIG hardening scripts applied automatically
5. Deploy to dev/staging for functionality testing
6. Promote to production at target Impact Level

## What Game Warden Handles
- ATO inheritance — no independent 6-18 month certification
- Container scanning, malware scanning, STIG hardening
- Cross-domain transfer via AWS Diode (unclass to Secret to TS)
- Kubernetes orchestration on Big Bang/EKS
- Compliance: DoD CC SRG, NIST 800-171, NIST 800-53, CIS Benchmarks, DISA STIGs

## What We Provide
- Container images running as non-privileged users
- All critical/high CVEs resolved before promotion
- Current upstream support on all base images (PostgreSQL 16, NGINX Alpine, n8n)
- Iron Bank compatible images where available
- Helm charts for Kubernetes deployment

---

# Deployment Tiers

## Tier 1: Black (Unclassified / IL2-IL4) — MVP
**Environment:** AWS GovCloud or on-premise Docker host
**Timeline:** Weeks 1-6
- n8n self-hosted in Docker
- PostgreSQL database replacing fragile Excel connections
- NGINX reverse proxy with TLS and rate limiting
- Google Sheets or Excel Online integration for familiar interface
- SMTP email relay for notifications
- Optional Power BI connector for existing dashboards
- **Target:** Functional prototype for March event with ~15 users

## Tier 2: Yellow (Secret / IL5-IL6) — Phase 2
**Environment:** Game Warden on AWS GovCloud / Secret Region
**Timeline:** Weeks 7-12
- Kubernetes/Helm deployment through Game Warden pipeline
- PostgreSQL-only storage (no external API dependencies)
- Approved classified mail relay
- Iron Bank base images where available
- Inherited ATO via Game Warden
- **Target:** Operational capability on classified network

## Tier 3: Red (Top Secret/SCI) — Phase 3
**Environment:** Game Warden on AWS Top Secret Region
**Timeline:** Weeks 13-20
- Promotion to TS region via AWS Diode cross-domain solution
- Additional access controls for SCI compartment handling
- Enhanced audit logging and monitoring
- Fully air-gapped with all dependencies bundled
- **Target:** Full operational deployment at highest classification

---

# Technology Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| Automation Engine | n8n (self-hosted) | Workflow orchestration — all 5 core workflows |
| Database | PostgreSQL 16 | Structured data storage; replaces Excel |
| Reverse Proxy | NGINX | TLS termination, rate limiting, security headers |
| Containerization | Docker + Compose → Helm | Deployment packaging; Game Warden compatible |
| Dashboard | Power BI or Metabase (open-source) | Data visualization and filtering |
| Email | SMTP relay | Survey distribution and notifications |
| Backup | Automated pg_dump | Daily encrypted backups with 30-day retention |
| Forms | n8n webhook + HTML | Survey intake with validation |

All components are open-source or self-hosted. No per-user licensing costs. No vendor lock-in.

---

# Implementation Timeline

## Phase 1: Black MVP — Weeks 1 through 6
| Week | Milestone | Deliverable |
|------|-----------|-------------|
| 1 | Onboarding & Setup | n8n deployed; data schema finalized; access provisioned |
| 2 | Core Workflows | Survey distribution and form submission handler operational |
| 3 | Analytics Engine | Likert/NPS calculations; factor aggregation; dashboard data |
| 4 | Report Generator | Auto-report and survey lifecycle automation |
| 5 | Integration Testing | End-to-end test with sample data; Power BI connector |
| 6 | UAT & Handoff | User acceptance testing with ~15 users at March event |

**Milestone Gate:** Client reviews functional MVP. Green light to proceed or conclude.

## Phase 2: Yellow Deployment — Weeks 7 through 12
| Week | Milestone |
|------|-----------|
| 7-8 | Game Warden environment setup and container hardening |
| 9-10 | Migration and testing on classified network |
| 11-12 | Compliance documentation and operational testing |

**Milestone Gate:** Operational on Yellow. Green light for Phase 3 or conclude.

## Phase 3: Red Deployment — Weeks 13 through 20
| Week | Milestone |
|------|-----------|
| 13-15 | TS environment provisioning and additional security controls |
| 16-18 | Deployment and integration with classified mail and systems |
| 19-20 | Compliance review and operational acceptance |

---

# Pricing: Tier 1 — Black (Unclassified)

## One-Time Development: $20,000 - $31,000

| Item | Cost |
|------|------|
| n8n workflow build-out (5 workflows) | $8,000 - $12,000 |
| Data schema design and migration from Excel/Forms | $2,000 - $3,000 |
| Power BI connector or Metabase dashboard setup | $3,000 - $5,000 |
| Consultancy report template and generator | $2,000 - $3,000 |
| Docker containerization and hardening | $1,500 - $2,500 |
| NGINX TLS and security configuration | $500 - $1,000 |
| Integration testing and UAT (March event) | $2,000 - $3,000 |
| Documentation and operator training | $1,000 - $1,500 |

## Monthly Infrastructure: ~$130 - $270/month

| Item | Cost/month |
|------|------------|
| AWS GovCloud compute (t3.medium) | $75 - $150 |
| PostgreSQL (RDS or self-hosted) | $30 - $75 |
| S3 backup storage | $5 - $10 |
| Domain and TLS certificate | $12 - $15 |
| SMTP relay (SES or equivalent) | $10 - $20 |

## Year 1 Total: $21,560 - $34,240

---

# Pricing: Tier 2 — Yellow (Secret)

## One-Time Development: $23,000 - $40,000

| Item | Cost |
|------|------|
| Kubernetes/Helm chart conversion | $4,000 - $6,000 |
| Iron Bank image submission for n8n | $3,000 - $5,000 |
| Game Warden onboarding and pipeline integration | $5,000 - $8,000 |
| Acceptance Baseline Criteria remediation (CVE, STIG, non-root) | $3,000 - $6,000 |
| Remove external API dependencies (Sheets → PostgreSQL only) | $2,000 - $4,000 |
| Classified email relay integration | $1,000 - $2,000 |
| SIPRNet testing and validation | $3,000 - $5,000 |
| Compliance documentation (SSP, POA&M) | $2,000 - $4,000 |

## Monthly Infrastructure: ~$3,500 - $9,500/month

| Item | Cost/month |
|------|------------|
| Game Warden platform fee (single-tenant K8s cluster) | $3,000 - $8,000 |
| AWS GovCloud Secret Region compute | $500 - $1,500 |
| Managed services (monitoring, patching) | Included |

## Year 1 Total: $65,000 - $154,000

---

# Pricing: Tier 3 — Red (Top Secret/SCI)

## One-Time Development: $30,000 - $62,000

| Item | Cost |
|------|------|
| TS environment provisioning and access coordination | $3,000 - $5,000 |
| Additional access controls for SCI handling | $4,000 - $7,000 |
| AWS Top Secret Region deployment via AWS Diode | $5,000 - $10,000 |
| Enhanced audit logging and monitoring | $2,000 - $4,000 |
| TS-specific compliance documentation | $3,000 - $6,000 |
| Security assessment and penetration testing support | $5,000 - $10,000 |
| Operational acceptance testing on JWICS | $3,000 - $5,000 |
| Compliance team involvement (external) | $5,000 - $15,000 |

## Monthly Infrastructure: ~$10,000 - $19,000/month

| Item | Cost/month |
|------|------------|
| Game Warden platform fee (TS region — premium) | $8,000 - $15,000 |
| AWS Top Secret Region compute | $1,500 - $3,000 |
| Enhanced monitoring and compliance tools | $500 - $1,000 |

## Year 1 Total: $150,000 - $290,000

---

# Total Program Investment

## Option A: Phase-by-Phase (Milestone-Based)

| Phase | Development | Annual Infra | Year 1 Total |
|-------|-------------|-------------|--------------|
| Black MVP | $20K - $31K | $1.6K - $3.2K | $21.5K - $34.2K |
| Yellow (Secret) | $23K - $40K | $42K - $114K | $65K - $154K |
| Red (TS/SCI) | $30K - $62K | $120K - $228K | $150K - $290K |
| **All Three Tiers** | **$73K - $133K** | **$163.6K - $345.2K** | **$236.5K - $478.2K** |

Each phase includes a milestone review gate. Client may proceed or conclude at any gate with full deliverables for completed phases.

## Option B: Bundled Program (Single Vehicle)

| Milestone | Deliverable | Payment |
|-----------|-------------|---------|
| Contract Award | Project kickoff | 20% |
| MVP Acceptance (Week 6) | Functional black prototype | 30% |
| Yellow Operational (Week 12) | Classified deployment | 30% |
| Red Operational (Week 20) | Full deployment | 20% |

Bundling all three tiers under a single vehicle typically saves 10-15% on development costs.

## Where the Money Goes

- **Black:** ~90% development, ~10% infrastructure — fast and lean
- **Yellow:** ~35% development, ~65% infrastructure — Game Warden platform fees dominate
- **Red:** ~20% development, ~80% infrastructure — TS region premium pricing

The Game Warden platform fee is the dominant cost on classified tiers, but replaces an independent ATO process that would cost $200K-$500K+ and take 6-18 months.

---

# Optional Add-Ons

| Item | Cost |
|------|------|
| Monthly maintenance and monitoring | $1,500 - $3,000/month |
| Additional survey template builds | $1,500 - $2,500 each |
| AI narrative integration (when available on high side) | $5,000 - $10,000 |
| Scaling support for May event (~150 users) | $2,000 - $4,000 |
| Predictive gap trending (ML-based forecasting) | $8,000 - $15,000 |
| Automated briefing slide generation | $5,000 - $8,000 |

---

# Cost Reduction Levers

## Ways to Lower Total Investment

- **Multi-tenant Game Warden cluster** — sharing a cluster with other applications significantly reduces platform fees
- **Existing Game Warden contract** — if the organization already has a Game Warden relationship, onboarding costs drop
- **Iron Bank images** — PostgreSQL and NGINX are already in Iron Bank; only n8n requires submission
- **Bundle discount** — single vehicle across all tiers saves 10-15% on development
- **Phase gating** — start with Black only at $21.5K-$34.2K and expand based on results

---

# Competitive Advantages

## Why n8n Over Power Automate
- Self-hosted with no Microsoft cloud dependency on classified networks
- Single platform replaces Forms + Power Automate + VBA scripts
- Docker containerized and portable across any environment
- Open source with no per-user licensing costs
- Game Warden compatible for classified deployment
- Visual workflow builder with low barrier for operator training

## Why This Approach
- Eliminates Excel-to-Power BI connection fragility permanently
- Removes single-operator dependency so anyone can manage the system
- Automated report generation saves analyst hours per survey cycle
- Time-series gap tracking enables trend analysis across quarters
- Modular design allows AI/narrative features to be added when available on high side
- Traditional ATO bypassed through Game Warden inherited security model

---

# Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| Game Warden certification delays | Built to CMMC/NIST standards from day one; uses pre-approved container patterns |
| Power BI unavailable on target network | Metabase (open-source) included as fallback dashboard option |
| AI narrative features unavailable on high side | Template-based report generator works without AI; AI is a future add-on |
| User adoption resistance | Familiar form-based interface; existing Power BI dashboards preserved where possible |
| Data migration complexity | Automated import scripts for existing Excel and Forms data |
| Network restrictions on classified | All components fully self-contained with zero external API calls |
| Tool sits on shelf waiting for certification | Game Warden reduces ATO from 6-18 months to weeks |

---

# Future Enhancements

## Post-MVP Roadmap

1. **AI-Powered Narrative Generation** — When Gen AI becomes available on classified networks, auto-generate written analysis of charts, trends, and recommendations
2. **Predictive Gap Trending** — ML-based forecasting of gap trajectories using historical survey data to anticipate emerging priority gaps
3. **Interactive Real-Time Dashboard** — Live filtering by demographic, working group, and time period with drill-down capabilities
4. **Multi-Organization Support** — Expand beyond a single organization to enable cross-agency gap analysis and benchmarking
5. **Mobile Survey Submission** — Responsive forms optimized for field-based participants on tablets and phones
6. **Automated Briefing Slides** — Generate PowerPoint presentations directly from report data for leadership briefings

---

# Next Steps

1. **Proposal Review** — Client reviews this proposal and pricing structure
2. **Contract Execution** — Finalize terms, timeline, and payment milestones
3. **Onboarding Call** — Gain access to existing Power Automate flows, Power BI models, and Excel data
4. **n8n Environment Setup** — Provision hosting environment (AWS GovCloud or on-premise)
5. **Development Begins** — Week 1 sprint kicks off
6. **March Event** — Functional MVP tested live with ~15 users
7. **May Event** — Scaled deployment supporting ~150 users

---

# Appendix: Technical Specifications

## n8n Workflow Inventory

| # | Workflow | Trigger | Function |
|---|---------|---------|----------|
| 01 | Survey Distribution & Reminders | Scheduled (weekly) + Manual | Send surveys, track delinquency, roster-based targeting |
| 02 | Form Submission Handler | Webhook (POST) | Validate, sanitize, store demographics and gap scores, confirm |
| 03 | Data Processing & Analytics | Scheduled (daily) + Manual | Likert analysis, NPS scoring, factor aggregation, time-series |
| 04 | Report Generator | Manual + API | Generate templated consultancy report with rankings |
| 05 | Survey Lifecycle Manager | Scheduled (daily) | Auto-open/close surveys, closing warnings, analyst alerts |

## Data Schema

**Demographics:** username, email, name, experience_years, org_type, current_status, sub_working_group, affiliations, skill_sets, timestamp

**Survey Responses:** username, surveyId, gapId, score (1-7), timestamp, subWorkingGroup

**Gap Definitions:** gapId, name, category, factor, description, ownerGroup

**Survey Config:** surveyId, surveyName, startDate, endDate, status, targetGroups, formUrl

## NPS Scoring Formula
Weight Map: 1=-3, 2=-2, 3=-1, 4=0, 5=0, 6=+1, 7=+2. NPS equals the sum of weights for all responses to a given gap. Lower NPS indicates a higher priority gap requiring attention.

# Gap Analysis Tool - Proposal Framework
## For Upload to Gamma.app

---

## SLIDE 1: Title Slide

**Title:** Gap Analysis Automation Platform
**Subtitle:** Secure, Scalable Survey-to-Insight Pipeline for Defense & Intelligence Operations
**Presented by:** [Company Name]
**Date:** February 2025
**Classification:** UNCLASSIFIED // FOR OFFICIAL USE ONLY

---

## SLIDE 2: Executive Summary

**The Problem:**
- Current gap analysis process relies on fragmented Microsoft tools (Forms, Excel, Power Automate, Power BI) with manual handoffs
- Data connections between Excel and Power BI are fragile and require frequent re-mapping
- No clear pathway to deploy on classified (Red/Yellow) networks
- Analyst time consumed by manual data processing instead of strategic analysis
- Single point-of-failure: system knowledge concentrated in one operator

**The Solution:**
- Self-hosted n8n automation platform containerized via Docker
- End-to-end pipeline: Survey Distribution → Data Collection → Analytics → Report Generation
- Designed for CMMC compliance with a pathway to classified deployment via Game Warden (Second Front)
- Eliminates manual bottlenecks; any trained operator can manage the system

---

## SLIDE 3: Current State Architecture

**Current Flow (Pain Points Highlighted):**

```
[MS Forms] → [Excel] → [Power Automate] → [Power BI] → [Manual Report]
     ↓            ↓              ↓               ↓              ↓
  Limited     Fragile        Complex         Broken         Time-
  Offline     Links          Flows           Live Data      Intensive
  Support                                    Connection
```

**Key Issues:**
- Excel-to-Power BI connections break and require re-mapping
- Power Automate flows are siloed (10+ separate flows for simple tasks)
- No automated report generation
- AI/narrative features blocked on classified networks (Copilot unavailable)
- Certification pathway for Red/Yellow unclear with current multi-tool approach

---

## SLIDE 4: Proposed Architecture

**New Flow (n8n Platform):**

```
[Web Form / API] → [n8n Automation Engine] → [Analytics Dashboard] → [Auto-Generated Report]
                          ↓
              [Secure Data Store]
              [Long-Term Archive]
              [Email Notifications]
```

**5 Core Workflows:**
1. **Survey Distribution & Reminders** - Automated scheduling, delinquency tracking, roster-driven
2. **Form Submission Handler** - Webhook intake, validation, sanitization, storage, confirmation emails
3. **Data Processing & Analytics** - Likert scale analysis, NPS scoring, factor aggregation, time-series tracking
4. **Report Generator** - Templated consultancy report with executive summary, rankings, recommendations
5. **Survey Lifecycle Manager** - Auto-open/close surveys, closing warnings, analyst notifications

---

## SLIDE 5: Core Capabilities

### Survey Management
- Roster-driven distribution (no manual email lists)
- Schedule-based AND manual trigger options
- Automatic delinquency tracking and reminders
- Survey lifecycle automation (open, warn, close)

### Data Collection
- Demographics form (one-time per user)
- Gap analysis survey (Likert 1-7 scale, ~100+ gaps)
- Input validation and sanitization at point of entry
- Automatic archiving to long-term storage

### Analytics Engine
- Likert scale distribution analysis (percentage breakdowns per score)
- Net Priority Score (NPS) weighted composite scoring
- Factor-level aggregation across all gaps
- Sub-working group filtered analysis
- Time-series gap tracking across survey periods (Q1 vs Q2 vs Q3)
- Complex filtering: experience, org type, status, working group

### Report Generation
- Templated markdown consultancy report
- Executive summary with key metrics
- Top 10 priority gaps ranked by NPS
- Factor analysis with full distribution tables
- Trend analysis across survey cycles
- Actionable recommendations (Immediate/Monitor/Maintain)

---

## SLIDE 6: Security & Compliance Architecture

### CMMC Level 2 Alignment
- **Access Control (AC):** API key authentication on all webhooks; role-based access
- **Audit & Accountability (AU):** All workflow executions logged with timestamps
- **Configuration Management (CM):** Infrastructure-as-code via Docker Compose; version-controlled
- **Identification & Authentication (IA):** Unique usernames as identifiers; header-based API auth
- **Media Protection (MP):** Data encrypted at rest (volume encryption); TLS in transit
- **System & Communications Protection (SC):** Network isolation via Docker networks; no external API calls on classified
- **System & Information Integrity (SI):** Input sanitization; IP hashing; data validation

### NIST 800-171 Controls
- CUI handling procedures built into data flow
- Separation of duties between survey submitter and analyst
- Automated audit trail for all data processing
- Encrypted backup/archive workflow

### FedRAMP Readiness (Future)
- Containerized architecture aligns with FedRAMP container security guidelines
- No third-party SaaS dependencies on classified networks
- All processing occurs within authorization boundary

---

## SLIDE 7: Deployment Tiers

### Tier 1: Black (Unclassified) - MVP
**Environment:** AWS GovCloud / On-premise Docker host
**Timeline:** 4-6 weeks from contract start
**Components:**
- n8n self-hosted (Docker)
- PostgreSQL database (replaces Excel fragility)
- NGINX reverse proxy with TLS
- Google Sheets OR Excel Online integration (familiar interface)
- SMTP email relay
- Optional: Power BI connector for existing dashboards

**Key Benefit:** Functional prototype for March event (~15 users)

### Tier 2: Yellow (Secret) - Phase 2
**Environment:** Game Warden (Second Front) containerized deployment
**Timeline:** 4-6 weeks after Tier 1 acceptance
**Components:**
- All Tier 1 components in air-gapped Docker container
- Internal-only data stores (no cloud dependencies)
- Approved internal mail relay
- Cross-domain transfer procedures for data import/export

**Key Benefit:** Operational capability on classified network

### Tier 3: Red (Top Secret/SCI) - Phase 3
**Environment:** Game Warden or approved TS infrastructure
**Timeline:** 6-8 weeks after Tier 2 (includes compliance review)
**Components:**
- All Tier 2 components hardened for TS
- Additional access controls and audit logging
- Classified network email integration
- Data handling procedures for SCI material

**Key Benefit:** Full operational deployment at highest classification

---

## SLIDE 8: Technology Stack

| Component | Tool | Purpose | Classification Ready |
|-----------|------|---------|---------------------|
| Automation Engine | n8n (self-hosted) | Workflow orchestration | Yes - Docker container |
| Database | PostgreSQL 16 | Structured data storage | Yes - containerized |
| Reverse Proxy | NGINX | TLS termination, access control | Yes - standard |
| Containerization | Docker + Compose | Deployment packaging | Yes - Game Warden compatible |
| Dashboard | Power BI (existing) OR Metabase (open-source) | Data visualization | Power BI available on Yellow+ |
| Email | SMTP relay | Notifications | Network-dependent |
| Backup | Automated pg_dump | Data resilience | Yes |
| Forms | n8n webhook + custom HTML | Survey intake | Yes - self-contained |

---

## SLIDE 9: Data Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    AUTHORIZATION BOUNDARY                │
│                                                         │
│  ┌──────────┐    ┌─────────────┐    ┌───────────────┐  │
│  │  Survey   │───▶│  n8n Engine  │───▶│  PostgreSQL   │  │
│  │  Form     │    │  (5 flows)  │    │  Database     │  │
│  └──────────┘    └──────┬──────┘    └───────────────┘  │
│                         │                               │
│              ┌──────────┼──────────┐                    │
│              ▼          ▼          ▼                    │
│     ┌──────────┐ ┌──────────┐ ┌──────────┐            │
│     │  Email   │ │ Dashboard│ │  Report  │            │
│     │  Notify  │ │ (Power BI│ │ Generator│            │
│     │          │ │  /Metabse)│ │          │            │
│     └──────────┘ └──────────┘ └──────────┘            │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │              ARCHIVE / BACKUP                     │  │
│  │         Encrypted PostgreSQL Dumps                │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## SLIDE 10: Implementation Timeline & Milestones

### Phase 1: Black MVP (Weeks 1-6)

| Week | Milestone | Deliverable |
|------|-----------|-------------|
| 1 | Onboarding & Setup | n8n instance deployed; data schema finalized; access provisioned |
| 2 | Core Workflows | Survey distribution + form submission handler operational |
| 3 | Analytics Engine | Likert/NPS calculations; factor aggregation; dashboard data |
| 4 | Report Generator + Lifecycle | Auto-report; survey open/close automation |
| 5 | Integration Testing | End-to-end test with sample data; Power BI connector |
| 6 | UAT & Handoff | User acceptance testing with ~15 users (March event) |

**Milestone Gate:** Client reviews functional MVP → Green light for Phase 2

### Phase 2: Yellow Deployment (Weeks 7-12)
| Week | Milestone |
|------|-----------|
| 7-8 | Game Warden environment setup; container hardening |
| 9-10 | Migration and testing on classified network |
| 11-12 | Compliance documentation; operational testing |

**Milestone Gate:** Operational on Yellow → Green light for Phase 3

### Phase 3: Red Deployment (Weeks 13-20)
| Week | Milestone |
|------|-----------|
| 13-15 | TS environment provisioning; additional security controls |
| 16-18 | Deployment; integration with classified mail/systems |
| 19-20 | Compliance review; operational acceptance |

---

## SLIDE 11: Pricing Structure

### Option A: Phase-by-Phase (Milestone-Based)

| Phase | Scope | Estimated Cost | Duration |
|-------|-------|---------------|----------|
| Phase 1 | Black/Unclassified MVP | $[X] | 6 weeks |
| Phase 2 | Yellow/Secret Deployment | $[X] | 6 weeks |
| Phase 3 | Red/TS Deployment | $[X] | 8 weeks |
| **Total** | **Full Stack Deployment** | **$[X]** | **~20 weeks** |

*Each phase includes a milestone review gate. Client may proceed or conclude at any gate.*

### Option B: Bundled Program (Single Vehicle)

| Milestone | Deliverable | Payment |
|-----------|-------------|---------|
| Contract Award | Project kickoff | 20% |
| MVP Acceptance (Week 6) | Functional black prototype | 30% |
| Yellow Operational (Week 12) | Classified deployment | 30% |
| Red Operational (Week 20) | Full deployment | 20% |

### Ongoing Support (Optional)
- Monthly maintenance & monitoring: $[X]/mo
- Feature enhancements: T&M basis
- Additional survey template buildouts: Fixed price per template

---

## SLIDE 12: Competitive Advantages

**Why n8n over Power Automate:**
- Self-hosted: no Microsoft cloud dependency on classified networks
- Single platform replaces Forms + Power Automate + VBA scripts
- Docker containerized: portable across any environment
- Open source: no per-user licensing costs
- Game Warden compatible for classified deployment pathway
- Visual workflow builder: low barrier for operator training

**Why This Approach:**
- Eliminates Excel-to-Power BI connection fragility
- Removes single-operator dependency (anyone can run the system)
- Automated report generation saves analyst hours per survey cycle
- Time-series gap tracking enables trend analysis across quarters
- Modular design: add AI/narrative features when available on high side

---

## SLIDE 13: Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| Game Warden certification delays | Build to CMMC/NIST standards from day 1; use pre-approved container patterns |
| Power BI unavailable on target network | Include Metabase (open-source) as fallback dashboard |
| AI narrative features not available on high side | Template-based report generator works without AI; AI is a future add-on |
| User adoption resistance | Familiar form-based interface; existing Power BI dashboards preserved where possible |
| Data migration complexity | Automated import scripts for existing Excel/Forms data |
| Network restrictions on classified | All components self-contained; zero external API calls |

---

## SLIDE 14: Future Enhancements (Post-MVP)

1. **AI-Powered Narrative Generation** - When Gen AI is available on classified networks, auto-generate written analysis of charts and trends
2. **Predictive Gap Trending** - ML-based forecasting of gap trajectories based on historical survey data
3. **Interactive Dashboard** - Real-time filtering by demographic, group, and time period (Metabase or Power BI)
4. **Multi-Organization Support** - Expand beyond single org to cross-agency gap analysis
5. **Mobile Survey Submission** - Responsive forms for field-based participants
6. **Automated Briefing Slides** - Generate PowerPoint/presentation from report data

---

## SLIDE 15: Next Steps

1. **Proposal Review** - Client reviews this proposal and pricing
2. **Contract Execution** - Finalize terms, timeline, and payment milestones
3. **Onboarding Call** - Gain access to existing Power Automate flows, Power BI models, Excel data
4. **n8n Account Setup** - Client provisions or approves hosting environment
5. **Development Begins** - Week 1 sprint starts
6. **March Event Target** - Functional MVP tested with ~15 users

**Contact:** [Name] | [Email] | [Phone]

---

## SLIDE 16: Appendix - Technical Specifications

### n8n Workflow Inventory

| # | Workflow | Trigger | Function |
|---|---------|---------|----------|
| 01 | Survey Distribution & Reminders | Scheduled (weekly) + Manual | Send surveys, track delinquency, roster-based targeting |
| 02 | Form Submission Handler | Webhook (POST) | Validate, sanitize, store demographics & gap scores, confirm |
| 03 | Data Processing & Analytics | Scheduled (daily) + Manual | Likert analysis, NPS scoring, factor aggregation, time-series |
| 04 | Report Generator | Manual + API | Generate templated consultancy report with rankings |
| 05 | Survey Lifecycle Manager | Scheduled (daily) | Auto-open/close surveys, closing warnings, analyst alerts |

### Data Schema

**Demographics Table:**
username, email, name, experience_years, org_type, current_status, sub_working_group, affiliations, skill_sets, timestamp

**Survey Responses Table:**
username, surveyId, gapId, score (1-7), timestamp, subWorkingGroup

**Gap Definitions Table:**
gapId, name, category, factor, description, ownerGroup

**Survey Config Table:**
surveyId, surveyName, startDate, endDate, status, targetGroups, formUrl

### NPS Scoring Formula
```
Weight Map: {1: -3, 2: -2, 3: -1, 4: 0, 5: 0, 6: +1, 7: +2}
NPS = Σ(weight[score_i]) for all responses to a given gap
Lower NPS = Higher priority gap
```

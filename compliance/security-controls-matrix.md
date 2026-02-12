# Security Controls Matrix
## Gap Analysis Tool - Compliance Mapping
### Updated Based on Multi-Agent Security Review

---

## CMMC Level 2 Control Mapping

| CMMC Domain | Practice | Implementation | Status |
|-------------|----------|----------------|--------|
| **AC - Access Control** | AC.L2-3.1.1 Limit system access | API key auth on webhooks; n8n user roles; non-root container execution | **Implemented** |
| | AC.L2-3.1.2 Limit system access to authorized transactions | Workflow-level permissions; read-only dashboard access; parameterized queries | **Implemented** |
| | AC.L2-3.1.5 Least privilege | Separate roles: admin, analyst, submitter; container user 1000:1000 | **Implemented** |
| | AC.L2-3.1.12 Remote access control | TLS 1.2+ via NGINX reverse proxy; VPN required on classified | **Implemented** |
| **AU - Audit** | AU.L2-3.3.1 System-level auditing | n8n execution logs; PostgreSQL audit_log table; Prometheus metrics | **Implemented** |
| | AU.L2-3.3.2 Individual accountability | Username + submission_id tied to all actions; IP hashing for traceability | **Implemented** |
| | AU.L2-3.3.4 Alert on audit failure | Alertmanager configured for workflow failures, backup failures, system errors | **Implemented** |
| **CM - Config Mgmt** | CM.L2-3.4.1 Baseline configurations | Docker Compose with pinned versions; database schema versioned | **Implemented** |
| | CM.L2-3.4.2 Security config enforcement | Environment variables for configs; secrets guidance in .env.example | **Implemented** |
| | CM.L2-3.4.6 Least functionality | Only port 443 exposed; internal network isolation; no-new-privileges | **Implemented** |
| **IA - Auth** | IA.L2-3.5.1 Identify system users | Unique username per participant; UUID submission IDs | **Implemented** |
| | IA.L2-3.5.2 Authenticate users | Header-based API auth; n8n basic auth; credential rotation guidance | **Implemented** |
| **IR - Incident Response** | IR.L2-3.6.1 Incident handling | Alertmanager routes; error workflows; execution logs preserved 30+ days | **Implemented** |
| **MP - Media Protection** | MP.L2-3.8.1 Protect media | Docker volumes (encryption at rest via host); TLS in transit; verified backups | **Implemented** |
| **SC - Sys/Comms** | SC.L2-3.13.1 Boundary protection | Docker internal network; NGINX as single entry point; rate limiting | **Implemented** |
| | SC.L2-3.13.8 CUI in transit | TLS 1.2+ with strong ciphers; HSTS enabled; security headers | **Implemented** |
| **SI - Sys Integrity** | SI.L2-3.14.1 Identify & fix flaws | Container resource limits; health checks; Prometheus monitoring | **Implemented** |
| | SI.L2-3.14.2 Malicious code protection | OWASP-style input validation; SQL injection prevention; pattern matching; length limits | **Implemented** |
| | SI.L2-3.14.6 Monitor inbound comms | Rate limiting (300r/m webhook, 30r/m API); IP hashing; Grafana dashboards | **Implemented** |

---

## NIST 800-171 Rev 2 Control Mapping

| Control Family | Key Controls | Implementation |
|---------------|-------------|----------------|
| 3.1 Access Control | 3.1.1, 3.1.2, 3.1.5, 3.1.7 | Role-based access; API key auth; encrypted sessions; container isolation |
| 3.3 Audit & Accountability | 3.3.1, 3.3.2 | PostgreSQL audit_log table; Prometheus metrics; 30-day retention |
| 3.4 Configuration Mgmt | 3.4.1, 3.4.2 | Docker Compose as IaC baseline; pinned image versions; env-var config |
| 3.5 Identification & Auth | 3.5.1, 3.5.2 | Unique usernames; UUID submission tracking; API key authentication |
| 3.8 Media Protection | 3.8.1, 3.8.3 | Volume encryption; TLS; verified daily backups with integrity checks |
| 3.11 Risk Assessment | 3.11.1 | Container health checks; Alertmanager rules; monitoring dashboards |
| 3.12 Security Assessment | 3.12.1 | Compliance checklist at each tier; documented control mappings |
| 3.13 System & Comms | 3.13.1, 3.13.8 | Network segmentation via Docker internal network; TLS enforcement |
| 3.14 System & Info Integrity | 3.14.1, 3.14.2, 3.14.6 | Comprehensive input validation; parameterized queries; real-time monitoring |

---

## Input Validation Controls (SI.L2-3.14.2)

The form submission handler implements comprehensive validation addressing OWASP Top 10:

| Attack Vector | Mitigation | Implementation |
|--------------|-----------|----------------|
| SQL Injection | Parameterized queries | All PostgreSQL queries use $1, $2... placeholders |
| HTML/Script Injection | Input sanitization | Regex strips `<tags>`, control characters |
| SQL Comment Injection | Pattern removal | Strips `--`, `/*` patterns |
| Quote-based Injection | Character filtering | Removes `'`, `"`, `;`, `\` characters |
| Type Confusion | Schema validation | Type checking (string, number, enum, object) |
| Buffer Overflow | Length limits | maxLength enforced on all string fields (64-1000 chars) |
| Format Attacks | Pattern matching | Regex validation for username, email, gap IDs |
| Duplicate Submission | Idempotency check | Database query before insert; UNIQUE constraints |

---

## Monitoring Stack

| Component | Purpose | Alerts |
|-----------|---------|--------|
| **Prometheus** | Metrics collection | Scrapes n8n, PostgreSQL, NGINX every 30s |
| **Grafana** | Visualization | Dashboards for system health, workflow execution |
| **Alertmanager** | Alert routing | Email notifications for critical/warning events |

### Alert Rules Implemented

- Container down (1 min threshold)
- Workflow execution failures (>5 in 5 min)
- PostgreSQL connection failure
- High response time (>5s p95)
- HTTP 5xx error rate (>10%)
- Backup overdue (>25 hours)
- Disk space low (<10%)

---

## Game Warden (Second Front) Deployment Considerations

### Container Requirements
- All components packaged as Docker containers
- Non-root execution (UID 1000+) for Iron Bank compliance
- No external network calls from within containers on classified
- All dependencies bundled in container images
- Container images scanned for vulnerabilities before deployment
- Resource limits defined (memory, CPU)
- Security options: no-new-privileges

### Iron Bank Readiness

| Image | Iron Bank Status | Action Required |
|-------|-----------------|-----------------|
| PostgreSQL 16 Alpine | Available | Use Iron Bank image |
| NGINX 1.25 Alpine | Available | Use Iron Bank image |
| n8n 1.74.2 | **Not Available** | Submit for approval (6-12 weeks) |
| Prometheus | Available | Use Iron Bank image |
| Grafana | Available | Use Iron Bank image |

**Critical Path:** n8n Iron Bank submission should begin immediately to avoid blocking Yellow deployment.

### Data Handling
- All data remains within authorization boundary
- No cross-domain data transfer without approved procedures
- Database backups encrypted and stored within boundary
- Survey data classified at the level of the deployment network
- Audit logs retained minimum 1 year for classified systems

### Network Architecture (Classified)
```
[User Browser] → [NGINX (TLS)] → [n8n Container] → [PostgreSQL Container]
                       ↓                ↓
                [Grafana]    [Internal SMTP Relay]
                       ↓
               [Prometheus] → [Alertmanager]
```
- All containers on isolated Docker internal network
- Only port 443 exposed externally
- Internal container communication on Docker bridge network
- No internet access required after initial deployment

---

## Air-Gap Deployment Procedure

1. Build all Docker images on connected system
2. Run vulnerability scan on all images (Anchore/Trivy)
3. Resolve all Critical and High CVEs
4. Export images via `docker save`
5. Generate SHA256 checksums for all image archives
6. Transfer images to classified network via approved media
7. Verify checksums on classified side
8. Load images via `docker load`
9. Deploy using Docker Compose
10. Configure environment variables for local network
11. Run database initialization scripts
12. Validate all workflows execute without external dependencies
13. Run compliance verification checklist
14. Document deployment in SSP

---

## Data Classification Guide

| Data Element | Typical Classification | Handling | Retention |
|-------------|----------------------|----------|-----------|
| Demographics (name, org, experience) | CUI / FOUO | Encrypted at rest | Duration of program |
| Gap scores (numeric) | At network level | Standard handling | Duration of program |
| Gap definitions (names, descriptions) | Potentially classified | Handle at network level | Permanent |
| Analytics output | At network level | Standard handling | 3 years |
| Generated reports | At network level | Follow org distribution procedures | 3 years |
| System logs | CUI | Retain per audit requirements | 1 year minimum |
| Audit logs | CUI | Tamper-evident storage | 3 years |
| Backup files | At network level | Encrypted; secure disposal | 30 days |

---

## Compliance Checklist (Pre-Deployment)

- [ ] All container images use pinned versions
- [ ] Non-root user configured for all containers
- [ ] TLS certificates installed and valid
- [ ] Environment variables configured (no defaults in production)
- [ ] Database schema initialized
- [ ] Backup service operational and verified
- [ ] Monitoring stack operational
- [ ] Alert notifications tested
- [ ] Input validation tested with malicious payloads
- [ ] Rate limiting verified
- [ ] Audit logging verified
- [ ] Duplicate submission prevention tested
- [ ] All CMMC controls documented
- [ ] Iron Bank images used where available
- [ ] SSP updated with deployment details

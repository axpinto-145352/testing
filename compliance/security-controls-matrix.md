# Security Controls Matrix
## Gap Analysis Tool - Compliance Mapping

---

## CMMC Level 2 Control Mapping

| CMMC Domain | Practice | Implementation | Status |
|-------------|----------|----------------|--------|
| **AC - Access Control** | AC.L2-3.1.1 Limit system access | API key auth on webhooks; n8n user roles | Designed |
| | AC.L2-3.1.2 Limit system access to authorized transactions | Workflow-level permissions; read-only dashboard access | Designed |
| | AC.L2-3.1.5 Least privilege | Separate roles: admin, analyst, submitter | Designed |
| | AC.L2-3.1.12 Remote access control | TLS via NGINX reverse proxy; VPN required on classified | Designed |
| **AU - Audit** | AU.L2-3.3.1 System-level auditing | n8n execution logs with timestamps, user, workflow ID | Built-in |
| | AU.L2-3.3.2 Individual accountability | Username tied to all submissions and actions | Built-in |
| | AU.L2-3.3.4 Alert on audit failure | n8n error workflow triggers email alert on any failure | Designed |
| **CM - Config Mgmt** | CM.L2-3.4.1 Baseline configurations | Docker Compose defines exact versions and configs | Built-in |
| | CM.L2-3.4.2 Security config enforcement | Environment variables for all sensitive configs; no hardcoded secrets | Built-in |
| | CM.L2-3.4.6 Least functionality | Only required ports exposed (443); unused services disabled | Designed |
| **IA - Auth** | IA.L2-3.5.1 Identify system users | Unique username per participant; API keys per integration | Built-in |
| | IA.L2-3.5.2 Authenticate users | Header-based API auth; n8n login credentials | Built-in |
| **IR - Incident Response** | IR.L2-3.6.1 Incident handling | Error workflows trigger alerts; execution logs preserved | Designed |
| **MP - Media Protection** | MP.L2-3.8.1 Protect media | Docker volumes encrypted at rest; TLS in transit | Designed |
| **SC - Sys/Comms** | SC.L2-3.13.1 Boundary protection | Docker network isolation; NGINX as single entry point | Built-in |
| | SC.L2-3.13.8 CUI in transit | TLS 1.2+ enforced on all connections | Designed |
| **SI - Sys Integrity** | SI.L2-3.14.1 Identify & fix flaws | Container image scanning; dependency updates | Designed |
| | SI.L2-3.14.2 Malicious code protection | Input sanitization in webhook handler; HTML stripping | Built-in |
| | SI.L2-3.14.6 Monitor inbound comms | Rate limiting on NGINX; IP hashing for audit | Designed |

---

## NIST 800-171 Rev 2 Control Mapping

| Control Family | Key Controls | Implementation |
|---------------|-------------|----------------|
| 3.1 Access Control | 3.1.1, 3.1.2, 3.1.5, 3.1.7 | Role-based access; API key auth; encrypted sessions |
| 3.3 Audit & Accountability | 3.3.1, 3.3.2 | Execution logs; username tracing; timestamped actions |
| 3.4 Configuration Mgmt | 3.4.1, 3.4.2 | Docker Compose as baseline; env-var config management |
| 3.5 Identification & Auth | 3.5.1, 3.5.2 | Unique usernames; API key authentication |
| 3.8 Media Protection | 3.8.1, 3.8.3 | Volume encryption; TLS; secure backup procedures |
| 3.11 Risk Assessment | 3.11.1 | Periodic vulnerability scans on container images |
| 3.12 Security Assessment | 3.12.1 | Compliance checklist reviewed at each deployment tier |
| 3.13 System & Comms | 3.13.1, 3.13.8 | Network segmentation via Docker; TLS enforcement |
| 3.14 System & Info Integrity | 3.14.1, 3.14.2, 3.14.6 | Input validation; sanitization; monitoring |

---

## Game Warden (Second Front) Deployment Considerations

### Container Requirements
- All components packaged as Docker containers
- No external network calls from within containers on classified
- All dependencies bundled in container images
- Container images scanned for vulnerabilities before deployment

### Data Handling
- All data remains within authorization boundary
- No cross-domain data transfer without approved procedures
- Database backups encrypted and stored within boundary
- Survey data classified at the level of the deployment network

### Network Architecture (Classified)
```
[User Browser] → [NGINX (TLS)] → [n8n Container] → [PostgreSQL Container]
                                        ↓
                              [Internal SMTP Relay]
```
- All containers on isolated Docker network
- Only port 443 exposed externally
- Internal container communication on Docker bridge network
- No internet access required after initial deployment

---

## Air-Gap Deployment Procedure

1. Build all Docker images on connected system
2. Export images via `docker save`
3. Transfer images to classified network via approved media
4. Load images via `docker load`
5. Deploy using Docker Compose
6. Configure environment variables for local network
7. Validate all workflows execute without external dependencies
8. Run compliance verification checklist

---

## Data Classification Guide

| Data Element | Typical Classification | Handling |
|-------------|----------------------|----------|
| Demographics (name, org, experience) | CUI / FOUO | Encrypted at rest |
| Gap scores (numeric) | At network level | Standard handling |
| Gap definitions (names, descriptions) | Potentially classified | Handle at network level |
| Analytics output | At network level | Standard handling |
| Generated reports | At network level | Follow org distribution procedures |
| System logs | CUI | Retain per audit requirements |

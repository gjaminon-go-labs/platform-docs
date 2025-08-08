# Repository Organization and Terminology Guide

## Table of Contents
1. [Repository Types](#repository-types)
2. [Correct Terminology](#correct-terminology)
3. [What Goes Where](#what-goes-where)
4. [Versioning Strategy](#versioning-strategy)
5. [Configuration Management](#configuration-management)
6. [Database Management](#database-management)
7. [Common Misconceptions](#common-misconceptions)
8. [Real Examples](#real-examples)

---

## Repository Types

### 1. Service Repository ✅
**Definition:** Contains everything needed to build and run ONE microservice
**Purpose:** Source code and build artifacts for a single bounded context
**Naming Pattern:** `{service-name}-service` (e.g., `billing-service`)

```
billing-service/                 # SERVICE REPOSITORY
├── cmd/                        # SERVICE ENTRY POINTS
├── internal/                   # SERVICE IMPLEMENTATION (business logic)
├── api/                        # SERVICE CONTRACT (API definitions)
├── database/                   # SERVICE SCHEMA (migrations, scripts)
├── configs/                    # SERVICE CONFIGURATION (templates)
├── build/                      # SERVICE BUILD (Dockerfile, Makefile)
├── tests/                      # SERVICE TESTS
└── docs/                       # SERVICE DOCUMENTATION
```

**Produces:** **Service Artifact** (Docker image with versioned binary)

---

### 2. GitOps Repository ✅
**Definition:** Contains deployment configurations for all environments
**Purpose:** Declarative deployment manifests and environment-specific values
**Naming Pattern:** `{project-name}-gitops` or `{project-name}-deployments`

```
gotuto-gitops/                  # GITOPS REPOSITORY
├── environments/               # DEPLOYMENT MANIFESTS
│   ├── dev/                    # ENVIRONMENT CONFIGURATION
│   │   ├── billing-service/    # Service deployment for dev
│   │   └── catalog-service/    # Service deployment for dev
│   ├── staging/                # ENVIRONMENT CONFIGURATION
│   └── production/             # ENVIRONMENT CONFIGURATION
├── platform/                   # PLATFORM RESOURCES
│   ├── ingress/                # Shared ingress rules
│   ├── monitoring/             # Monitoring stack
│   └── security/               # RBAC, policies
└── scripts/                    # DEPLOYMENT AUTOMATION
```

**Produces:** Nothing (consumed by ArgoCD/Flux for deployments)

---

### 3. Shared Libraries Repository ✅
**Definition:** Contains reusable technical components (NOT business logic)
**Purpose:** Common utilities and cross-cutting concerns
**Naming Pattern:** `{project-name}-libraries` or `{project-name}-commons`

```
gotuto-libraries/               # SHARED LIBRARIES REPOSITORY
├── events/                     # EVENT DEFINITIONS
│   ├── billing/                # Billing domain events
│   └── catalog/                # Catalog domain events
├── common/                     # COMMON UTILITIES
│   ├── logging/                # Structured logging
│   ├── errors/                 # Error handling
│   └── metrics/                # Metrics collection
├── contracts/                  # SHARED CONTRACTS
│   └── interfaces/             # Common interfaces
└── testing/                    # TEST UTILITIES
    └── helpers/                # Test helpers
```

**Produces:** Go modules/packages (imported by services)

---

## Correct Terminology

### Core Concepts

| Incorrect Term | Correct Term | Definition |
|---------------|--------------|------------|
| "Repo with business logic" | **Service Repository** | Repository containing one microservice |
| "Build deliverable" | **Service Artifact** | Docker image produced by service repo |
| "Config repo" | **GitOps Repository** | Repository with deployment manifests |
| "Shared logic between BC" | **Shared Libraries** | Technical utilities (NOT business logic) |
| "Database in repo" | **Database Schema** | Migration scripts and schema definitions |
| "Config in repo" | **Configuration Templates** | Template files with placeholders |

### Repository Components

| Component | What It Contains | What It Produces |
|-----------|------------------|------------------|
| **Service Implementation** | Business logic, domain models | Compiled binary |
| **Service Contract** | API specs (OpenAPI, gRPC) | Interface definitions |
| **Service Schema** | Database migrations | Schema changes |
| **Service Configuration** | Config templates | Configuration structure |
| **Service Build** | Dockerfile, build scripts | Container image |

### Deployment Components

| Component | What It Contains | Purpose |
|-----------|------------------|---------|
| **Deployment Manifests** | Kubernetes YAML files | Define how to deploy |
| **Environment Configuration** | Environment-specific values | Configure per environment |
| **Platform Resources** | Shared infrastructure | Common platform components |

---

## What Goes Where

### ✅ Service Repository Contains

**Application Code:**
- Business logic (`internal/domain/`)
- API handlers (`internal/api/`)
- Repository implementations (`internal/repository/`)
- Use case services (`internal/service/`)

**Database Schema:**
- Migration files (`database/migrations/001_create_tables.sql`)
- Schema documentation (`database/schema.md`)
- Seed data scripts (`database/seeds/`)

**Configuration Templates:**
```yaml
# configs/app.yaml
database:
  host: ${DB_HOST}              # Template variable
  port: ${DB_PORT}              # Template variable
  maxConnections: 20            # Default value
server:
  port: ${HTTP_PORT}            # Template variable
  timeout: 30s                  # Default value
```

**Build Artifacts:**
- Dockerfile (multi-stage build)
- Makefile (build automation)
- CI pipeline definitions

**API Specifications:**
- OpenAPI specs (`api/openapi/billing-v1.yaml`)
- gRPC proto files (`api/protobuf/billing.proto`)
- Event schemas (`api/events/billing-events.json`)

---

### ✅ GitOps Repository Contains

**Environment-Specific Values:**
```yaml
# environments/production/billing-service/values.yaml
database:
  host: prod-postgres.aws.com   # Actual production value
  port: 5432                    # Actual production value
server:
  port: 8080                    # Actual production value
  replicas: 3                   # Production scaling
```

**Kubernetes Manifests:**
- Deployments (`k8s/deployment.yaml`)
- Services (`k8s/service.yaml`)
- ConfigMaps (`k8s/configmap.yaml`)
- Secrets references (`k8s/secret.yaml`)

**Platform Configuration:**
- Ingress rules (for all services)
- Monitoring configuration
- Security policies
- Network policies

---

### ✅ Shared Libraries Contains

**Technical Utilities Only:**
```go
// common/logging/logger.go
package logging

func NewStructuredLogger() Logger {
    // Shared logging implementation
}

// events/billing/events.go  
package billing

type InvoiceCreated struct {
    InvoiceID string
    ClientID  string        
    Amount    decimal.Decimal
    Timestamp time.Time
}
```

**Cross-Cutting Concerns:**
- Error handling patterns
- Metrics collection
- Distributed tracing
- Event definitions (structure only)

---

### ❌ What Does NOT Go Where

**Service Repository should NOT contain:**
- Environment-specific configuration values
- Kubernetes deployment manifests
- Other services' code
- Shared business logic (violates DDD)

**GitOps Repository should NOT contain:**
- Application source code
- Database data
- Secrets (use secret management)
- Build scripts

**Shared Libraries should NOT contain:**
- Business logic from bounded contexts
- Database access code
- Service-specific utilities
- Complete applications

---

## Versioning Strategy

### Service Artifact Versioning

**Docker Image Tags:**
```
billing-service:v1.2.3          # Semantic versioning
billing-service:v1.2.3-abc123   # With git commit hash
billing-service:latest          # Latest stable (production)
billing-service:develop         # Latest development
```

**What's Included in Each Version:**
```
billing-service:v1.2.3
├── Compiled Go binary (business logic)
├── Configuration schema (what configs are needed)
├── Database migrations (up to version X)
├── API contracts (OpenAPI v1.2.3)
└── Dependencies (Go modules)
```

### GitOps Repository Versioning

**Git Commits Track Environment State:**
```
Environment "production" at commit abc123:
├── billing-service: v1.2.3     # Service version deployed
├── catalog-service: v2.0.1     # Service version deployed  
├── order-service: v1.0.0       # Service version deployed
└── platform-version: v3.1.0    # Platform components version
```

### Library Versioning

**Go Module Versioning:**
```go
// go.mod in billing-service
require (
    github.com/yourorg/gotuto-libraries/events v1.2.0
    github.com/yourorg/gotuto-libraries/common v1.1.5
)
```

---

## Configuration Management

### Templates vs Values Pattern

**In Service Repository (Templates):**
```yaml
# configs/app.yaml - CONFIGURATION TEMPLATE
database:
  host: ${DB_HOST}              # Placeholder
  port: ${DB_PORT}              # Placeholder  
  name: ${DB_NAME}              # Placeholder
  maxConnections: 20            # Default value
  timeout: 30s                  # Default value

server:
  port: ${HTTP_PORT}            # Placeholder
  readTimeout: 10s              # Default value
  writeTimeout: 10s             # Default value

logging:
  level: ${LOG_LEVEL}           # Placeholder
  format: json                  # Default value
```

**In GitOps Repository (Values):**
```yaml
# environments/production/billing-service/values.yaml
database:
  host: prod-billing-db.internal    # Actual value
  port: 5432                        # Actual value
  name: billing_prod                # Actual value

server:
  port: 8080                        # Actual value
  replicas: 3                       # Environment-specific

logging:
  level: info                       # Actual value
```

**Runtime Resolution:**
```
Container Startup:
1. Load template from service image
2. Replace ${VARIABLES} with values from environment
3. Result: Working configuration for that environment
```

### Configuration Hierarchy

```
Final Configuration = 
  Service Defaults + 
  Environment Overrides + 
  Runtime Environment Variables
```

---

## Database Management

### What Goes in Service Repository

**Migration Files:**
```sql
-- database/migrations/001_create_billing_schema.up.sql
CREATE SCHEMA IF NOT EXISTS billing;

CREATE TABLE billing.clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Schema Documentation:**
```markdown
# database/schema.md
## Billing Service Database Schema

### Tables
- `clients`: Customer information
- `invoices`: Invoice records
- `payments`: Payment transactions

### Relationships
- One client can have many invoices
- One invoice can have many payments
```

**Seed Data Scripts:**
```sql
-- database/seeds/dev_data.sql
INSERT INTO billing.clients (name, email) VALUES
('Test Client 1', 'test1@example.com'),
('Test Client 2', 'test2@example.com');
```

### What Does NOT Go in Repository

❌ **Actual Database Data**
❌ **Database Backups**  
❌ **Database Credentials**
❌ **Database Connection Strings** (use config templates)

### Database per Service Pattern

**Each Service Repository Manages:**
- Its own database schema
- Its own migrations
- Its own seed data
- Its own database documentation

**Database Isolation:**
```
PostgreSQL Instance:
├── billing_dev (schema owned by billing-service)
├── catalog_dev (schema owned by catalog-service)  
└── order_dev (schema owned by order-service)
```

---

## Common Misconceptions

### ❌ Misconception 1: "Put database in the repo"
**Wrong Understanding:** Repository contains database files/data
**Correct Understanding:** Repository contains database schema definitions and migrations

### ❌ Misconception 2: "Share business logic between contexts"
**Wrong Understanding:** Create shared repository for business rules
**Correct Understanding:** Each bounded context owns its business logic completely

### ❌ Misconception 3: "Config repository per service"
**Wrong Understanding:** `billing-config/`, `catalog-config/` repositories
**Correct Understanding:** Config templates in service repo, values in GitOps repo

### ❌ Misconception 4: "Deployment repository per service"
**Wrong Understanding:** `billing-k8s/`, `catalog-k8s/` repositories
**Correct Understanding:** All deployment configs in single GitOps repository

### ❌ Misconception 5: "One artifact contains everything"
**Wrong Understanding:** Single deliverable with code + config + data
**Correct Understanding:** Service artifact (image) + deployment manifests + config values

---

## Real Examples

### Example 1: E-commerce Platform

**Service Repositories:**
```
github.com/company/billing-service/
github.com/company/catalog-service/
github.com/company/order-service/
github.com/company/user-service/
github.com/company/notification-service/
```

**GitOps Repository:**
```
github.com/company/ecommerce-gitops/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── production/
└── platform/
```

**Shared Libraries:**
```
github.com/company/ecommerce-libraries/
├── events/
├── common/
└── contracts/
```

### Example 2: Financial Services

**Service Repositories:**
```
github.com/bank/account-service/
github.com/bank/transaction-service/
github.com/bank/fraud-service/
github.com/bank/notification-service/
```

**GitOps Repository:**
```
github.com/bank/banking-platform-gitops/
```

**Shared Libraries:**
```
github.com/bank/banking-commons/
```

### Example 3: Your GoTuto Project Evolution

**Current State (Monorepo):**
```
github.com/yourusername/GoTuto/     # Everything in one repo
```

**Target State (Service Repos + GitOps):**
```
github.com/yourusername/billing-service/
github.com/yourusername/catalog-service/
github.com/yourusername/order-service/
github.com/yourusername/gotuto-gitops/
github.com/yourusername/gotuto-libraries/
```

---

## Repository Ownership and Access

### Team Ownership Model

**Service Repository Ownership:**
- **Owner:** Service team (e.g., Billing team owns billing-service)
- **Access:** Full read/write for service team, read-only for others
- **Responsibilities:** Code quality, API contracts, database schema

**GitOps Repository Ownership:**
- **Owner:** Platform/DevOps team
- **Access:** Write access for platform team, read access for service teams
- **Responsibilities:** Deployment strategies, environment management

**Shared Libraries Ownership:**
- **Owner:** Architecture/Platform team
- **Access:** Controlled write access, broad read access
- **Responsibilities:** API stability, backward compatibility

### Security Considerations

**Repository-Level Security:**
- Service repos: Team-based access control
- GitOps repo: Environment-based access (prod restricted)
- Libraries repo: Review-required for changes

**Secret Management:**
- Secrets NOT in any repository
- Use external secret management (Vault, K8s secrets)
- Reference secrets in deployment manifests only

---

## Migration Strategy

### Phase 1: Current Monorepo (Keep)
```
GoTuto/                         # Current state
├── internal/billing/           # Future billing-service
├── internal/catalog/           # Future catalog-service
└── cmd/                        # Service entry points
```

### Phase 2: Extract Services (Month 3-4)
```
billing-service/                # New repository
├── internal/ (from GoTuto)     # Move business logic
├── api/                        # Extract API specs
├── database/                   # Move migrations
└── configs/                    # Create templates
```

### Phase 3: Add GitOps (Month 5)
```
gotuto-gitops/                  # New repository
├── environments/
│   ├── dev/
│   │   ├── billing-service/    # Deployment configs
│   │   └── catalog-service/    # Deployment configs
│   └── production/
└── platform/
```

### Phase 4: Extract Libraries (Month 6)
```
gotuto-libraries/               # New repository
├── events/                     # Shared event definitions
├── common/                     # Common utilities
└── testing/                    # Test helpers
```

---

## Best Practices Summary

### ✅ DO
- **One service repository per bounded context**
- **Single GitOps repository for all deployments**
- **Shared libraries for technical concerns only**
- **Config templates in service repos**
- **Environment values in GitOps repo**
- **Database migrations with service code**

### ❌ DON'T
- **Separate repositories for config/database per service**
- **Share business logic between bounded contexts**
- **Put environment-specific values in service repos**
- **Mix deployment configs with service code**
- **Store secrets in any repository**

### 🎯 Enterprise Patterns
- **Netflix:** Service repos + shared platform repos
- **Uber:** Service repos + GitOps for deployments  
- **Spotify:** Service repos + shared libraries + GitOps
- **Google:** Monorepo (different pattern entirely)

---

*Document Version: 1.0*  
*Last Updated: January 28, 2025*  
*Purpose: Repository organization reference for microservices architecture*
# Go-Labs Platform Architecture

## Overview

A modern microservices platform built with Domain-Driven Design (DDD), Clean Architecture, and Test-Driven Development (TDD) principles. The platform demonstrates enterprise-grade patterns while maintaining simplicity and developer productivity.

### High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Browser (Client)                        │
│                   Desktop / Mobile / Tablet                 │
└─────────────────────────────────────────────────────────────┘
                            ↓ HTTPS
┌─────────────────────────────────────────────────────────────┐
│              React SPA (Modular Monolith)                   │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌────────────┐   │
│  │  Billing  │ │  Catalog  │ │   Order   │ │   Shared   │   │
│  │  Module   │ │  Module   │ │  Module   │ │     UI     │   │
│  └───────────┘ └───────────┘ └───────────┘ └────────────┘   │
│                    Tailwind CSS + Shadcn/ui                 │
└─────────────────────────────────────────────────────────────┘
                        ↓ REST/JSON
┌─────────────────────────────────────────────────────────────┐
│                    Platform BFF (Go)                        │
│       Authentication | Aggregation | Caching | Routing      │
│                    Rate Limiting | CORS                     │
└─────────────────────────────────────────────────────────────┘
          ↓                    ↓                    ↓
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│   Billing API    │ │   Catalog API    │ │    Order API     │
│  Clean Arch (Go) │ │  Clean Arch (Go) │ │  Clean Arch (Go) │
│       DDD        │ │       DDD        │ │       DDD        │
└──────────────────┘ └──────────────────┘ └──────────────────┘
          ↓                    ↓                    ↓
┌──────────────────────────────────────────────────────────────┐
│                    PostgreSQL Database                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │   billing    │  │   catalog    │  │    order     │        │
│  │   schema     │  │   schema     │  │   schema     │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
└──────────────────────────────────────────────────────────────┘
```

### Core Architectural Principles

- **Domain-Driven Design (DDD)**: Clear bounded contexts per service
- **Clean Architecture**: Separation of concerns with dependency inversion
- **Modular Monolith Frontend**: Module isolation with clear boundaries
- **Backend for Frontend (BFF)**: Optimized API aggregation layer
- **Test-Driven Development (TDD)**: Red-Green-Refactor across all layers
- **Schema-Based Multi-Tenancy**: Service isolation at database level

---

## Technology Stack

### Frontend Stack

```
┌─────────────────────────────────────────────────────────────┐
│                     Frontend Technology Stack               │
├─────────────────────────────────────────────────────────────┤
│ Core Framework:                                             │
│   • React 18.3 - UI library with concurrent features        │
│   • TypeScript 5.5 - Type safety and developer experience   │
│   • Vite 5 - Lightning-fast build tool and dev server       │
│                                                             │
│ State Management:                                           │
│   • TanStack Query v5 - Server state & caching              │
│   • Zustand - Lightweight client state                      │
│                                                             │
│ Routing & Navigation:                                       │
│   • TanStack Router - Type-safe routing                     │
│                                                             │
│ Forms & Validation:                                         │
│   • React Hook Form - Performant form handling              │
│   • Zod - Runtime validation with TypeScript inference      │
│                                                             │
│ UI & Styling:                                               │
│   • Tailwind CSS 3.4 - Utility-first CSS framework          │
│   • Shadcn/ui - Copy-paste component library                │
│   • Radix UI - Unstyled, accessible components              │
│   • Lucide React - Beautiful & consistent icons             │
│   • clsx + tailwind-merge - Dynamic class management        │
│                                                             │
│ Testing:                                                    │
│   • Vitest - Unit testing framework (Jest compatible)       │
│   • React Testing Library - Component testing               │
│   • MSW 2.0 - API mocking for tests                         │
│   • Playwright - E2E testing                                │
│                                                             │
│ Code Quality:                                               │
│   • ESLint 9 - Linting with flat config                     │
│   • Prettier 3 - Code formatting                            │
│   • Husky - Git hooks                                       │
│   • lint-staged - Pre-commit checks                         │
│   • Commitlint - Conventional commits                       │
│                                                             │
│ Development Tools:                                          │
│   • @tanstack/react-devtools - Query debugging              │
│   • React DevTools - Component inspection                   │
│   • TypeScript Error Translator - Better error messages     │
└─────────────────────────────────────────────────────────────┘
```

### Backend Stack

- **Language**: Go 1.21+
- **Framework**: Standard library + Gorilla Mux
- **Database**: PostgreSQL 16 with GORM
- **Migration**: golang-migrate
- **Testing**: testify, table-driven tests
- **Dependency Injection**: Custom container with lazy loading

### Infrastructure

- **Container**: Docker & Docker Compose
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus + Grafana (planned)
- **Tracing**: OpenTelemetry + Jaeger (planned)

---

## Architecture Layers

### 1. Presentation Layer (Frontend)

```
platform-ui/
├── src/
│   ├── modules/                    # Domain modules
│   │   ├── billing/
│   │   │   ├── api/                # TanStack Query hooks
│   │   │   │   ├── queries/        # GET operations
│   │   │   │   └── mutations/      # POST/PUT/DELETE
│   │   │   ├── components/         # Feature components
│   │   │   │   ├── ClientList/
│   │   │   │   ├── ClientForm/
│   │   │   │   └── InvoiceTable/
│   │   │   ├── domain/             # Types & models
│   │   │   │   ├── client.ts
│   │   │   │   └── invoice.ts
│   │   │   ├── pages/              # Route pages
│   │   │   │   ├── Dashboard.tsx
│   │   │   │   └── ClientDetail.tsx
│   │   │   ├── stores/             # Module state (Zustand)
│   │   │   ├── hooks/              # Custom hooks
│   │   │   ├── utils/              # Module utilities
│   │   │   └── index.ts            # Public API exports
│   │   │
│   │   ├── catalog/                # Same structure
│   │   ├── order/                  # Same structure
│   │   │
│   │   └── shared/                 # Shared across modules
│   │       ├── ui/                 # Design system components
│   │       │   ├── Button/
│   │       │   ├── Card/
│   │       │   └── Form/
│   │       ├── hooks/              # Shared hooks
│   │       ├── utils/              # Shared utilities
│   │       └── api/                # Base API client
│   │
│   ├── app/                        # Application shell
│   │   ├── router.tsx              # Main routing
│   │   ├── layout/                 # App layout
│   │   │   ├── Header.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   └── Footer.tsx
│   │   └── providers.tsx           # Global providers
│   │
│   └── lib/                        # Third-party configs
│       ├── axios.ts                # HTTP client setup
│       └── query-client.ts         # React Query config
```

### 2. BFF Layer (Backend for Frontend)

```
platform-bff/                       # BFF Service (Go)
├── cmd/
│   └── api/
│       └── main.go                 # Application entry point
├── internal/
│   ├── handlers/                   # HTTP handlers
│   │   ├── client_handler.go       # Client aggregation endpoints
│   │   ├── dashboard_handler.go    # Dashboard data aggregation
│   │   └── health_handler.go       # Health checks
│   ├── clients/                    # Service clients
│   │   ├── billing_client.go       # Billing API client
│   │   ├── catalog_client.go       # Catalog API client
│   │   └── order_client.go         # Order API client
│   ├── middleware/                 # HTTP middleware
│   │   ├── auth.go                 # JWT validation
│   │   ├── cors.go                 # CORS configuration
│   │   └── logging.go              # Request logging
│   ├── aggregators/                # Data aggregation logic
│   │   ├── client_aggregator.go    # Combine client data
│   │   └── dashboard_aggregator.go # Dashboard data assembly
│   ├── config/                     # Configuration
│   │   └── config.go               # App configuration
│   └── server/                     # HTTP server setup
│       └── server.go               # Router and middleware setup
├── pkg/                            # Public packages
│   ├── dto/                        # Data transfer objects
│   │   ├── request.go              # Request DTOs
│   │   └── response.go             # Response DTOs
│   └── utils/                      # Utility functions
├── configs/                        # Configuration files
│   ├── base.yaml
│   ├── development.yaml
│   └── production.yaml
├── Dockerfile                      # Container build
├── Makefile                        # Build automation
├── go.mod                          # Go modules
└── go.sum                          # Dependency locks
```

### BFF Request Flow Diagram

```
Request Flow Through BFF:
┌──────────────────────────────────────────────────┐
│                  Incoming Request                │
│              GET /bff/dashboard/client/123       │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│               Authentication Check               │
│                 Validate JWT Token               │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│              Parallel Service Calls              │
│  ┌──────────────────────────────────────────┐    │
│  │  go func() { fetchClient(123) }          │    │
│  │  go func() { fetchInvoices(123) }        │    │
│  │  go func() { fetchProducts(123) }        │    │
│  └──────────────────────────────────────────┘    │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│            Response Aggregation                  │
│   Combine all responses into single payload      │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│            Return Unified Response               │
│   {                                              │
│     "client": {...},                             │
│     "invoices": [...],                           │
│     "products": [...]                            │
│   }                                              │
└──────────────────────────────────────────────────┘
```

### 3. Service Layer (Microservices)

**Current Implementation**: Traditional service pattern with a single service class handling both reads and writes. No CQRS separation currently implemented.

```
billing-api/                        # Billing Microservice (Go)
├── cmd/
│   ├── api/
│   │   └── main.go                 # API server entry point
│   └── migrator/
│       └── main.go                 # Database migration tool
├── internal/                       # Private application code
│   ├── domain/                     # Domain Layer (Core Business Logic)
│   │   ├── entity/
│   │   │   ├── client.go           # Client aggregate root
│   │   │   └── invoice.go          # Invoice entity (future)
│   │   ├── valueobject/
│   │   │   ├── email.go            # Email value object
│   │   │   ├── phone.go            # Phone value object
│   │   │   └── money.go            # Money value object (future)
│   │   ├── repository/             # Repository interfaces
│   │   │   ├── client_repository.go
│   │   │   └── invoice_repository.go (future)
│   │   └── errors/
│   │       ├── errors.go           # Domain-specific errors
│   │       └── utils.go            # Error utilities
│   │
│   ├── application/                # Application Layer (Use Cases)
│   │   └── billing_service.go      # Service orchestration
│   │
│   ├── infrastructure/             # Infrastructure Layer
│   │   ├── repository/             # Repository implementations
│   │   │   └── client_repository.go # PostgreSQL implementation
│   │   └── storage/
│   │       ├── storage.go          # Storage interface
│   │       └── postgres_storage.go # PostgreSQL storage
│   │
│   ├── api/                        # API Layer (Presentation)
│   │   └── http/
│   │       ├── handlers/           # HTTP handlers
│   │       │   ├── client_handler.go
│   │       │   └── health_handler.go
│   │       ├── middleware/         # HTTP middleware
│   │       │   └── error_handler.go
│   │       ├── dtos/               # Data Transfer Objects
│   │       │   ├── request.go
│   │       │   └── response.go
│   │       └── server.go           # HTTP server setup
│   │
│   ├── di/                         # Dependency Injection
│   │   ├── container.go            # DI container
│   │   ├── providers.go            # Service providers
│   │   └── builders.go             # Component builders
│   │
│   ├── config/                     # Configuration
│   │   ├── loader.go               # Config loader
│   │   └── di_integration.go       # DI config integration
│   │
│   └── migration/                  # Database migrations
│       └── service.go              # Migration service
│
├── database/
│   └── migrations/                 # SQL migration files
│       ├── 001_create_clients_table.up.sql
│       ├── 001_create_clients_table.down.sql
│       └── ...
│
├── tests/                          # Test organization
│   ├── unit/                       # Unit tests
│   │   ├── domain/                 # Domain logic tests
│   │   ├── application/            # Service tests
│   │   └── handlers/               # Handler tests
│   ├── integration/                # Integration tests
│   │   ├── api/                    # API integration tests
│   │   ├── repository/             # Database tests
│   │   └── storage/                # Storage tests
│   ├── testdata/                   # Test fixtures (JSON)
│   │   ├── client/
│   │   └── http/
│   ├── testhelpers/                # Test utilities
│   │   ├── database_cleanup.go
│   │   └── server.go
│   └── reports/                    # Test coverage reports
│       ├── integration-coverage-report.html
│       └── integration-coverage-summary.md
│
├── configs/                        # Configuration files
│   ├── base.yaml                   # Base configuration
│   ├── development.yaml            # Dev overrides
│   ├── test.yaml                   # Test config (PostgreSQL)
│   └── production.yaml             # Production config
│
├── docs/                           # Documentation
│   ├── TEST_STRATEGY.md
│   └── TEST_DATA_ISOLATION.md
│
├── Dockerfile                      # Container build
├── Makefile                        # Build automation
├── go.mod                          # Go modules
├── go.sum                          # Dependency locks
└── CLAUDE.md                       # Service-specific context
```

### Clean Architecture Flow Diagram

```
Clean Architecture Layers per Service:
┌──────────────────────────────────────────────────┐
│                  HTTP Handler                    │
│              (interfaces/rest)                   │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│               Application Service                │
│              (application/usecase)               │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│                Domain Logic                      │
│          (domain/entity & valueobject)           │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│              Repository Interface                │
│             (domain/repository)                  │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│           Repository Implementation              │
│          (infrastructure/repository)             │
└──────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────┐
│                  Database                        │
│                 (PostgreSQL)                     │
└──────────────────────────────────────────────────┘
```

---

## Data Flow

### Frontend to Backend Request Flow

```
User Interaction
       ↓
React Component
       ↓
Form Validation (React Hook Form + Zod)
       ↓
TanStack Query Mutation
       ↓
Axios HTTP Client
       ↓ [HTTPS]
Platform BFF
       ↓ [Internal Network]
Backend Service
       ↓
Domain Logic
       ↓
PostgreSQL
       ↓
Response Transformation
       ↓ [All the way back]
UI Update
```

### Module Boundary Enforcement

```
✅ Allowed:
billing/
  └── components/ClientForm.tsx
      import { Button } from '@/modules/shared/ui'
      import { useAuth } from '@/modules/shared/hooks'
      import { createClient } from '../api/mutations'

❌ Not Allowed:
billing/
  └── components/ClientForm.tsx
      import { InvoiceList } from '@/modules/catalog/components'
      // Error: Cross-module import violation!
```

---

## Development & Deployment Environments

### Local Development Architecture (Non-Containerized)

```
┌────────────────────────────────────────────────────────┐
│                   Developer Machine                    │
├────────────────────────────────────────────────────────┤
│                                                        │
│    ┌──────────────────────────────────────────────┐    │
│    │            Browser (localhost:5173)          │    │
│    └──────────────────────────────────────────────┘    │
│                          ↓                             │
│    ┌──────────────────────────────────────────────┐    │
│    │     React Dev Server (Vite with HMR)         │    │
│    │          npm run dev - Port 5173             │    │
│    └──────────────────────────────────────────────┘    │
│                          ↓                             │
│    ┌──────────────────────────────────────────────┐    │
│    │         Platform BFF (Go Service)            │    │
│    │           go run . - Port 8080               │    │
│    └──────────────────────────────────────────────┘    │
│                 ↓                   ↓                  │
│        ┌─────────────────┐ ┌─────────────────┐         │
│        │  Billing API    │ │  Catalog API    │         │
│        │  make run-dev   │ │  make run-dev   │         │
│        │   Port 8081     │ │   Port 8082     │         │
│        └─────────────────┘ └─────────────────┘         │
│                 ↓                   ↓                  │
│    ┌──────────────────────────────────────────────┐    │
│    │      PostgreSQL (Native Installation)        │    │
│    │         systemctl status postgresql          │    │
│    │              Port 5432                       │    │
│    └──────────────────────────────────────────────┘    │
└────────────────────────────────────────────────────────┘

Terminal Windows:
┌─────────────────────────┬─────────────────────────┐
│   1. Frontend (Vite)    │   2. BFF Service        │
│   cd platform-ui        │   cd platform-bff       │
│   npm run dev           │   go run .              │
│   http://localhost:5173 │   http://localhost:8080 │
├─────────────────────────┼─────────────────────────┤
│   3. Billing Service    │   4. Catalog Service    │
│   cd billing-api        │   cd catalog-api        │
│   make run-dev          │   make run-dev          │
│   http://localhost:8081 │   http://localhost:8082 │
├─────────────────────────┴─────────────────────────┤
│        5. PostgreSQL (Native Installation)        │
│        Already running as system service          │
│        postgresql://localhost:5432/go-labs-dev    │
└───────────────────────────────────────────────────┘
```

### Production Deployment - OpenShift Architecture

```
┌────────────────────────────────────────────────────────┐
│                    Internet Users                      │
└────────────────────────────────────────────────────────┘
                            ↓ HTTPS
┌────────────────────────────────────────────────────────┐
│              OpenShift Router (HAProxy)                │
│                   *.apps.openshift.domain              │
└────────────────────────────────────────────────────────┘
                            ↓
┌────────────────────────────────────────────────────────┐
│              OpenShift Project: go-labs-prod           │
├────────────────────────────────────────────────────────┤
│                                                        │
│    ┌──────────────────────────────────────────────┐    │
│    │            Route: platform-ui                │    │
│    │    platform-ui.apps.openshift.domain         │    │
│    └──────────────────────────────────────────────┘    │
│                          ↓                             │
│    ┌──────────────────────────────────────────────┐    │
│    │     Pod: platform-ui (Replicas: 3)           │    │
│    │     - Nginx serving React build              │    │
│    │     - ConfigMap: nginx.conf                  │    │
│    └──────────────────────────────────────────────┘    │
│                          ↓                             │
│    ┌──────────────────────────────────────────────┐    │
│    │            Route: platform-bff               │    │
│    │    platform-bff.apps.openshift.domain        │    │
│    └──────────────────────────────────────────────┘    │
│                          ↓                             │
│    ┌──────────────────────────────────────────────┐    │
│    │     Pod: platform-bff (Replicas: 3)          │    │
│    │     - Go binary with health checks           │    │
│    │     - HPA: CPU 80% (min:2, max:10)           │    │
│    └──────────────────────────────────────────────┘    │
│                      ↓         ↓                       │
│        ┌─────────────────┐ ┌─────────────────┐         │
│        │ Pod: billing-api│ │Pod: catalog-api │         │
│        │  (Replicas: 3)  │ │ (Replicas: 3)   │         │
│        └─────────────────┘ └─────────────────┘         │
│                      ↓         ↓                       │
│    ┌──────────────────────────────────────────────┐    │
│    │    StatefulSet: PostgreSQL (HA Cluster)      │    │
│    │    - Primary + 2 Read Replicas               │    │
│    │    - PersistentVolume: 100Gi SSD             │    │
│    └──────────────────────────────────────────────┘    │
└────────────────────────────────────────────────────────┘

OpenShift Resources:
┌──────────────────────────────────────────────────┐
│                go-labs-dev (namespace)           │
├──────────────────────────────────────────────────┤
│  DeploymentConfigs:                              │
│  ├── platform-ui-dc                              │
│  ├── platform-bff-dc                             │
│  ├── billing-api-dc                              │
│  └── catalog-api-dc                              │
│                                                  │
│  Services:                                       │
│  ├── platform-ui-svc  (ClusterIP)                │
│  ├── platform-bff-svc (ClusterIP)                │
│  ├── billing-api-svc  (ClusterIP)                │
│  └── postgresql-svc   (ClusterIP)                │
│                                                  │
│  Routes (Ingress):                               │
│  ├── platform-ui.apps.openshift.domain           │
│  └── platform-bff.apps.openshift.domain          │
│                                                  │
│  ConfigMaps:                                     │
│  ├── app-config                                  │
│  └── nginx-config                                │
│                                                  │
│  Secrets:                                        │
│  ├── db-credentials                              │
│  └── api-keys                                    │
└──────────────────────────────────────────────────┘
```

### OpenShift Build Strategy (S2I - Source-to-Image)

```yaml
# BuildConfig Example for Go Service
apiVersion: build.openshift.io/v1
kind: BuildConfig
metadata:
  name: billing-api-bc
spec:
  source:
    type: Git
    git:
      uri: https://github.com/your-org/go-labs
      ref: main
    contextDir: billing-api
  strategy:
    type: Source
    sourceStrategy:
      from:
        kind: ImageStreamTag
        name: golang:1.21
        namespace: openshift
  output:
    to:
      kind: ImageStreamTag
      name: billing-api:latest
```

### OpenShift Deployment Commands

```bash
# Login to OpenShift
oc login https://api.openshift.domain:6443

# Create new project
oc new-project go-labs-dev

# Deploy PostgreSQL
oc new-app postgresql-persistent \
  -p POSTGRESQL_USER=gouser \
  -p POSTGRESQL_PASSWORD=secret \
  -p POSTGRESQL_DATABASE=golabs

# Build and deploy services
oc new-app https://github.com/your-org/go-labs \
  --context-dir=billing-api \
  --name=billing-api

# Expose services via routes
oc expose svc/platform-ui
oc expose svc/platform-bff

# Scale deployments
oc scale --replicas=3 dc/billing-api

# Configure horizontal pod autoscaling
oc autoscale dc/billing-api --min=2 --max=10 --cpu-percent=80
```

### OpenShift CI/CD Pipeline (Tekton)

```yaml
# Pipeline for building and deploying services
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: go-labs-pipeline
spec:
  params:
    - name: git-repo
      type: string
    - name: git-revision
      type: string
  tasks:
    - name: git-clone
      taskRef:
        name: git-clone
      params:
        - name: url
          value: $(params.git-repo)
        - name: revision
          value: $(params.git-revision)

    - name: run-tests
      taskRef:
        name: golang-test
      runAfter:
        - git-clone

    - name: build-image
      taskRef:
        name: s2i-go
      runAfter:
        - run-tests

    - name: deploy
      taskRef:
        name: openshift-deploy
      runAfter:
        - build-image
```

### Environment Promotion Strategy

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│     DEV      │────▶│   STAGING    │────▶│   PRODUCTION │
│  Namespace   │     │  Namespace   │     │   Namespace  │
└──────────────┘     └──────────────┘     └──────────────┘
  - Auto deploy       - Manual promotion   - Manual promotion
  - Latest builds     - Tagged versions     - Stable releases
  - Debug enabled     - Prod-like config    - HA configuration
```

### Local vs Production Environment Comparison

| Aspect | Local Development | OpenShift Production |
|--------|------------------|---------------------|
| **Frontend** | Vite dev server (HMR) | Nginx static hosting |
| **Backend** | `go run` with hot reload | Compiled Go binaries |
| **Database** | Single PostgreSQL instance | PostgreSQL HA cluster |
| **Networking** | Direct localhost ports | Service mesh + Routes |
| **Scaling** | Single instance | HPA with 3+ replicas |
| **Configuration** | `.env` files | ConfigMaps + Secrets |
| **Monitoring** | Console logs | Prometheus + Grafana |
| **Builds** | Local compilation | S2I automated builds |
| **Deployment** | Manual restart | Rolling deployments |
| **Storage** | Local filesystem | PersistentVolumes |

---

## Testing Strategy

### Testing Pyramid

```
                     --
                    /  \
                   /    \
                  / E2E  \          Playwright
                 / Tests  \        (5% - Critical paths)
                /──────────\
               /            \
              / Integration  \    Vitest + MSW + RTL
             /     Tests      \   (25% - API & Components)
            /──────────────────\
           /                    \
          /    Component Tests   \   React Testing Library
         /                        \  (35% - UI behavior)
        /──────────────────────────\
       /                            \
      /         Unit Tests           \  Vitest
     /                                \ (35% - Business logic)
    /──────────────────────────────────\
```

### Test Organization

```
Frontend Tests:
tests/
├── unit/           # Pure functions, utilities
├── components/     # Component behavior
├── integration/    # API integration with MSW
├── e2e/           # Full user journeys
└── fixtures/      # Test data

Backend Tests:
tests/
├── unit/          # Domain logic, use cases
├── integration/   # Database, API endpoints
├── testdata/      # JSON fixtures
└── testhelpers/   # Test utilities
```

---

## Security Architecture

### Authentication & Authorization Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Browser   │────▶│     BFF     │────▶│   Service   │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                    │
   JWT Token          Validate JWT         Service Token
   in Cookie          Extract User         for Internal
                      Add Context           Communication

Security Boundaries:
• Public Internet  ←→  BFF (HTTPS, CORS, Rate Limiting)
• BFF  ←→  Services (Internal network, Service tokens)
• Services  ←→  Database (Connection pooling, Prepared statements)
```

---

## Future Enhancements

### Near Term (Q1 2025)

```
┌────────────────────────────────────────────────────┐
│ Observability & Monitoring                         │
├────────────────────────────────────────────────────┤
│ • OpenTelemetry integration                        │
│ • Distributed tracing with Jaeger                  │
│ • Prometheus metrics collection                    │
│ • Grafana dashboards                               │
│ • Centralized logging (ELK stack)                  │
│ • Health checks and readiness probes               │
└────────────────────────────────────────────────────┘
```

### Medium Term (Q2 2025)

```
┌────────────────────────────────────────────────────┐
│ Real-Time Communication                            │
├────────────────────────────────────────────────────┤
│ • WebSocket support for live updates               │
│   - Order status updates                           │
│   - Inventory changes                              │
│   - Notification system                            │
│ • Server-Sent Events (SSE) for simpler cases       │
│ • GraphQL subscriptions (evaluation)               │
└────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────┐
│ Service Communication                              │
├────────────────────────────────────────────────────┤
│ • gRPC for internal service communication          │
│ • Protocol Buffers for schema definition           │
│ • Service mesh evaluation (Istio/Linkerd)          │
│ • Event-driven architecture                        │
│   - Apache Kafka or NATS                           │
│   - Event sourcing for audit trail                 │
└────────────────────────────────────────────────────┘
```

### Long Term (Q3+ 2025)

```
┌────────────────────────────────────────────────────┐
│ Advanced Patterns                                  │
├────────────────────────────────────────────────────┤
│ • CQRS (Command Query Responsibility Segregation)  │
│   - When read/write patterns diverge               │
│   - Separate models for commands and queries       │
│   - Different scaling strategies for reads/writes  │
│ • Event Sourcing for complete audit trail          │
│ • Saga pattern for distributed transactions        │
│ • Circuit breakers (Hystrix pattern)               │
│ • API versioning strategy                          │
│ • Blue-Green deployments                           │
└────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────┐
│ Performance & Scaling                              │
├────────────────────────────────────────────────────┤
│ • Redis caching layer                              │
│ • CDN integration (CloudFlare/Fastly)              │
│ • Database read replicas                           │
│ • Horizontal scaling with Kubernetes               │
│ • Auto-scaling policies                            │
│ • Performance testing with k6                      │
└────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────┐
│ Frontend Evolution                                 │
├────────────────────────────────────────────────────┤
│ • Micro Frontends with Module Federation           │
│ • Progressive Web App (PWA) capabilities           │
│ • Offline support with service workers             │
│ • Internationalization (i18n)                      │
│ • A/B testing framework                            │
│ • Analytics integration                            │
└────────────────────────────────────────────────────┘
```

---

## Technology Radar

### Adopt Now
- React with TypeScript
- Go for backend services
- PostgreSQL
- OpenShift for container orchestration
- TDD methodology
- Clean Architecture
- S2I (Source-to-Image) builds

### Trial
- BFF pattern
- Modular monolith frontend
- TanStack Query
- Vitest
- Shadcn/ui

### Assess
- gRPC for internal communication
- GraphQL Gateway
- WebSocket for real-time
- Service mesh
- Event-driven architecture
- Micro frontends

### Hold
- Microservices for frontend (too early)
- NoSQL (PostgreSQL handles current needs)
- Docker for local development (using native processes)
- Serverless (doesn't fit learning goals)

---

## Migration Paths

### Frontend: Modular Monolith → Micro Frontends

```
Current State:          Intermediate:           Target State:
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│   Monolith   │  →    │  Extract One │  →    │    Module    │
│   All modules│       │    Module    │       │  Federation  │
│   together   │       │   Keep rest  │       │  All separate│
└──────────────┘       └──────────────┘       └──────────────┘

Steps:
1. Enforce strict module boundaries
2. Extract shared UI to package
3. Move one module to separate app
4. Implement Module Federation
5. Gradually extract remaining modules
```

### Backend: REST → GraphQL

```
Current:               Hybrid:                 Future:
┌──────────────┐      ┌──────────────┐       ┌──────────────┐
│   REST APIs  │  →   │  GraphQL     │  →    │  Pure        │
│              │      │  Gateway +   │       │  GraphQL     │
│              │      │  REST APIs   │       │              │
└──────────────┘      └──────────────┘       └──────────────┘

Benefits:
• Single endpoint for frontend
• Reduced over-fetching
• Strong typing with schema
• Better developer experience
```

---

## Decision Log

| Decision | Rationale | Date |
|----------|-----------|------|
| Modular Monolith Frontend | Simpler than micro frontends, can evolve later | 2024-08 |
| BFF Pattern | Optimize for frontend needs, aggregate backend calls | 2024-08 |
| PostgreSQL Only | Sufficient for current needs, reduce complexity | 2024-08 |
| Go for All Services | Single language reduces context switching | 2024-08 |
| TDD Methodology | Ensures quality and serves learning goals | 2024-08 |
| OpenShift Platform | Enterprise container platform with integrated tooling | 2024-08 |
| Non-containerized Local Dev | Simpler development workflow, faster iteration | 2024-08 |

---

## Glossary

- **BFF**: Backend for Frontend - API layer optimized for specific frontend
- **DDD**: Domain-Driven Design - Software design approach focusing on business domains
- **Clean Architecture**: Architectural pattern emphasizing separation of concerns
- **TDD**: Test-Driven Development - Write tests before implementation
- **CQRS**: Command Query Responsibility Segregation - Separate read and write models (planned for future)
- **MSW**: Mock Service Worker - API mocking library for testing
- **SSE**: Server-Sent Events - Protocol for server-to-client streaming
- **S2I**: Source-to-Image - OpenShift build strategy for creating container images from source code

---

*This architecture document is a living document and will evolve as the platform grows.*

# Claude Memory - GoTuto Project

## 🚨 MANDATORY TDD WORKFLOW - NO EXCEPTIONS 🚨

### Workflow Enforcement
**YOU MUST FOLLOW THIS EXACT SEQUENCE:**
1. **EXPLORE** → Research and understand requirements (READ-ONLY - no code)
2. **PLAN** → Create detailed implementation plan with test scenarios
3. **STOP** → MANDATORY pause - present plan for human review/approval
4. **TEST** → Write failing tests first (Red phase)
5. **CODE** → Write minimal code to pass tests (Green phase)
6. **REFACTOR** → Improve code quality while keeping tests green
7. **COMMIT & PUSH** → Create feature branch, commit with standard message, push to remote
8. **CREATE PR** → Generate pull request with detailed description and request code review
9. **CLAUDE GITHUB REVIEW LOOP** → Iterative collaborative review with approval gates
10. **MERGE** → User-approved merge to main branch

**⛔ BREAKING THESE RULES = IMMEDIATE STOP**

### Anti-Pattern Prevention
- **NO** production code without failing tests first
- **NO** implementing features not covered by tests
- **NO** skipping the planning phase - EVER
- **NO** implementing beyond the requirements (YAGNI)
- **NO** continuing after PLAN without explicit approval
- **NO** committing without proper feature branch and descriptive message
- **NO** manual PR creation - always use automated workflow
- **NO** auto-merging without explicit user permission
- **ALWAYS** use scope constraints in requirements
- **ALWAYS** check against overengineering
- **ALWAYS** create feature branch named `feature/[feature-name-kebab-case]`
- **ALWAYS** push to remote after successful implementation
- **ALWAYS** create PR immediately after successful push with comprehensive description
- **ALWAYS** wait for Claude GitHub review before asking for merge approval
- **ALWAYS** work in iterative loop with Claude GitHub until no recommendations OR user rejects fixes

### Go-Specific Testing Standards
- Test files MUST end with `_test.go`
- Use table-driven tests for multiple scenarios
- Prefer `testify/assert` and `testify/require` for assertions
- Unit tests go in same package, integration tests in `_test` package
- Minimum 95% test coverage for new code
- Use `t.Run()` for subtests
- Mock interfaces, not concrete types

### Available Commands (Project-Specific)
- `/explore-feature` - Research phase (no coding)
- `/plan-feature` - Create plan (stops for approval)
- `/requirements-spec` - Define precise requirements
- `/scope-check` - Validate against overengineering
- `/test-first` - Write failing tests
- `/implement-minimal` - Write minimal passing code
- `/analyze-pr-feedback` - Process Claude GitHub review feedback

**Note**: These commands are defined in `.claude/commands/` and are go-labs project-specific implementations of the generic TDD workflow available at https://github.com/Gaetan-Jaminon/Claude-Workflow-TDD

### Project Organization - IMPORTANT: Multiple Git Repositories
**⚠️ CRITICAL**: This is NOT a monorepo. Each component is a separate Git repository:

#### Repository Structure:
1. **Root Repository** (`/home/gaetan/Projects/go-labs/`):
   - GitHub: `Gaetan-Jaminon/Claude-Workflow-TDD`
   - Purpose: Generic TDD workflow methodology
   - Contains: `.claude/` commands, workflow documentation
   - **Note**: Root CLAUDE.md is for generic workflow, NOT for go-labs project

2. **Go-Labs Memory Location**:
   - **IMPORTANT**: Go-labs project memory is in `platform-docs/CLAUDE.md` (this file)
   - **NOT** in root `/home/gaetan/Projects/go-labs/CLAUDE.md`
   - Always update THIS file for go-labs specific information

3. **Service Repositories** (each is independent):
   - `services/billing-api/` → GitHub: `gjaminon-go-labs/billing-api`
   - `services/catalog-api/` → GitHub: `gjaminon-go-labs/catalog-api` (future)
   - `services/order-api/` → GitHub: `gjaminon-go-labs/order-api` (future)

4. **Shared Directories** (in root repo):
   - `platform-docs/` - Platform architecture and documentation (includes THIS memory file)
   - `infrastructure/` - OpenShift/Kubernetes manifests and configs

#### CI/CD Implications:
- Each service has its own `.github/workflows/` in its own repo
- Each service has independent versioning and releases
- No monorepo tooling needed (no path filters, no shared workflows)
- GitHub Actions workflows go in each service's repository

---

## Project Overview
**Goal:** Learn Go as a .NET developer through practical Domain-Driven Design (DDD) implementation  
**Architecture:** Clean Architecture with DDD, dependency injection, and comprehensive testing strategy  
**Current Status:** Complete Client CRUD Operations (All 4 Use Cases) with Claude GitHub Review Integration

## Project Structure
```
go-labs/
├── .claude/                    # Workflow commands (generic, reusable)
├── platform-docs/              # Platform documentation
│   ├── ARCHITECTURE.md        # System architecture
│   └── README.md              # Project overview
├── services/                   # Backend services
│   ├── billing-api/           # Billing microservice
│   ├── catalog-api/           # Catalog microservice
│   └── go-common/             # Shared libraries
├── frontend/                   # Frontend applications (future)
├── infrastructure/             # Infrastructure as code
└── learning_notes/            # Architecture decisions

services/billing-api/
├── cmd/                         # Application entry points
│   ├── api/                    # Main REST API server
│   └── migrator/               # Database migration CLI tool
├── internal/                   # Internal application code
│   ├── domain/                 # Domain Layer (Business Logic)
│   │   ├── entity/            # Entities (Client)
│   │   ├── valueobject/       # Value Objects (Email, Phone)
│   │   ├── repository/        # Repository interfaces
│   │   └── errors/            # Domain-specific errors
│   ├── application/           # Application Layer (Use Cases)
│   │   ├── command/           # Commands and DTOs
│   │   └── usecase/           # Use case implementations
│   ├── infrastructure/        # Infrastructure Layer
│   │   ├── storage/           # Storage implementations (memory, postgres)
│   │   ├── persistence/       # PostgreSQL repository implementation
│   │   └── config/            # Configuration management
│   ├── interfaces/            # Interface Layer
│   │   └── rest/              # HTTP handlers and routing
│   ├── api/                   # API Layer
│   │   └── http/              # HTTP server and middleware
│   ├── di/                    # Dependency Injection
│   │   └── container.go       # DI container with lazy initialization
│   ├── config/                # Configuration loader
│   ├── migration/             # Migration service with golang-migrate
│   └── database/              # Database utilities
│       └── migrations/        # SQL migration files
├── tests/                     # Test organization
│   ├── unit/                  # Unit tests (memory storage)
│   ├── integration/           # Integration tests (PostgreSQL)
│   ├── testhelpers/          # Test utilities and bootstraps
│   └── testdata/             # External test data (JSON files)
├── configs/                   # YAML configuration files
│   ├── base.yaml             # Base configuration
│   ├── development.yaml      # Development overrides
│   ├── test.yaml             # Test environment (PostgreSQL)
│   └── production.yaml       # Production configuration
├── docs/                      # Documentation
│   ├── TEST_STRATEGY.md      # Comprehensive testing documentation
│   └── INTEGRATION_TYPES.md  # Integration patterns explanation
└── Makefile                  # Build and development automation
```

## Implementation Status

### ✅ COMPLETED - Complete Client CRUD Operations

#### All 4 Use Cases Successfully Implemented:
1. **UC-B-001: Create Client** ✅
   - Full validation: Email format, name length, phone format
   - Business Rules: Email uniqueness, field constraints
   - Error Handling: Structured validation and domain errors
   - REST API: Complete POST /api/v1/clients endpoint
   - Storage: Both in-memory (tests) and PostgreSQL implementations

2. **UC-B-002: Get Client by ID** ✅
   - UUID validation with google/uuid library
   - Proper error handling for not found scenarios
   - REST API: Complete GET /api/v1/clients/:id endpoint
   - Repository pattern with interface-based design

3. **UC-B-003: Update Client** ✅
   - Partial updates with field validation
   - Business rule enforcement (email uniqueness)
   - REST API: Complete PUT /api/v1/clients/:id endpoint
   - Transactional updates with rollback support

4. **UC-B-004: Delete Client** ✅
   - Hard delete implementation (no soft delete)
   - Cascading deletes handled properly
   - REST API: Complete DELETE /api/v1/clients/:id endpoint
   - Comprehensive error handling

### ✅ COMPLETED - Claude GitHub Review Integration

#### Collaborative AI Review Workflow:
- **2-Round Review Process**: Iterative improvement cycles implemented
- **Round 1 Improvements Applied**:
  - UUID validation enhancement with google/uuid
  - Error handling improvements with proper wrapping
  - HTTP status code mapping for repository errors
  - Phone validation with E.164 standard compliance
- **Round 2 Decision**: Future enhancement suggestions declined by user
- **User Approval Gates**: All merge decisions require explicit user permission
- **Quality Assurance**: Never auto-merge, always collaborative decision-making

### ✅ COMPLETED - Advanced Testing Infrastructure

#### Business Coverage Reporting System:
- **Stakeholder Reports**: Non-technical test coverage documentation
- **HTML Reports**: Visual test coverage with business descriptions
- **Markdown Summaries**: Stakeholder-friendly test documentation
- **Integration with TDD**: Business descriptions mandatory for integration tests
- **Command**: `make test-integration-report` generates comprehensive reports

#### Test Data Isolation System:
- **Automatic Cleanup**: DELETE-based cleanup between integration tests
- **No Superuser Required**: Works with application user permissions
- **Foreign Key Compliance**: Respects database constraints during cleanup
- **Fresh State Guarantee**: Each test run starts with clean database
- **Performance Optimized**: Efficient cleanup for test data volumes

### ✅ COMPLETED - Infrastructure & Architecture

#### Application Dependencies Architecture:
- **Shared Database Strategy**: `go-labs-dev` and `go-labs-tst` with schema isolation
- **RBAC Implementation**: Service-specific users (migration vs application)
- **Environment Separation**: Dev, test, and production database configurations
- **Infrastructure as Code**: Template-based database provisioning system

#### Dependency Injection Container:
- **Lazy Initialization**: Components created only when needed
- **Thread-Safe**: Singleton pattern with proper synchronization
- **Environment-Aware**: Different configurations for test/dev/prod
- **Clean Architecture**: Maintains layer separation and dependency flow

#### Advanced Development Environment:
- **Make-based Workflow**: Comprehensive commands for all operations
- **Environment Separation**: Dev, test, and production databases
- **Auto-setup Commands**: `make dev-setup` for complete environment
- **Smart Test Commands**: Automatic PostgreSQL management

### ✅ COMPLETED - Repository Pattern & Storage Abstraction

#### Extended Interfaces:
```go
// Storage interface with full CRUD operations
type Storage interface {
    Create(ctx context.Context, key string, value interface{}) error
    Get(ctx context.Context, key string, result interface{}) error
    Update(ctx context.Context, key string, value interface{}) error
    Delete(ctx context.Context, key string) error
    List(ctx context.Context, prefix string) ([]string, error)
}

// Repository interface with domain-specific operations
type ClientRepository interface {
    Create(ctx context.Context, client *entity.Client) error
    GetByID(ctx context.Context, id string) (*entity.Client, error)
    Update(ctx context.Context, client *entity.Client) error
    Delete(ctx context.Context, id string) error
    ExistsByEmail(ctx context.Context, email string) (bool, error)
}
```

#### Implementation Highlights:
- **Error Handling**: Proper domain error mapping with HTTP status codes
- **UUID Validation**: google/uuid library for robust ID validation
- **Phone Validation**: E.164 standard compliance with international format
- **Database Transactions**: GORM integration with proper transaction handling

## Recent Session Summary (August 4, 2025)

### 🎯 Major Accomplishments
1. **Complete Client CRUD Implementation** - All 4 use cases following strict TDD methodology
2. **Claude GitHub Review Integration** - 2-round iterative improvement process with user approval gates
3. **Business Test Coverage System** - Stakeholder-friendly reporting for non-technical audiences
4. **Standalone TDD Workflow Repository** - Reusable workflow system at https://github.com/Gaetan-Jaminon/Claude-Workflow-TDD
5. **Project Memory Restoration** - Comprehensive documentation of all achievements and current state

### 🔧 Technical Implementation Details

#### Client CRUD Operations (UC-B-002, UC-B-003, UC-B-004):
- **Files Created/Updated**: 20 files total with 1,851 additions
- **Test Coverage**: Comprehensive unit and integration tests for all operations
- **Error Handling**: Structured domain errors with proper HTTP status mapping
- **Validation**: UUID validation, phone format validation, business rule enforcement
- **Repository Pattern**: Extended interfaces with full CRUD implementation

#### Claude GitHub Review Process:
- **Round 1**: 4 critical improvements identified and applied
  - UUID validation with google/uuid library
  - Enhanced error handling with proper error wrapping
  - HTTP status code mapping for repository errors
  - Phone validation improvements with E.164 compliance
- **Round 2**: Future enhancement suggestions presented and declined by user
- **Outcome**: Production-ready code with user-approved quality level

#### Business Coverage Reporting:
- **Purpose**: Bridge technical and business stakeholder communication
- **Format**: HTML and Markdown reports with business-friendly descriptions
- **Integration**: Mandatory business descriptions for all integration tests
- **Automation**: `make test-integration-report` generates comprehensive reports

### 🏗️ Architecture Achievements

#### Clean Architecture Compliance:
- **Domain Layer**: Rich entities with business logic, no external dependencies
- **Application Layer**: Use cases and services depending only on domain
- **Infrastructure Layer**: Database and external integrations implementing domain interfaces
- **API Layer**: HTTP handlers orchestrating application layer operations

#### Testing Strategy Excellence:
- **Unit Tests**: Fast, isolated testing with in-memory storage (< 1 second feedback)
- **Integration Tests**: Real PostgreSQL behavior with automatic cleanup
- **Business Documentation**: Non-technical test descriptions for stakeholder reporting
- **TDD Compliance**: All production code written after failing tests (Red-Green-Refactor)

#### Database Architecture:
- **Schema-Based Isolation**: `billing` schema in shared `go-labs-dev` database
- **RBAC Security**: Separate migration and application users with least privilege
- **Test Data Isolation**: DELETE-based cleanup respecting foreign key constraints
- **Migration Management**: golang-migrate integration with version control

### 🛠️ Development Workflow Mastery

#### TDD Workflow Execution:
1. **SYNC**: git checkout main && git pull origin main
2. **EXPLORE**: Research Client entity and existing patterns
3. **PLAN**: Detailed implementation plan with test scenarios → User approval
4. **TEST-FIRST**: Write failing tests for all 3 CRUD operations
5. **IMPLEMENT-MINIMAL**: Write minimal code to pass tests
6. **REFACTOR**: Improve code quality while maintaining green tests
7. **COMMIT & CREATE PR**: Feature branch with comprehensive documentation
8. **CLAUDE GITHUB REVIEW LOOP**: 2-round iterative improvement process
9. **MERGE**: User-approved merge to main with feature branch cleanup

#### Git Workflow Excellence:
- **Feature Branch**: `feature/client-crud-operations` with descriptive naming
- **Comprehensive Commits**: Detailed commit messages with TDD documentation
- **Pull Request**: Complete PR description with implementation summary and test coverage
- **Claude GitHub Integration**: Automated review process with user approval gates

### Current Project Structure (After Reorganization)
```
go-labs/
├── .claude/                    # Workflow commands (root for discovery)
├── CLAUDE.md                   # This file (project memory)
├── README.md                   # Generic workflow documentation
├── platform-docs/              # All platform documentation
│   ├── ARCHITECTURE.md        # Complete system architecture
│   ├── README.md              # Go-labs project overview
│   └── learning-notes/        # Learning and architecture notes
│       ├── ARCHITECTURE.md    # Microservices guide
│       ├── REPOSITORY_ORGANIZATION.md
│       └── ddd-layers-explained.md
├── services/                   # All backend services
│   ├── billing-api/           # Billing microservice with CLAUDE.md
│   ├── catalog-api/           # Catalog microservice (planned)
│   └── go-common/             # Shared Go libraries
├── frontend/                   # Frontend applications (future)
└── infrastructure/             # Infrastructure as code
```

## Next Steps Identified

### Immediate (Next Session)
1. **List Clients with Pagination (UC-B-005)** - Final CRUD operation with pagination support
2. **Invoice Domain Implementation** - Next major domain with complex business rules
3. **Advanced Error Handling** - Consistent error responses across all endpoints

### Short Term
1. **API Documentation** - OpenAPI/Swagger integration for REST endpoints
2. **Performance Optimization** - Caching, query optimization, connection pooling
3. **Authentication/Authorization** - JWT-based security implementation

### Long Term  
1. **Event-Driven Architecture** - Domain events for cross-service communication
2. **Catalog Service Implementation** - Second microservice with MongoDB
3. **Monitoring & Observability** - Metrics, logging, and health check implementations

## Development Patterns Established

### Code Organization Excellence
- **Domain Isolation**: Complete separation of business logic from infrastructure
- **Dependency Injection**: Clean, testable component composition
- **External Test Data**: JSON files with runtime.Caller() for reliable path resolution
- **Business Rules**: Enforced through domain model validation and state management

### Testing Patterns Mastery
- **Test Data Loading**: Reliable path resolution for external JSON fixtures
- **Type Isolation**: Avoid circular imports through proper test package organization
- **Edge Case Coverage**: Comprehensive validation scenarios for all business rules
- **Business Logic Testing**: State transitions, validation rules, error conditions

### Git Workflow Excellence
- **Feature Branches**: Clean separation of work with descriptive naming
- **Protected Main**: Pull request workflow ensuring code quality
- **Descriptive Commits**: Clear history with Claude Code attribution
- **Comprehensive Documentation**: Complete tracking of decisions and progress

## Key Learning Outcomes (Go for .NET Developer)

### Go-Specific Concepts Mastered
- **testdata/ Directories**: Go convention for external test data (excluded from builds)
- **Package Organization**: Clean domain separation without circular dependencies
- **GORM Integration**: Advanced database ORM patterns in Go ecosystem
- **Dependency Injection**: Function-based DI pattern for component composition
- **Error Handling**: Structured error types with proper wrapping and unwrapping
- **UUID Handling**: google/uuid library for robust identifier management
- **Interface Design**: Repository pattern with clean abstraction boundaries

### DDD Implementation Excellence in Go
- **Rich Domain Models**: Entities with encapsulated business logic
- **Value Objects**: Type-safe primitives with validation (Email, Phone)
- **Repository Pattern**: Interface-based data access with storage abstraction
- **Domain Errors**: Structured error handling with user-friendly messages
- **Business Rules**: Domain-driven validation and constraint enforcement
- **Clean Architecture**: Proper dependency flow and layer separation

## Collaborative AI Development Integration

### Claude GitHub Review Integration
**Automated Code Reviews**: Claude provides iterative code improvements directly on GitHub pull requests

**Review Process Excellence**:
```bash
# After PR creation, automatic review cycle:
1. Claude GitHub reviews → Provides improvement suggestions
2. Claude Code presents options → User decides which to apply
3. Apply approved improvements → Push changes
4. Claude GitHub reviews again → Continue until satisfied OR user stops
5. User approval required → Never auto-merge without permission
```

**Quality Benefits Achieved**:
- **Iterative Quality Improvement**: Code progressively improved through multiple review cycles
- **Go Best Practices**: Tailored advice for Go-specific patterns and idioms
- **Architecture Compliance**: Ensures adherence to Clean Architecture and DDD principles
- **User Control**: Maintains full user control over quality vs. speed tradeoffs

### Available Commands for Collaborative Development
- `@claude review` - General code review on GitHub PRs
- `@claude test` - Review test coverage and quality
- `@claude security` - Security-focused review
- `@claude performance` - Performance optimization suggestions
- `/analyze-pr-feedback` - Claude Code command to process GitHub review feedback

## Project-Specific Workflow Configuration

### .claude/ Directory Structure
```
.claude/
├── commands/                    # Project-specific Claude Code commands
│   ├── analyze-pr-feedback.md # Process GitHub review feedback
│   ├── commit-and-create-pr.md # Git workflow automation
│   ├── explore-feature.md      # Research phase implementation
│   ├── implement-minimal.md    # Minimal implementation guide
│   ├── plan-feature.md         # Planning phase implementation
│   ├── requirements-spec.md    # Requirements specification
│   ├── scope-check.md          # Overengineering validation
│   ├── sync-with-main.md       # Branch synchronization
│   └── test-first.md           # TDD test-first implementation
├── templates/                   # Project-specific templates
├── settings.local.json         # Claude Code permissions and settings
├── COMPLETE_WORKFLOW_GUIDE.md  # Comprehensive workflow documentation
├── README-TDD-WORKFLOW.md      # TDD workflow implementation guide
└── WORKFLOW_EXECUTION_GUIDE.md # Execution-focused workflow guide
```

**Important**: This `.claude/` directory contains **go-labs project-specific** implementations of the generic TDD workflow methodology. The reusable workflow definition is available at: https://github.com/Gaetan-Jaminon/Claude-Workflow-TDD

### How to Use Generic Workflow with Other Projects
1. Clone the generic workflow repository: https://github.com/Gaetan-Jaminon/Claude-Workflow-TDD
2. Copy the `.claude/` directory template to your project
3. Customize commands and settings for your specific tech stack
4. Update CLAUDE.md with your project-specific context and rules

## Current State Summary

### ✅ Production-Ready Achievements
- **Complete Client CRUD**: All 4 use cases implemented with comprehensive testing
- **TDD Mastery**: Strict Red-Green-Refactor cycles documented and enforced
- **Claude GitHub Integration**: Proven 2-round review process with user approval gates
- **Business Stakeholder Reports**: Non-technical test coverage documentation
- **Infrastructure as Code**: Database provisioning with environment separation
- **Clean Architecture**: Proper layer separation and dependency management
- **Repository Pattern**: Complete abstraction with multiple storage implementations

### 🎯 Current Focus
- **Advanced Domain Features**: Invoice management with complex business rules
- **Cross-Service Communication**: Event-driven architecture patterns
- **Performance & Scalability**: Optimization and monitoring integration

### 📊 Metrics & Quality Indicators
- **Test Coverage**: 95%+ for all new code with comprehensive business scenarios  
- **Code Quality**: Claude GitHub approved with iterative improvements applied
- **Architecture Compliance**: Clean Architecture and DDD principles enforced
- **Documentation**: Complete stakeholder and technical documentation maintained
- **Development Velocity**: Proven TDD workflow with collaborative AI review integration

---

*Last Updated: August 4, 2025*  
*Session: Complete Client CRUD Operations + Claude GitHub Review Integration + Project Memory Restoration*  
*Status: All 4 Client Use Cases Complete - Ready for Invoice Domain Implementation*
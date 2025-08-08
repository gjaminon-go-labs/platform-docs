# Go-Labs - Domain-Driven Design Learning Project

**Learning Go as a .NET developer through practical Domain-Driven Design (DDD) implementation**

---

## Project Overview

**Goal**: Master Go programming language through hands-on experience building a real-world microservices platform with Clean Architecture and Domain-Driven Design principles.

**Architecture**: Clean Architecture with DDD, dependency injection, comprehensive testing strategy, and collaborative AI-driven development workflow.

**Current Status**: Complete Client CRUD operations with full TDD implementation, Claude GitHub review integration, and business test coverage reporting.

---

## Project Structure

```
go-labs/
├── billing-api/                 # Billing microservice (Go + PostgreSQL)
├── catalog-api/                # Catalog microservice (Go + MongoDB - planned)
├── go-common/                  # Shared libraries and contracts
├── infrastructure/             # Database provisioning and DevOps
└── learning_notes/            # Architecture decisions and learning documentation
```

---

## Microservices Architecture

### ✅ Billing Service (Complete)
- **Technology**: Go + PostgreSQL + Clean Architecture + DDD
- **Features**: Complete Client CRUD operations with comprehensive test coverage
- **Status**: Production-ready with full TDD implementation

### 🚧 Catalog Service (Planned)
- **Technology**: Go + MongoDB + Event Sourcing
- **Features**: Product management with inventory tracking
- **Status**: Architecture designed, implementation pending

### 📚 Shared Libraries (go-common)
- **Cross-cutting concerns**: Logging, metrics, error handling
- **Domain events**: Inter-service communication contracts
- **Testing utilities**: Shared test helpers and fixtures

---

## Technical Achievements

### ✅ Clean Architecture Implementation
- **Domain Layer**: Rich entities with business logic and value objects
- **Application Layer**: Use cases and application services
- **Infrastructure Layer**: Database repositories and external integrations
- **API Layer**: RESTful HTTP handlers with proper DTOs

### ✅ Test-Driven Development (TDD)
- **Unit Tests**: Fast, isolated testing with in-memory storage
- **Integration Tests**: Full PostgreSQL testing with automatic cleanup
- **Business Coverage Reports**: Non-technical stakeholder documentation
- **95%+ Test Coverage**: Comprehensive validation of business logic

### ✅ Claude GitHub Review Integration
- **Collaborative AI Review**: Iterative code improvement cycles
- **Quality Assurance**: Multi-round review process with user approval gates
- **Best Practices**: Go-specific improvements and architecture compliance

### ✅ Infrastructure as Code
- **Database Provisioning**: Template-based PostgreSQL setup
- **Environment Separation**: Dev, test, and production configurations
- **RBAC Security**: Service-specific users with least-privilege access

---

## Development Workflow

This project follows a strict **Test-Driven Development (TDD) workflow** with collaborative AI review integration. See `CLAUDE.md` for complete workflow documentation.

### Quick Commands
```bash
# Setup development environment
cd infrastructure && ./scripts/provision-database.sh dev

# Run all tests
cd billing-api && make test-all

# Start development server
cd billing-api && make run-dev

# Generate business coverage report
cd billing-api && make test-integration-report
```

---

## Learning Outcomes (Go for .NET Developer)

### Go-Specific Concepts Mastered
- **Package Organization**: Clean domain separation without circular dependencies
- **Interface-Based Design**: Dependency injection and repository pattern
- **Error Handling**: Structured error types with proper wrapping
- **Testing Patterns**: Table-driven tests and testify assertions
- **GORM Integration**: Database ORM patterns in Go ecosystem

### Domain-Driven Design in Go
- **Rich Domain Models**: Business logic encapsulated in entities
- **Value Objects**: Type-safe primitives with validation
- **Repository Pattern**: Interface-based data access abstraction
- **Domain Events**: Cross-boundary communication (planned)
- **Bounded Contexts**: Service isolation with schema-based separation

---

## Project Milestones

### ✅ Phase 1: Foundation (Complete)
- Clean Architecture setup with proper layer separation
- PostgreSQL integration with migration system
- Dependency injection container with lazy initialization
- Comprehensive testing strategy (unit + integration)

### ✅ Phase 2: Core Domain (Complete)
- Client entity with email/phone value objects
- Complete CRUD operations following TDD methodology
- Repository pattern with storage abstraction
- RESTful API with proper error handling

### ✅ Phase 3: Quality & Collaboration (Complete)
- Claude GitHub review integration workflow
- Business test coverage reporting for stakeholders
- Infrastructure as code with database provisioning
- Standalone TDD workflow repository for reusability

### 🚧 Phase 4: Advanced Features (Planned)
- Invoice domain with complex business rules
- Authentication and authorization (JWT-based)
- Event-driven architecture for service communication
- Performance optimization and monitoring

---

## Architecture Decisions

### Database Strategy
- **Shared Database**: `go-labs-dev` and `go-labs-tst` with schema-based service isolation
- **Service Boundaries**: Each service owns its schema (`billing`, `catalog`)
- **RBAC Security**: Separate migration and application users per service
- **Test Isolation**: DELETE-based cleanup for integration tests

### Testing Philosophy
- **Fast Feedback Loop**: Unit tests with in-memory storage (< 1 second)
- **Real Behavior Validation**: Integration tests with PostgreSQL
- **Business Documentation**: Test scenarios readable by non-technical stakeholders
- **Automatic Cleanup**: Fresh database state for every test run

### Development Process
- **TDD Enforcement**: No production code without failing tests first
- **Collaborative Review**: Claude GitHub integration with iterative improvements
- **Quality Gates**: User approval required at all critical decision points
- **Git Workflow**: Feature branches with comprehensive PR documentation

---

## Getting Started

### Prerequisites
- Go 1.21+
- PostgreSQL 16+
- Make (for build automation)
- GitHub CLI (for PR management)

### Setup
```bash
# Clone repository
git clone <repository-url>
cd go-labs

# Setup database infrastructure
cd infrastructure
./scripts/provision-database.sh dev

# Setup billing service
cd ../billing-api
go mod tidy
make test-all

# Start development server
make run-dev
```

### Development Workflow
1. Create feature branch: `git checkout -b feature/your-feature`
2. Follow TDD workflow: Red → Green → Refactor
3. Create PR and wait for Claude GitHub review
4. Apply approved improvements iteratively
5. Merge with user approval

---

## Documentation

- `CLAUDE.md` - Complete project memory and workflow documentation
- `billing-api/CLAUDE.md` - Service-specific context and patterns
- `docs/TEST_STRATEGY.md` - Comprehensive testing documentation
- `learning_notes/` - Architecture decisions and Go learning notes

---

## Contact & Collaboration

**Claude TDD Workflow**: Available at https://github.com/Gaetan-Jaminon/Claude-Workflow-TDD
**Claude GitHub Reviews**: Automated code review integration with iterative improvement cycles

---

*This project demonstrates production-ready Go development with Clean Architecture, Domain-Driven Design, and collaborative AI-driven development practices.*

**Current Focus**: Advanced domain features and cross-service communication patterns.
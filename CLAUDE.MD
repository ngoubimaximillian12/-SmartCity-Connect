# Claude AI Assistant Guide for SmartCity Connect

This document provides guidance for AI assistants (Claude, GPT-4, etc.) working on the SmartCity Connect project.

---

## Project Overview

**SmartCity Connect** is a next-generation intelligent city operating system integrating 68+ services across 20 categories, including:
- IoT, AI/ML, Quantum Computing
- Blockchain, Robotics, Autonomous Systems
- Extended Reality (XR), Brain-Computer Interfaces
- Environmental monitoring, Transportation, Healthcare, Governance, and more

**Scale**: 1.5M+ IoT events/sec, 150K+ concurrent users, 99.99% uptime target

---

## Quick Reference

### Key Documents
- `/overview` - Complete system specification (68 services, all features)
- `/docs/roadmap.md` - 14-phase implementation roadmap (41 months + ongoing)
- `/README.md` - Project documentation
- `/docs/branching.md` - Git workflow and branching strategy
- `/docs/architecture/` - System architecture diagrams
- `/docs/api/` - API specifications

### Project Structure
```
SmartCity Connect/
├── backend/
│   ├── api-gateway/          # API Gateway (Kong/Spring Cloud Gateway)
│   ├── microservices/         # 68+ microservice directories
│   │   ├── advanced-traffic-pattern-learning-service/
│   │   ├── citizen-services-portal/
│   │   └── ...
│   ├── shared/                # Shared libraries and utilities
│   └── pom.xml               # Maven parent POM (Java services)
├── frontend/
│   ├── web-portal/           # Citizen-facing PWA (React + Next.js)
│   ├── admin-dashboard/      # Admin panel (React)
│   ├── mobile-apps/          # React Native/Flutter apps
│   └── package.json
├── infrastructure/
│   ├── kubernetes/           # K8s manifests, Helm charts
│   ├── terraform/            # IaC for cloud resources
│   └── docker/               # Docker configurations
├── ml-models/                # AI/ML models and training pipelines
├── tests/                    # Integration and E2E tests
├── scripts/                  # Automation scripts
└── docs/                     # Documentation
```

---

## Current Status

**Phase 0**: ✅ COMPLETED (Repository scaffolded, Git initialized)

**Next Phase**: Phase 1 - Foundation Infrastructure (Months 1-3)
- Month 1: Infrastructure setup (K8s, databases, Kafka, monitoring)
- Month 2: Core services (API Gateway, User Service, IoT, Notifications)
- Month 3: Transportation foundation (Traffic, Parking, Transit)

---

## AI Assistant Guidelines

### 1. Understanding Context

When asked to implement a service or feature:

1. **Read the specification** from `/overview`:
   - Search for the Service ID (e.g., "TMS-001", "PMS-002")
   - Review all features, technologies, and API endpoints
   - Note privacy requirements and performance targets

2. **Check the roadmap** in `/docs/roadmap.md`:
   - Identify which phase the service belongs to
   - Review implementation tasks and dependencies
   - Check budget/team size constraints

3. **Review existing code**:
   - Check if microservice directory exists
   - Look for similar implemented services as templates
   - Ensure consistency with existing patterns

### 2. Implementation Approach

Follow this sequence when implementing a new service:

#### Step 1: Plan and Design
- **Architecture**: Identify databases, message queues, external APIs
- **Data Model**: Design schemas for PostgreSQL/MongoDB/Cassandra/etc.
- **API Contract**: Define RESTful endpoints, request/response formats
- **Dependencies**: List required infrastructure (Kafka topics, Redis keys)

#### Step 2: Backend Development (Java/Python/Go)
- **Service Structure**:
  ```
  microservices/service-name/
  ├── src/
  │   ├── main/
  │   │   ├── java/com/smartcity/service/
  │   │   │   ├── controller/      # REST controllers
  │   │   │   ├── service/         # Business logic
  │   │   │   ├── repository/      # Data access
  │   │   │   ├── model/           # Domain models
  │   │   │   ├── dto/             # Data transfer objects
  │   │   │   ├── config/          # Configuration
  │   │   │   └── Application.java
  │   │   └── resources/
  │   │       ├── application.yml  # Configuration
  │   │       └── schema.sql       # DB schema
  │   └── test/                    # Unit tests
  ├── Dockerfile
  ├── pom.xml (Java) / requirements.txt (Python)
  └── README.md
  ```

- **Best Practices**:
  - Use Spring Boot 3.2+ for Java services
  - Use FastAPI for Python services
  - Implement health check endpoints (`/actuator/health`, `/health`)
  - Add OpenTelemetry instrumentation for tracing
  - Use environment variables for configuration
  - Implement circuit breakers for external calls
  - Add input validation and error handling
  - Use DTOs to separate API contracts from domain models

#### Step 3: Database Integration
- **PostgreSQL**: User data, transactions, relational data
  - Use connection pooling (HikariCP, PgBouncer)
  - Implement database migrations (Flyway, Liquibase)
  - Add indexes for query performance

- **MongoDB**: Documents, logs, flexible schemas
  - Design collections with denormalization where appropriate
  - Add indexes on frequently queried fields

- **Redis**: Caching, session management, real-time data
  - Set appropriate TTLs for cached data
  - Use Redis Streams for event sourcing

- **Cassandra**: Time-series IoT data, high-write throughput
  - Design partition keys carefully to avoid hotspots
  - Use time-based bucketing for time-series data

- **Kafka**: Event streaming, pub/sub messaging
  - Define topics with proper partitioning strategy
  - Use Schema Registry for message schemas
  - Implement exactly-once semantics where needed

#### Step 4: API Development
- **RESTful Design**:
  - Use proper HTTP methods (GET, POST, PUT, DELETE, PATCH)
  - Use HTTP status codes correctly (200, 201, 400, 404, 500, etc.)
  - Version APIs (`/api/v1/resource`)
  - Implement pagination for list endpoints
  - Add filtering and sorting query parameters
  - Use HATEOAS for discoverability (optional)

- **Authentication & Authorization**:
  - JWT tokens from API Gateway
  - Role-based access control (RBAC)
  - Validate permissions in each service

- **Documentation**:
  - Use OpenAPI/Swagger annotations
  - Generate interactive API docs
  - Provide example requests/responses

#### Step 5: Frontend Integration (React/Next.js)
- **Component Structure**:
  ```
  src/
  ├── app/                     # Next.js app directory
  │   ├── (dashboard)/        # Dashboard layout group
  │   ├── traffic/            # Traffic pages
  │   ├── parking/            # Parking pages
  │   └── layout.tsx          # Root layout
  ├── components/
  │   ├── ui/                 # Reusable UI components (Tailwind)
  │   ├── features/           # Feature-specific components
  │   └── layout/             # Layout components
  ├── lib/
  │   ├── api/                # API client functions
  │   ├── hooks/              # Custom React hooks
  │   └── utils/              # Utility functions
  ├── styles/
  └── types/                  # TypeScript type definitions
  ```

- **Best Practices**:
  - Use TypeScript for type safety
  - Use Tailwind CSS for styling
  - Implement responsive design (mobile-first)
  - Use React Query/SWR for data fetching
  - Implement error boundaries
  - Add loading states and skeletons
  - Use Web Vitals for performance monitoring
  - Implement Progressive Web App (PWA) features

#### Step 6: Testing
- **Unit Tests**:
  - Test business logic in isolation
  - Mock external dependencies
  - Aim for >80% code coverage

- **Integration Tests**:
  - Test API endpoints end-to-end
  - Use test containers for databases
  - Test Kafka producers/consumers

- **E2E Tests**:
  - Use Cypress/Playwright for frontend
  - Test critical user journeys
  - Run against staging environment

#### Step 7: Deployment
- **Containerization**:
  - Write optimized Dockerfile (multi-stage builds)
  - Minimize image size
  - Use non-root users
  - Scan for vulnerabilities (Trivy, Snyk)

- **Kubernetes**:
  - Create Deployment manifest
  - Define Service (ClusterIP, LoadBalancer)
  - Add ConfigMap and Secret
  - Configure resource limits (CPU, memory)
  - Implement liveness/readiness probes
  - Add HorizontalPodAutoscaler (HPA)

- **Helm Chart**:
  - Package service as Helm chart
  - Parameterize environment-specific values
  - Add dependencies (databases, queues)

### 3. Technology Stack Reference

#### Backend Languages
- **Java 17+**: Primary backend language (Spring Boot 3.2+)
- **Python 3.11+**: ML/AI services, data processing (FastAPI)
- **Go**: High-performance services, edge computing
- **Rust**: Security-critical components, low-level systems

#### Frontend Technologies
- **React 18+**: UI library
- **Next.js 14**: React framework (SSR, SSG, ISR)
- **TypeScript**: Type safety
- **Tailwind CSS**: Utility-first CSS
- **React Query/SWR**: Data fetching
- **Zustand/Redux**: State management
- **D3.js**: Data visualization
- **Mapbox GL/Leaflet**: Maps
- **Three.js**: 3D graphics

#### Databases
- **PostgreSQL 15+**: Primary relational database
- **MongoDB 7+**: Document store
- **Redis 7+**: Cache and real-time data
- **Cassandra 4+**: Time-series data
- **InfluxDB 2+**: Metrics and sensor data
- **Elasticsearch 8+**: Search and logs
- **Neo4j 5+**: Graph database

#### Messaging & Streaming
- **Apache Kafka**: Event streaming (1.5M+ events/sec target)
- **RabbitMQ**: Task queues
- **MQTT**: IoT device communication
- **Apache Flink**: Stream processing
- **Apache Spark**: Batch processing

#### AI/ML
- **TensorFlow 2.14+**: Deep learning
- **PyTorch 2.1+**: Deep learning
- **Scikit-learn**: Traditional ML
- **XGBoost/LightGBM**: Gradient boosting
- **Hugging Face**: NLP models
- **YOLO v8**: Computer vision
- **MLflow**: ML experiment tracking
- **Kubeflow**: ML pipeline orchestration

#### Cloud & Infrastructure
- **Kubernetes 1.28+**: Container orchestration
- **Istio**: Service mesh
- **ArgoCD**: GitOps deployment
- **Terraform**: Infrastructure as Code
- **AWS/Azure/GCP**: Multi-cloud
- **Prometheus + Grafana**: Monitoring
- **Jaeger**: Distributed tracing
- **ELK Stack**: Logging

#### Security
- **Keycloak**: Identity and access management
- **OAuth2/OIDC**: Authentication
- **JWT**: Tokens
- **HashiCorp Vault**: Secrets management
- **TLS 1.3**: Encryption in transit
- **AES-256**: Encryption at rest

### 4. Code Quality Standards

#### Code Style
- **Java**: Follow Google Java Style Guide
- **Python**: Follow PEP 8
- **TypeScript/JavaScript**: Use ESLint + Prettier
- **Go**: Use gofmt and golint

#### Naming Conventions
- **Classes**: PascalCase (`UserService`, `TrafficController`)
- **Methods/Functions**: camelCase (`getUserProfile`, `calculateRoute`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `API_VERSION`)
- **Database Tables**: snake_case (`user_profiles`, `traffic_events`)
- **REST Endpoints**: kebab-case (`/api/parking-zones`, `/api/traffic-incidents`)

#### Security Best Practices
- **Input Validation**: Validate all user inputs
- **SQL Injection**: Use parameterized queries (never string concatenation)
- **XSS Prevention**: Escape output, use Content Security Policy
- **CSRF Protection**: Use CSRF tokens
- **Authentication**: Always validate JWT tokens
- **Authorization**: Check permissions on every request
- **Secrets**: Never hardcode secrets (use environment variables/Vault)
- **Dependencies**: Regularly update and scan for vulnerabilities
- **Rate Limiting**: Implement rate limiting on all public APIs
- **Logging**: Never log sensitive data (passwords, tokens, PII)

#### Performance Best Practices
- **Database Queries**: Use indexes, avoid N+1 queries, use pagination
- **Caching**: Cache frequently accessed data (Redis)
- **Async Processing**: Use message queues for long-running tasks
- **Connection Pooling**: Reuse database connections
- **Compression**: Use gzip/Brotli for API responses
- **CDN**: Serve static assets from CDN
- **Lazy Loading**: Load data on-demand
- **Code Splitting**: Split frontend bundles

### 5. Common Patterns

#### Microservice Communication
```java
// Synchronous (REST) - for immediate responses
@FeignClient(name = "user-service")
public interface UserServiceClient {
    @GetMapping("/api/users/{userId}")
    UserDTO getUser(@PathVariable String userId);
}

// Asynchronous (Kafka) - for events
@Service
public class TrafficEventProducer {
    @Autowired
    private KafkaTemplate<String, TrafficEvent> kafkaTemplate;

    public void publishIncident(TrafficEvent event) {
        kafkaTemplate.send("traffic-incidents", event);
    }
}
```

#### Error Handling
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(new ErrorResponse("RESOURCE_NOT_FOUND", ex.getMessage()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex) {
        log.error("Unexpected error", ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(new ErrorResponse("INTERNAL_ERROR", "An unexpected error occurred"));
    }
}
```

#### Circuit Breaker
```java
@Service
public class ExternalApiService {
    @CircuitBreaker(name = "externalApi", fallbackMethod = "fallbackMethod")
    @Retry(name = "externalApi")
    public ResponseDTO callExternalApi() {
        // Call external service
    }

    public ResponseDTO fallbackMethod(Exception ex) {
        // Return cached data or default response
    }
}
```

#### Caching
```java
@Service
public class ParkingService {
    @Cacheable(value = "parking-availability", key = "#zoneId")
    public ParkingAvailability getAvailability(String zoneId) {
        // Fetch from database (cached for performance)
    }

    @CacheEvict(value = "parking-availability", key = "#zoneId")
    public void updateAvailability(String zoneId, ParkingAvailability availability) {
        // Update database (invalidate cache)
    }
}
```

#### Database Migration (Flyway)
```sql
-- V1__create_users_table.sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
```

### 6. Service-Specific Guidance

#### Traffic Management Service (TMS-001)
- **ML Model**: LSTM for traffic prediction (TensorFlow/PyTorch)
- **Computer Vision**: YOLO v8 for vehicle detection and classification
- **Data Storage**: Cassandra for time-series traffic data, Neo4j for road network graph
- **Real-time Processing**: Kafka Streams for event processing (1M+ data points/sec)
- **API**: REST endpoints + WebSocket for live updates
- **Privacy**: Anonymize vehicle trajectories (k-anonymity, differential privacy)

#### Parking System (PMS-002)
- **ML Model**: XGBoost for parking availability prediction (15-60 min ahead)
- **Data Storage**: MongoDB for zones/spots, Redis for real-time availability
- **Payment**: Integrate Stripe/PayPal for reservations and payments
- **API**: REST endpoints for availability, reservations, payments
- **EV Charging**: Track charging station availability and manage reservations

#### Public Transit (PTI-003)
- **GPS Tracking**: Real-time vehicle positions via MQTT/HTTP
- **ML Model**: Gradient boosting for arrival predictions (±1 min accuracy)
- **Route Planning**: A*/Dijkstra algorithm for multi-modal trip planning
- **Ticketing**: QR code generation, digital wallet integration
- **WebSocket**: Live updates for vehicle positions and arrivals
- **Data Storage**: PostgreSQL for routes/schedules, Redis for real-time tracking, InfluxDB for historical data

#### IoT Data Ingestion (IOT-001)
- **Protocols**: MQTT (primary), CoAP, HTTP, LoRaWAN
- **Device Authentication**: X.509 certificates, API keys
- **Data Validation**: Schema validation, range checks, anomaly detection
- **Event Routing**: Route to Kafka topics based on device type/data type
- **Scalability**: Target 1.5M+ events/sec (horizontal scaling with Kafka)
- **Security**: TLS/SSL encryption, rate limiting per device

#### Emergency Response (ERDS-016)
- **911 Integration**: Integrate with existing emergency systems (APIs/webhooks)
- **Incident Detection**: AI-powered (computer vision, acoustic sensors, citizen reports)
- **Dispatch Optimization**: Route optimization for ambulances/fire trucks/police
- **Alert System**: Mass notifications (push, SMS, email, sirens)
- **Live Tracking**: Real-time incident and responder tracking (WebSocket)
- **Data Storage**: PostgreSQL for incidents, Redis for live tracking, MongoDB for logs

### 7. Testing Guidelines

#### Unit Test Example (Java/JUnit 5)
```java
@SpringBootTest
class UserServiceTest {
    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @Test
    void testGetUser_Success() {
        // Given
        UUID userId = UUID.randomUUID();
        User user = new User(userId, "test@example.com", "John Doe");
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));

        // When
        UserDTO result = userService.getUser(userId);

        // Then
        assertNotNull(result);
        assertEquals("John Doe", result.getFullName());
        verify(userRepository).findById(userId);
    }

    @Test
    void testGetUser_NotFound() {
        // Given
        UUID userId = UUID.randomUUID();
        when(userRepository.findById(userId)).thenReturn(Optional.empty());

        // When/Then
        assertThrows(ResourceNotFoundException.class, () -> userService.getUser(userId));
    }
}
```

#### Integration Test Example (REST Assured)
```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
class TrafficControllerIntegrationTest {
    @LocalServerPort
    private int port;

    @Test
    void testGetTrafficStatus_Success() {
        given()
            .port(port)
            .auth().oauth2(getTestToken())
        .when()
            .get("/api/traffic/current/{roadId}", "road-123")
        .then()
            .statusCode(200)
            .body("roadId", equalTo("road-123"))
            .body("congestionLevel", notNullValue());
    }
}
```

#### E2E Test Example (Cypress)
```javascript
describe('Parking Reservation Flow', () => {
  it('should allow user to reserve a parking spot', () => {
    cy.login('testuser@example.com', 'password123');
    cy.visit('/parking');

    // Select zone
    cy.get('[data-testid="zone-downtown"]').click();

    // View available spots
    cy.get('[data-testid="available-spots"]').should('be.visible');
    cy.get('[data-testid="spot-card"]').first().click();

    // Make reservation
    cy.get('[data-testid="reserve-button"]').click();
    cy.get('[data-testid="duration-select"]').select('2 hours');
    cy.get('[data-testid="confirm-button"]').click();

    // Verify success
    cy.get('[data-testid="success-message"]').should('contain', 'Reservation confirmed');
    cy.url().should('include', '/reservations');
  });
});
```

### 8. Deployment Checklist

Before deploying a new service to production:

- [ ] **Code Quality**
  - [ ] Code reviewed and approved
  - [ ] No critical SonarQube issues
  - [ ] All tests passing (unit, integration, E2E)
  - [ ] Code coverage >80%

- [ ] **Security**
  - [ ] Security scan passed (Snyk, Trivy)
  - [ ] No hardcoded secrets
  - [ ] Input validation implemented
  - [ ] Authentication/authorization configured
  - [ ] Rate limiting enabled

- [ ] **Performance**
  - [ ] Load testing completed
  - [ ] Database queries optimized (indexes, explain plans)
  - [ ] Caching implemented where appropriate
  - [ ] Resource limits configured (CPU, memory)

- [ ] **Monitoring**
  - [ ] Prometheus metrics exposed
  - [ ] Grafana dashboard created
  - [ ] Logs structured and centralized (ELK)
  - [ ] Distributed tracing enabled (Jaeger)
  - [ ] Alerts configured (critical, high, medium priority)

- [ ] **Documentation**
  - [ ] API documentation (OpenAPI/Swagger)
  - [ ] README updated
  - [ ] Architecture diagram created
  - [ ] Runbook for operations

- [ ] **Infrastructure**
  - [ ] Kubernetes manifests tested in staging
  - [ ] Helm chart values reviewed
  - [ ] Database migrations tested
  - [ ] Secrets configured in Vault
  - [ ] Health check endpoints working
  - [ ] HPA configured for auto-scaling

- [ ] **Rollback Plan**
  - [ ] Previous version tagged in Git
  - [ ] Database migration rollback script ready
  - [ ] Rollback procedure documented

### 9. Common Pitfalls to Avoid

1. **Database Issues**
   - Missing indexes on frequently queried columns
   - N+1 query problems (use eager loading or batch queries)
   - Not using connection pooling
   - Hardcoding database credentials

2. **API Design**
   - Inconsistent naming conventions
   - Missing error handling
   - Not versioning APIs
   - Returning sensitive data (passwords, tokens)
   - Not implementing pagination for large datasets

3. **Security**
   - Not validating JWT tokens on every request
   - Logging sensitive information (passwords, tokens, PII)
   - Using weak encryption algorithms
   - Not implementing rate limiting
   - Trusting user input without validation

4. **Performance**
   - Synchronous calls to external services (use async/circuit breakers)
   - Not caching frequently accessed data
   - Fetching more data than needed
   - Not using CDN for static assets

5. **Kubernetes**
   - Not setting resource limits (can starve other pods)
   - Missing liveness/readiness probes
   - Not using ConfigMaps/Secrets (hardcoding config)
   - Single replica (no high availability)

6. **Monitoring**
   - Not exposing metrics (can't diagnose issues)
   - Missing critical alerts
   - Not implementing distributed tracing (can't debug microservices)
   - Alert fatigue (too many low-priority alerts)

### 10. Getting Help

When you need more information:

1. **Architecture Questions**: Check `/docs/architecture/` and `/overview`
2. **API Specifications**: Check `/docs/api/` and service README files
3. **Implementation Details**: Read the roadmap for the specific phase
4. **Service Dependencies**: Review `docker-compose.yml` and Kubernetes manifests
5. **Code Examples**: Look at similar implemented services in `/backend/microservices/`

### 11. Development Workflow

#### Starting a New Feature
1. **Create Feature Branch**:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/service-name-implementation
   ```

2. **Implement Service**:
   - Follow implementation steps (1-7) above
   - Commit frequently with descriptive messages
   - Run tests locally

3. **Create Pull Request**:
   - Push branch to GitHub
   - Create PR with description of changes
   - Link to relevant issues/tickets
   - Request code review
   - Ensure CI/CD checks pass

4. **Deploy to Staging**:
   - Merge to `develop` branch
   - ArgoCD auto-deploys to staging
   - Run smoke tests
   - Monitor for errors

5. **Deploy to Production**:
   - Create release PR from `develop` to `main`
   - Tag release (e.g., `v1.2.0`)
   - ArgoCD deploys to production
   - Monitor metrics and alerts

#### Hotfix Workflow
1. **Create Hotfix Branch** from `main`:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b hotfix/critical-bug-fix
   ```

2. **Fix and Test**:
   - Make minimal changes
   - Test thoroughly
   - Update version number

3. **Deploy**:
   - Create PR to `main`
   - Fast-track review
   - Deploy immediately
   - Backport to `develop`

---

## Performance Targets

### API Performance
- **p95 latency**: < 200ms
- **p99 latency**: < 500ms
- **Availability**: 99.99% (52 minutes downtime/year)

### Data Processing
- **IoT events**: 1.5M+ events/sec
- **Kafka throughput**: 2.5M+ messages/sec
- **Database TPS**: 15K+ transactions/sec

### Scalability
- **Concurrent users**: 150K+
- **API requests**: 250K+ req/sec

### ML Performance
- **Inference latency**: < 100ms
- **Prediction accuracy**: > 90% (traffic/parking)

---

## Support and Escalation

### Issue Severity Levels

1. **Critical (P0)**: System down, data loss, security breach
   - Response time: Immediate
   - Resolution time: < 1 hour
   - Escalate to: Engineering leadership

2. **High (P1)**: Major feature broken, significant performance degradation
   - Response time: < 15 minutes
   - Resolution time: < 4 hours
   - Escalate to: Team lead

3. **Medium (P2)**: Minor feature broken, non-critical bug
   - Response time: < 1 hour
   - Resolution time: < 24 hours
   - Escalate to: Assigned developer

4. **Low (P3)**: Enhancement, nice-to-have, documentation
   - Response time: < 4 hours
   - Resolution time: Next sprint
   - Escalate to: Product manager

---

## Conclusion

This guide should help you (AI assistant) understand the SmartCity Connect project structure, coding standards, and implementation approaches. Always prioritize:

1. **Security**: Never compromise on security
2. **Performance**: Design for scale from day one
3. **Reliability**: Build resilient systems with proper error handling
4. **Maintainability**: Write clean, documented, testable code
5. **User Experience**: Focus on citizen needs and accessibility

When in doubt, ask for clarification and review the detailed specifications in `/overview` and `/docs/roadmap.md`.

**Happy coding!**

---

**Last Updated**: January 2026
**Document Owner**: Engineering Team
**Version**: 1.0

# CI/CD Pipeline Documentation

Complete guide to SmartCity Connect's continuous integration and deployment pipelines.

---

## Overview

SmartCity Connect uses GitHub Actions for comprehensive CI/CD automation, including:

- ✅ **Continuous Integration**: Build, test, and quality checks
- 🔒 **Security Scanning**: Vulnerability detection and compliance
- 📦 **Docker Build**: Multi-arch container image builds
- 🚀 **Automated Deployment**: Deploy to dev, staging, and production
- ✅ **PR Validation**: Automated pull request checks

---

## Workflows

### 1. Continuous Integration (`ci.yml`)

**Trigger**: Push to main/develop/feature branches, Pull Requests

**Purpose**: Validates repository structure and orchestrates other workflows

**Jobs**:
- Repository structure validation
- CI status reporting

**When it runs**:
```yaml
on:
  push:
    branches: [main, develop, 'feature/**', 'bugfix/**']
  pull_request:
    branches: [main, develop]
```

---

### 2. Build and Test (`build-test.yml`)

**Trigger**: Push to main/develop/release branches, Pull Requests

**Purpose**: Comprehensive build and test suite

**Jobs**:
1. **Backend Java**
   - Maven build and compile
   - Unit tests (JUnit 5)
   - Integration tests (Spring Boot Test)
   - Code coverage (JaCoCo, target: 80%)
   - Artifacts: Test reports, coverage data

2. **Frontend** (Web Portal, Admin Dashboard)
   - npm install and build (Next.js)
   - ESLint and TypeScript checks
   - Unit tests (Jest, React Testing Library)
   - Build artifacts

3. **Mobile Apps** (Android, iOS)
   - React Native/Flutter build
   - Platform-specific tests
   - Build artifacts

4. **ML Models**
   - Python dependency installation
   - flake8 linting
   - mypy type checking
   - pytest unit tests
   - Code coverage

5. **Infrastructure**
   - Kubernetes manifest validation (kubeval)
   - Terraform format check and validate
   - Docker Compose validation

6. **E2E Tests**
   - Cypress end-to-end tests (on PR only)
   - Video artifacts on failure

**Environment Variables**:
- `JAVA_VERSION`: 17
- `NODE_VERSION`: 20
- `PYTHON_VERSION`: 3.11

**Secrets Required**: None (uses default GITHUB_TOKEN)

**Success Criteria**:
- All builds successful
- All tests passing
- Code coverage >= 80% (target)

---

### 3. Code Quality (`code-quality.yml`)

**Trigger**: Push to main/develop, Pull Requests

**Purpose**: Enforce code quality standards

**Jobs**:

1. **ESLint** (JavaScript/TypeScript)
   - Checks frontend code for errors
   - Generates annotations on PR

2. **Prettier** (JavaScript/TypeScript)
   - Checks code formatting
   - Fails if code not formatted

3. **Checkstyle** (Java)
   - Java code style validation
   - Google Java Style Guide compliance

4. **Black** (Python)
   - Python code formatting
   - PEP 8 compliance

5. **Flake8** (Python)
   - Python linting
   - Complexity analysis

6. **SonarQube Analysis**
   - Comprehensive code analysis
   - Technical debt tracking
   - Quality gate enforcement
   - Supports: Java, JavaScript, Python

7. **CodeQL Analysis**
   - GitHub security scanning
   - Vulnerability detection
   - Language-specific analysis

8. **Dependency Review**
   - Check for vulnerable dependencies (PR only)
   - License compliance check

9. **License Check**
   - Verify dependency licenses
   - Deny: GPL-2.0, GPL-3.0

**Secrets Required**:
- `SONAR_TOKEN`: SonarQube authentication token
- `SONAR_HOST_URL`: SonarQube server URL
- `SONAR_ORGANIZATION`: SonarQube organization

**Quality Gates**:
- No critical code smells
- Security vulnerabilities: 0
- Code coverage >= 80%
- Duplication < 3%

---

### 4. Security Scanning (`security.yml`)

**Trigger**: Push to main/develop, Pull Requests, Daily (2 AM UTC)

**Purpose**: Detect security vulnerabilities

**Jobs**:

1. **Secret Scanning**
   - **TruffleHog**: Detect hardcoded secrets
   - **Gitleaks**: Find API keys, passwords, tokens
   - Status: CRITICAL if secrets found

2. **Dependency Vulnerability Scanning**
   - **Snyk**: Scan all project dependencies
   - Scans: Java (Maven), JavaScript (npm), Python (pip)
   - Severity threshold: High
   - Continuous monitoring

3. **OWASP Dependency Check**
   - CVE vulnerability database
   - Fail on CVSS >= 7.0
   - Generate HTML report (30-day retention)

4. **Container Image Scanning**
   - **Trivy**: Scan Docker images
   - Severity: CRITICAL, HIGH
   - Scans: Base images, dependencies
   - SARIF reports to GitHub Security

5. **Infrastructure as Code Scanning**
   - **Trivy IaC**: Scan Terraform, Kubernetes, Dockerfiles
   - **Checkov**: Security best practices
   - Misconfigurations, insecure settings

6. **SAST (Static Application Security Testing)**
   - **Semgrep**: Pattern-based security analysis
   - Rulesets: OWASP Top 10, security-audit
   - Languages: Java, JavaScript, Python

7. **OpenSSF Scorecard**
   - Security best practices assessment
   - Open-source project health metrics

8. **ZAP Penetration Testing** (Scheduled only)
   - OWASP ZAP baseline scan
   - Runs daily against dev environment

**Secrets Required**:
- `SNYK_TOKEN`: Snyk API token (optional)
- `FOSSA_API_KEY`: License compliance (optional)

**Alert Levels**:
- 🔴 **CRITICAL**: Secrets detected → Build fails
- 🟠 **HIGH**: Critical vulnerabilities → Warning
- 🟡 **MEDIUM**: Medium vulnerabilities → Info

---

### 5. Docker Build and Push (`docker-build.yml`)

**Trigger**: Push to main/develop, Tags (v*.*.*), Pull Requests

**Purpose**: Build and publish Docker images

**Strategy**: Multi-arch builds (linux/amd64, linux/arm64)

**Services Built**:

**Backend**:
- api-gateway
- user-service
- iot-service
- notification-service
- traffic-management-service
- parking-service
- transit-service

**Frontend**:
- web-portal
- admin-dashboard

**ML Models**:
- ml-traffic-prediction
- ml-parking-prediction
- ml-transit-prediction

**Build Process**:
1. Extract metadata (version, tags)
2. Login to GitHub Container Registry (ghcr.io)
3. Build multi-arch images
4. Push to registry (on main/develop/tags only)
5. Scan images with Trivy
6. Upload security results

**Image Tagging**:
- `latest`: Latest main branch
- `develop`: Latest develop branch
- `v1.2.3`: Semantic version tags
- `main-abc1234`: Branch + commit SHA
- `pr-123`: Pull request number

**Registry**: GitHub Container Registry (ghcr.io)

**Image naming**: `ghcr.io/<owner>/smartcity/<service>:<tag>`

**Build Args**:
- `VERSION`: Version number
- `BUILD_DATE`: Commit timestamp
- `VCS_REF`: Git commit SHA

**Caching**: Layer caching enabled for faster builds

**Secrets Required**:
- `GITHUB_TOKEN`: Automatically provided

---

### 6. Pull Request Validation (`pr-validation.yml`)

**Trigger**: PR opened, synchronized, reopened, ready for review

**Purpose**: Comprehensive PR quality checks

**Jobs**:

1. **PR Metadata Check**
   - Title format: Conventional Commits (feat:, fix:, docs:, etc.)
   - Description length: >= 50 characters
   - Required sections: Description, Changes, Testing
   - Linked issues check

2. **Breaking Changes Detection**
   - Checks for "BREAKING CHANGE:" in PR body
   - Checks for "!:" in title
   - Auto-label: `breaking-change`

3. **Code Size Check**
   - Tracks additions/deletions
   - Auto-label by size:
     - `size/small`: < 200 lines
     - `size/medium`: 200-500 lines
     - `size/large`: 500-1000 lines
     - `size/xl`: > 1000 lines
   - Warns if PR is too large

4. **Merge Conflict Check**
   - Detects merge conflicts
   - Fails if conflicts exist

5. **TODO/FIXME Check**
   - Counts TODO comments
   - Warns if > 5 TODOs added
   - Warns for any FIXMEs

6. **Console Statement Check**
   - Detects `console.log`, `console.error`, etc.
   - Recommends using proper logging

7. **Dependency Changes Check**
   - Detects package.json, pom.xml, requirements.txt changes
   - Auto-label: `dependencies`
   - Comments with security reminders

8. **Auto-labeler**
   - Labels based on changed files
   - Uses `.github/labeler.yml` configuration

9. **Test Coverage Check**
   - Checks if source code changes have test coverage
   - Warns if tests not updated

10. **Performance Impact Check**
    - Detects database migrations
    - Detects performance-sensitive patterns

11. **PR Summary**
    - Posts validation summary comment
    - Updates on subsequent pushes

**Success Criteria**:
- Valid PR title format
- Description provided
- No merge conflicts
- No critical issues

---

### 7. Deployment (`deploy.yml`)

**Trigger**:
- Push to develop → Auto-deploy to development
- Push to staging → Auto-deploy to staging
- Push to main → Auto-deploy to production (with approval)
- Manual workflow dispatch

**Environments**:

#### Development
- **URL**: https://dev.smartcityconnect.com
- **Namespace**: `smartcity-dev`
- **Auto-deploy**: Yes
- **Approval**: None
- **Smoke tests**: Basic health check

#### Staging
- **URL**: https://staging.smartcityconnect.com
- **Namespace**: `smartcity-staging`
- **Auto-deploy**: Yes
- **Approval**: None
- **Tests**: Integration tests, performance baseline

#### Production
- **URL**: https://smartcityconnect.com
- **Namespace**: `smartcity-prod`
- **Auto-deploy**: Yes (from main branch)
- **Approval**: Required (GitHub Environment Protection)
- **Strategy**: Blue-Green deployment
- **Tests**: Smoke tests, monitoring
- **Rollback**: Automated on failure

**Deployment Process**:

1. **Prepare Deployment**
   - Determine environment and version
   - Set Kubernetes namespace and cluster

2. **Deploy**
   - Configure kubectl
   - Deploy with Helm
   - Run database migrations
   - Verify rollout status

3. **Production-Specific** (Blue-Green):
   - Deploy to "green" slot
   - Run smoke tests
   - Switch traffic to green
   - Monitor for 5 minutes
   - Remove old "blue" deployment

4. **Post-Deployment**
   - Send Datadog deployment event
   - Create New Relic deployment marker
   - Send Slack notification
   - Update GitHub deployment status

**Secrets Required**:
- `KUBE_CONFIG_DEV`: Kubernetes config (base64) for dev
- `KUBE_CONFIG_STAGING`: Kubernetes config for staging
- `KUBE_CONFIG_PROD`: Kubernetes config for production
- `SLACK_WEBHOOK`: Slack notification webhook (optional)
- `DATADOG_API_KEY`: Datadog API key (optional)
- `NEW_RELIC_API_KEY`: New Relic API key (optional)

**Rollback**:
- Automatic on deployment failure
- Manual: `helm rollback <release> <revision>`

---

## Secrets Configuration

### Required Secrets

Set these in GitHub repository settings → Secrets and variables → Actions:

1. **Kubernetes**
   ```bash
   KUBE_CONFIG_DEV       # base64-encoded kubeconfig for dev
   KUBE_CONFIG_STAGING   # base64-encoded kubeconfig for staging
   KUBE_CONFIG_PROD      # base64-encoded kubeconfig for production
   ```

   Generate:
   ```bash
   cat ~/.kube/config | base64 | pbcopy  # macOS
   cat ~/.kube/config | base64 -w 0      # Linux
   ```

2. **Code Quality** (Optional)
   ```bash
   SONAR_TOKEN           # SonarQube authentication token
   SONAR_HOST_URL        # SonarQube server URL
   SONAR_ORGANIZATION    # SonarQube organization
   ```

3. **Security** (Optional)
   ```bash
   SNYK_TOKEN            # Snyk API token
   FOSSA_API_KEY         # FOSSA license compliance
   ```

4. **Monitoring** (Optional)
   ```bash
   DATADOG_API_KEY       # Datadog deployment tracking
   NEW_RELIC_API_KEY     # New Relic deployment markers
   SLACK_WEBHOOK         # Slack notifications
   ```

### Environment Variables

Set these in GitHub repository settings → Secrets and variables → Actions → Variables:

```bash
API_URL               # API URL for frontend builds
```

---

## Branch Protection Rules

### Main Branch

- **Require pull request reviews**: 2 approvals
- **Require status checks**: All must pass
  - Build and Test
  - Code Quality
  - Security Scanning
  - PR Validation
- **Require branches to be up to date**: Yes
- **Require conversation resolution**: Yes
- **Require signed commits**: Yes (recommended)
- **Include administrators**: Yes
- **Allow force pushes**: No
- **Allow deletions**: No

### Develop Branch

- **Require pull request reviews**: 1 approval
- **Require status checks**: All must pass
  - Build and Test
  - Code Quality
  - Security Scanning
- **Allow force pushes**: No
- **Allow deletions**: No

### Feature/Bugfix Branches

- No protection rules
- Will be validated on PR to develop/main

---

## Workflow Triggers Matrix

| Workflow          | Push (main) | Push (develop) | Push (feature) | Pull Request | Schedule | Manual |
|-------------------|-------------|----------------|----------------|--------------|----------|--------|
| CI                | ✅          | ✅             | ✅             | ✅           | ❌       | ❌     |
| Build & Test      | ✅          | ✅             | ✅             | ✅           | ❌       | ❌     |
| Code Quality      | ✅          | ✅             | ❌             | ✅           | ❌       | ❌     |
| Security          | ✅          | ✅             | ❌             | ✅           | ✅ Daily | ❌     |
| Docker Build      | ✅          | ✅             | ❌             | ✅           | ❌       | ❌     |
| PR Validation     | ❌          | ❌             | ❌             | ✅           | ❌       | ❌     |
| Deploy            | ✅          | ✅             | ❌             | ❌           | ❌       | ✅     |

---

## Workflow Dependencies

```
┌─────────────────────┐
│   PR Created/Push   │
└──────────┬──────────┘
           │
           ├──────────────────┬──────────────────┬───────────────┬──────────────┐
           │                  │                  │               │              │
           ▼                  ▼                  ▼               ▼              ▼
    ┌──────────┐      ┌──────────────┐   ┌──────────┐   ┌────────────┐  ┌──────────┐
    │    CI    │      │ Build & Test │   │  Code    │   │  Security  │  │    PR    │
    │          │      │              │   │ Quality  │   │  Scanning  │  │Validation│
    └──────────┘      └──────┬───────┘   └──────────┘   └──────────┘  └──────────┘
                             │
                             │ (on success)
                             ▼
                      ┌─────────────┐
                      │Docker Build │
                      └──────┬──────┘
                             │
                             │ (on main/develop/tags)
                             ▼
                      ┌─────────────┐
                      │   Deploy    │
                      └─────────────┘
```

---

## Performance Benchmarks

**Target CI/CD Times**:

| Workflow          | Target Time | Actual (Avg) |
|-------------------|-------------|--------------|
| CI                | < 2 min     | TBD          |
| Build & Test      | < 15 min    | TBD          |
| Code Quality      | < 10 min    | TBD          |
| Security          | < 20 min    | TBD          |
| Docker Build      | < 30 min    | TBD          |
| PR Validation     | < 5 min     | TBD          |
| Deploy (Dev)      | < 5 min     | TBD          |
| Deploy (Staging)  | < 10 min    | TBD          |
| Deploy (Prod)     | < 20 min    | TBD          |

**Optimization Strategies**:
- Caching: Maven, npm, Docker layers
- Parallelization: Matrix builds, concurrent jobs
- Incremental builds: Only changed services
- Test selection: Affected tests only

---

## Troubleshooting

### Build Failures

**Symptom**: Build fails with compilation errors

**Solution**:
1. Check build logs for specific errors
2. Run build locally: `mvn clean install` or `npm run build`
3. Ensure dependencies are up to date
4. Check Java/Node version compatibility

### Test Failures

**Symptom**: Tests fail in CI but pass locally

**Solution**:
1. Check for race conditions or timing issues
2. Verify test isolation
3. Check environment variables
4. Run tests with same CI environment locally (Docker)

### Security Scan Failures

**Symptom**: Trivy/Snyk reports vulnerabilities

**Solution**:
1. Review vulnerability details
2. Update vulnerable dependencies
3. If false positive, add suppression rule
4. For unfixable vulnerabilities, document risk acceptance

### Docker Build Failures

**Symptom**: Docker build fails or times out

**Solution**:
1. Check Dockerfile syntax
2. Verify base image exists
3. Check network connectivity
4. Increase timeout if needed
5. Review build logs for specific errors

### Deployment Failures

**Symptom**: Deployment to Kubernetes fails

**Solution**:
1. Verify kubeconfig secret is correct
2. Check Kubernetes cluster health
3. Verify namespace exists
4. Check resource quotas
5. Review Helm chart values
6. Check pod logs: `kubectl logs <pod>`

### Secret Scanning False Positives

**Symptom**: TruffleHog/Gitleaks reports non-secret as secret

**Solution**:
1. Add to `.gitleaksignore` or `.trufflehog ignore`
2. Use placeholder values in examples
3. Document why it's not a real secret

---

## Best Practices

### 1. Writing CI-Friendly Code

- ✅ Write deterministic tests (no randomness)
- ✅ Mock external dependencies
- ✅ Use test containers for databases
- ✅ Keep tests fast (< 10s per test)
- ✅ Avoid hardcoded values (use environment variables)

### 2. Optimizing CI Time

- ✅ Cache dependencies (Maven, npm, Docker layers)
- ✅ Run tests in parallel
- ✅ Use matrix builds for multi-platform
- ✅ Split large test suites
- ✅ Only build changed services

### 3. Security

- ✅ Never commit secrets (use GitHub Secrets)
- ✅ Scan all dependencies regularly
- ✅ Use minimal base images (Alpine, Distroless)
- ✅ Sign commits and container images
- ✅ Enable Dependabot

### 4. Pull Requests

- ✅ Keep PRs small (< 500 lines)
- ✅ Write descriptive titles and descriptions
- ✅ Link to related issues
- ✅ Add tests for new features
- ✅ Update documentation

### 5. Deployments

- ✅ Test in staging before production
- ✅ Use blue-green or canary deployments
- ✅ Monitor post-deployment (5-10 minutes)
- ✅ Have rollback plan ready
- ✅ Document deployment changes

---

## Monitoring and Alerts

### GitHub Actions Notifications

- ✅ Workflow status notifications (GitHub web/email)
- ✅ Slack notifications (deployment workflow)
- ✅ PR comments (validation results)

### Monitoring Integrations

- **Datadog**: Deployment events, APM
- **New Relic**: Deployment markers
- **Sentry**: Error tracking
- **Prometheus**: Metrics collection
- **Grafana**: Dashboards

### Alert Routing

| Alert Type | Severity | Notification Channel |
|------------|----------|----------------------|
| Build failure on main | High | Slack #alerts, Email |
| Security vulnerability (critical) | Critical | Slack #security, PagerDuty |
| Deployment failure | High | Slack #deployments, Email |
| Test flakiness | Medium | Slack #engineering |
| Code quality degradation | Low | PR comment |

---

## Changelog

| Date | Version | Changes |
|------|---------|---------|
| 2026-01-07 | 1.0 | Initial comprehensive CI/CD pipeline |

---

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Helm Documentation](https://helm.sh/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [SonarQube Documentation](https://docs.sonarqube.org/)
- [Snyk Documentation](https://docs.snyk.io/)

---

**Last Updated**: January 2026
**Maintained By**: DevOps Team
**Contact**: devops@smartcityconnect.com

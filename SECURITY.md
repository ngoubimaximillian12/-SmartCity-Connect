# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          | Support Ends   |
| ------- | ------------------ | -------------- |
| 2.0.x   | :white_check_mark: | Active         |
| < 2.0   | :x:                | Not supported  |

---

## Reporting a Vulnerability

**DO NOT** open public issues for security vulnerabilities.

### How to Report

1. **Email**: Send details to **security@smartcityconnect.com**
2. **GitHub Security Advisory**: [Create a private security advisory](https://github.com/ngoubimaximillian12/-SmartCity-Connect/security/advisories/new)
3. **PGP Encrypted**: Use our PGP key for sensitive reports

### What to Include

Please provide:

- **Description**: Detailed explanation of the vulnerability
- **Impact**: What can an attacker do?
- **Steps to Reproduce**: Clear reproduction steps
- **Proof of Concept**: Code or screenshots (if applicable)
- **Suggested Fix**: If you have ideas for fixing
- **Environment**: Versions, OS, configuration

### Response Timeline

- **Initial Response**: Within 24 hours
- **Triage**: Within 72 hours
- **Status Update**: Weekly until resolved
- **Fix Timeline**: Depends on severity (see below)

### Severity Levels and Response Times

| Severity | Description | Response Time | Fix Timeline |
|----------|-------------|---------------|--------------|
| **Critical** | Remote code execution, SQL injection, authentication bypass | Immediate | 1-7 days |
| **High** | Data exposure, privilege escalation, CSRF | < 24 hours | 7-14 days |
| **Medium** | Information disclosure, XSS, weak encryption | < 72 hours | 14-30 days |
| **Low** | Minor information leaks, best practice violations | < 7 days | 30-90 days |

---

## Security Measures

### Automated Security

- **Secret Scanning**: TruffleHog, Gitleaks (daily)
- **Dependency Scanning**: Snyk, OWASP Dependency Check
- **Container Scanning**: Trivy (on every build)
- **SAST**: Semgrep, CodeQL
- **IaC Scanning**: Checkov, Trivy

### Security Policies

- **Secrets**: Never commit secrets (GitHub secret scanning enabled)
- **Dependencies**: Reviewed and scanned weekly
- **Container Images**: Scanned before deployment
- **Code Review**: Required for all changes
- **Encryption**:
  - Data at rest: AES-256
  - Data in transit: TLS 1.3
  - Secrets management: HashiCorp Vault

### Compliance

- **GDPR**: General Data Protection Regulation
- **CCPA**: California Consumer Privacy Act
- **HIPAA**: Health Insurance Portability and Accountability Act (for healthcare services)
- **SOC 2 Type II**: In progress
- **ISO 27001**: Planned

---

## Security Best Practices for Contributors

### Code Security

1. **Input Validation**: Always validate and sanitize user input
2. **Parameterized Queries**: Never use string concatenation for SQL
3. **Authentication**: Use OAuth2/OIDC, never roll your own
4. **Authorization**: Check permissions on every request
5. **Error Handling**: Don't expose sensitive information in errors

### Secrets Management

- ✅ Use environment variables or HashiCorp Vault
- ❌ Never hardcode secrets in code
- ❌ Never commit `.env` files
- ✅ Use `.env.example` for structure only
- ✅ Rotate secrets regularly

### Dependencies

- ✅ Keep dependencies up to date
- ✅ Review security advisories
- ✅ Use exact versions in production
- ❌ Don't use deprecated packages
- ✅ Run `npm audit` / `mvn dependency:check` regularly

### API Security

- ✅ Use HTTPS/TLS for all endpoints
- ✅ Implement rate limiting
- ✅ Validate JWT tokens
- ✅ Use CORS policies
- ✅ Enable CSRF protection
- ✅ Implement request validation

### Docker Security

- ✅ Use official base images
- ✅ Scan images for vulnerabilities
- ✅ Don't run as root
- ✅ Use multi-stage builds
- ✅ Minimize image size
- ❌ Don't include secrets in images

---

## Known Security Considerations

### Authentication

- **Method**: OAuth2/OIDC via Keycloak
- **Token Type**: JWT
- **Token Expiry**: 15 minutes (access), 7 days (refresh)
- **MFA**: Supported via TOTP

### Data Privacy

- **PII Encryption**: AES-256 at rest
- **Anonymization**: K-anonymity for trajectory data
- **Data Retention**: Configurable per service
- **Right to Delete**: GDPR compliant

### Network Security

- **TLS**: Minimum version 1.3
- **Certificate Pinning**: Enabled for mobile apps
- **WAF**: Cloudflare WAF enabled
- **DDoS Protection**: Cloudflare + rate limiting
- **Zero Trust**: Network segmentation, least privilege

### Infrastructure Security

- **Kubernetes RBAC**: Enabled
- **Network Policies**: Implemented
- **Secret Management**: HashiCorp Vault
- **Image Scanning**: Trivy, Snyk
- **Pod Security Standards**: Restricted

---

## Security Updates

### How We Notify

1. **GitHub Security Advisories**: Published for all CVEs
2. **Release Notes**: Security fixes documented
3. **Email**: Critical vulnerabilities sent to registered users
4. **RSS Feed**: Subscribe to security updates

### Update Process

1. Security patch developed
2. Testing in staging environment
3. Security advisory published
4. Patch released with version bump
5. Automatic deployment to production (after approval)

---

## Security Audit History

| Date | Auditor | Type | Findings | Status |
|------|---------|------|----------|--------|
| 2026-Q2 | TBD | Penetration Test | TBD | Planned |
| 2026-Q1 | TBD | Code Audit | TBD | Planned |

---

## Bug Bounty Program

**Status**: Coming soon

We plan to launch a bug bounty program in Q2 2026.

**Scope**: All SmartCity Connect services
**Rewards**: $100 - $10,000 depending on severity
**Platform**: HackerOne (planned)

---

## Security Contact

- **Email**: security@smartcityconnect.com
- **Response Time**: < 24 hours
- **PGP Key**: [Download](https://smartcityconnect.com/pgp-key.asc)
- **Security Portal**: https://security.smartcityconnect.com

---

## Hall of Fame

We thank the following researchers for responsibly disclosing security issues:

*(No entries yet - be the first!)*

---

## Legal

### Safe Harbor

SmartCity Connect supports safe harbor for security researchers who:

- Make a good faith effort to avoid privacy violations
- Contact us before publicly disclosing vulnerabilities
- Give us reasonable time to address issues
- Do not exploit vulnerabilities beyond proof of concept
- Do not access or modify user data
- Do not perform DoS attacks

We will not pursue legal action against researchers who follow these guidelines.

### Coordinated Disclosure

We follow a 90-day coordinated disclosure timeline:

1. **Day 0**: Vulnerability reported
2. **Day 1**: Initial response sent
3. **Day 7**: Triage and severity assessment
4. **Day 7-90**: Fix development and testing
5. **Day 90**: Public disclosure (or when fix is deployed)

We may request extension if:
- Complexity requires more time
- Coordinating with third-party vendors
- Waiting for coordinated release

---

## Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [Security.txt](https://securitytxt.org/)

---

**Last Updated**: January 7, 2026
**Version**: 1.0
**Next Review**: April 2026

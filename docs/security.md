# Security Model

## Security Principles

This platform is designed around the following principles:

- Identity-based authentication over static credentials  
- Least-privilege access at every layer  
- Short-lived credentials wherever possible  
- Clear separation between CI, CD, and runtime trust boundaries  

Security controls are applied to limit blast radius and reduce the impact of potential compromise.

---

## Identity and Authentication

### CI Identity

GitHub Actions authenticates to AWS using OpenID Connect (OIDC).

- No long-lived cloud credentials are stored in GitHub  
- IAM roles are scoped per workflow  
- Credentials are short-lived and automatically rotated  

---

### Runtime Identity

Runtime authentication to secrets backends is delegated to controllers, not application pods.

- External Secrets Controller authenticates to HashiCorp Vault  
- Authentication uses Kubernetes-native auth  
- Application pods never communicate directly with Vault  

Pods consume secrets exclusively via Kubernetes Secrets.

---

## Secrets Lifecycle

### CI Secrets

- Secrets originate in AWS Secrets Manager  
- Retrieved dynamically during workflow execution  
- Exposed as ephemeral environment variables  
- Never committed to Git or embedded in container images  

---

### Runtime Secrets

Runtime secret flow follows this path:

```
Vault → External Secrets Controller → Kubernetes Secret → Application Pod
```

- Secrets are materialized only within the cluster  
- Vault tokens are managed and rotated by the controller  
- Application containers have no direct Vault access  


## Blast Radius and Failure Scenarios

### Compromised CI Workflow

- Attacker gains temporary IAM role access  
- Access is limited by role scope and session duration  
- No persistent credentials are exposed  

---

### Compromised Application Pod

- Attacker gains access only to that pod's Kubernetes Secrets  
- No cloud IAM credentials are available  
- No direct access to Vault or other secrets backends  

---
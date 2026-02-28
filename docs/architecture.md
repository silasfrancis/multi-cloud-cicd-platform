# Architecture Overview

> **Note**: For security-specific details, see [security.md](security.md). For getting started, see the [root README](../README.md).

## System Overview

This platform is a production-style, multi-cloud CI/CD reference architecture designed to demonstrate secure delivery of containerized applications across isolated environments.

The system is composed of three clearly separated planes:

- **CI (Build & Provisioning):** GitHub Actions  
- **CD (Deployment & Reconciliation):** ArgoCD (GitOps)  
- **Runtime (Execution):** Kubernetes clusters on AWS (EKS) and Linode (LKE)

Development and production environments run on separate cloud providers and clusters to enforce strong isolation and reduce shared blast radius.

---

## CI, CD, and Runtime Responsibilities

### Continuous Integration (CI)

CI is implemented using GitHub Actions and is responsible for:

- Building and testing application code  
- Creating immutable container images  
- Pushing images to container registries (ECR and Docker Hub)  
- Executing Terraform to provision or update infrastructure  

Authentication to cloud providers is handled using GitHub OIDC, allowing workflows to assume IAM roles without long-lived credentials.

---

### Continuous Delivery (CD)

CD is handled using ArgoCD following a GitOps model.

- Git is the single source of truth for desired cluster state  
- Helm manifests and image tags are version-controlled  
- ArgoCD continuously reconciles cluster state to match Git  

Deployments are declarative and auditable. No imperative deployment commands (for example, `kubectl apply`) are used in CI pipelines.

---

### Runtime Execution

Applications run as Kubernetes workloads with minimal permissions.

- Pods do not contain cloud credentials  
- Runtime secrets are consumed as Kubernetes Secrets  
- Application containers never communicate directly with Vault  

---

## Infrastructure Boundaries

Terraform is responsible for provisioning and managing:

- Kubernetes clusters (EKS and LKE)  
- Networking components  
- IAM roles and identity mappings  
- Supporting cloud resources  

Kubernetes is responsible for:

- Application workloads  
- Service configuration  
- Secrets consumption  

This boundary prevents Terraform from being used as an application deployment mechanism and aligns infrastructure and application lifecycles appropriately.

---

## Environment Isolation

Each environment is fully isolated:

- Separate Kubernetes clusters  
- Separate Terraform state files  
- Separate ArgoCD applications  
- No shared secrets between environments  

Production runs on AWS (EKS), while development runs on Linode (LKE), reinforcing isolation and reducing the risk of cross-environment impact.

---

## High-Level Architecture Diagram

```
Developer → GitHub Actions (CI)
                ↓
            Terraform (IaC)
                ↓
        OpenID Connect (OIDC)
                ↓
     Container Registry (ECR / Docker Hub)
                ↓
   Update Helm Manifests (Git)
                ↓
             ArgoCD
                ↓
   Deploy to Kubernetes (EKS / LKE)


Client → ALB Gateway (Gateway API)
                ↓
            HTTPRoute
                ↓
        Application Pods → Kubernetes Secrets ← External Secrets Controller → Vault

```


Terraform is executed via CI to manage infrastructure, while ArgoCD continuously reconciles application state from Git.

## Related Documentation

- [← Back to README](../README.md)
- [security.md→](security.md)
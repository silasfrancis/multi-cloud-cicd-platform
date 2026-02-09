# Production-Grade Multi-Cloud CI/CD Platform

A production-grade, multi-cloud CI/CD platform built with Kubernetes, Terraform, GitHub Actions, and ArgoCD.

The platform runs a FastAPI backend and React frontend, with production on AWS (EKS) and development on Linode (LKE). It demonstrates secure CI/CD practices using GitHub OIDC, GitOps, and Kubernetes-native secrets management.

## About
Scalable cloud systems must support automated deployment without compromising security.

This project mirrors a real-world, multi-environment setup where development and production run on different cloud providers. It focuses on secure CI/CD pipelines, environment isolation, and repeatable infrastructure patterns suitable for production workloads.

## Design Goals

- Zero long-lived cloud credentials in CI
- Clear separation between dev and production environments
- GitOps-based deployments with auditability
- Cloud-agnostic infrastructure modules
- Secrets never stored in Git or container images

## Features:

- Multiple cloud platforms for various environments
- Scalable secrets management for Kubernetes and CI pipelines
- Repeatable CI/CD workflows built for multi-environment setups
- Infrastructure as Code with modules to handle multiple cloud platforms

## What This Project Demonstrates

- Automated build and push pipelines to container registries (AWS ECR and Docker Hub)
- Immutable container images with versioned tags
- IAM roles assumed via GitHub Actions OIDC
- Secure CI secrets management using AWS Secrets Manager
- Kubernetes secrets management using HashiCorp Vault
- GitOps-based deployments using ArgoCD
- Kubernetes deployments on AWS (production) and Linode (development)


## Security Model

- GitHub Actions uses OIDC to assume AWS IAM roles (no static credentials)
- CI secrets are sourced from AWS Secrets Manager
- Kubernetes secrets are managed via HashiCorp Vault
- Applications authenticate to Vault using Kubernetes auth

## High-Level Architecture

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
**Execution Model**
Terraform is executed via GitHub Actions for infrastructure provisioning and updates.
Application deployments are managed separately using GitOps through ArgoCD.

**GitOps Source of Truth**
ArgoCD continuously reconciles Kubernetes state from Git, where Helm manifests and image tags are version-controlled.

**Authentication**
GitHub Actions authenticates to AWS using OIDC, eliminating the need for long-lived credentials in CI.
Runtime workloads consume secrets synced by External Secrets Controller, which authenticates to HashiCorp Vault using Kubernetes-native authentication.

**Runtime** 
CI pipelines handle build, test, and infrastructure changes, while runtime application access to secrets is handled exclusively within the cluster.

## Repository Structure

```
.
├── .github
│   ├── actions
│   ├── appmod
│   └── workflows
├── argocd
│   ├── dev
│   └── main
├── backend
│   ├── fastapi
│   └── postgres_db
├── docs
├── e2e-test
│   └── playwright
├── frontend
│   ├── react-recoil
│   └── react-recoil-realworld-example-app
├── helm
│   ├── app
│   ├── db
│   └── platform
├── terraform
│   ├── aws_modules
│   ├── env
│   └── linode_modules
└── utils
```

### Repository Structure Overview

- `.github/` – GitHub Actions workflows, reusable actions, and CI logic
- `argocd/` – GitOps application manifests per environment
- `backend/` – FastAPI application and database migration files
- `frontend/` – React frontend implementations
- `helm/` – Helm charts for application, database, and platform components (Gateway Class, Gateway API and HTTP Routes)
- `terraform/` – Infrastructure modules and environment definitions
- `docs/` – Architecture notes and design documentation
- `utils/` – Tasks used by Git actions

## Getting Started (High-Level)

This project is not intended to be a one-click deployment.  
It assumes familiarity with Terraform, Kubernetes, and cloud IAM.

High-level steps:
1. Provision infrastructure using Terraform
2. Bootstrap ArgoCD on each cluster
3. Configure secrets backends (AWS Secrets Manager / Vault)
4. Install Helm Repos in each cluster using the designated environment variables
5. Push changes to the repository to trigger automated GitOps deployments


## Limitations & Future Work
- Observability (Prometheus/Grafana) is planned but not fully implemented
- Due to cost optimization and autoscaling policies are minimal


## Additional Documentation

- [`docs/architecture.md`](docs/architecture.md) – System architecture and environment boundaries
- [`docs/security.md`](docs/security.md) – Identity, secrets management, and threat model

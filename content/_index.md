---
title: "Experience"
date: 2025-01-01
draft: false
rss_ignore: true
---

**Backend/Infrastructure Engineer** focused on policy-based authZ systems (OPA/Envoy), ML inference infrastructure on GPU clusters, and distributed Go services. Currently building GPU-based inference services with gRPC and cloud providers(AWS/GCP).

*India-based • Open to remote work with European teams*

---

<div class="timeline">
  <div class="timeline-item">
    <span class="timeline-date">Jan 2022 - Jun 2022</span>
    <span class="timeline-company">State Street(Remote)</span>
    <span class="timeline-role">Intern</span>
  </div>
  <div class="timeline-item">
    <span class="timeline-date">Sep 2022 - Sep 2023</span>
    <span class="timeline-company">Optum, UnitedHealth Group(Remote)</span>
    <span class="timeline-role">Associate Software Engineer</span>
  </div>
  <div class="timeline-item">
    <span class="timeline-date">Sep 2023 - Apr 2025</span>
    <span class="timeline-company">Optum, UnitedHealth Group(Remote)</span>
    <span class="timeline-role">Software Engineer</span>
  </div>
  <div class="timeline-item">
    <span class="timeline-date">May 2025 - Present</span>
    <span class="timeline-company">Gruve.ai(Hybrid)</span>
    <span class="timeline-role">Software Engineer - 2</span>
  </div>
</div>

---

### Gruve.ai  

**Software Engineer – 2** (Hybrid)| May 2025 – Present  

- Designed and implemented an OTP-based authentication system by integrating **Dex (OIDC provider)** with **Redis**, extending the identity broker to support multi-factor authentication flows  
- Engineered a **token revocation mechanism** by bridging Dex’s OIDC implementation with an internal RBAC manager, addressing missing functionality in the upstream open-source stack  
- Architected the **authentication and authorization domain (AuthX)** in collaboration with principal engineers and the founding team, managing token lifecycle, session state, and RBAC enforcement across microservices  
- Built and demonstrated **end-to-end PoCs and internal demos**, leveraging **LLM-assisted development** to accelerate API design, backend implementation, and test scaffolding under tight timelines  
- Resolved a critical production bug causing platform-wide authentication failures, restoring service availability and preventing user lockout.
- Redesigned the authentication/authorization stack around **OPA** as sidecar policy decision point with **Envoy ext_authz** as the enforcement layer and **Postgres RLS** as a defense-in-depth backstop; separated policy (Rego, CI-built bundles) from live binding data served via a bundle server
- Designed **EntitlementService** as the policy administration/information point, owning RBAC binding writes independent of tenant lifecycle — decoupling `tenant_id` (billing scope) from `org_id` (authZ scope)
- Built JWT refresh-token architecture with `jti`-based rotation, **token-family reuse detection**, and family-wide revocation for gRPC clients, including proactive/reactive refresh strategies
- Led an **Alluxio Enterprise AI** POC as an S3 caching layer for vLLM model-weight loading on an H200 GPU cluster (8×H200/node, NVMe RAID5); root-caused etcd WAL fsync contention, JVM direct-buffer exhaustion under concurrent large reads, and TLS/zero-copy port conflicts in the S3 proxy
- Built a Go benchmarking harness (baseline, cache-miss, cache-hit, prefetch, concurrency) across 7B–70B model sizes, comparing RunAI Streamer against S3 vs. Alluxio-cached loads

**Optum, UnitedHealth Group** (Remote)| Software Engineer | Sep 2023 - Apr 2025

- Built Golang-ReactJS application replacing legacy IBM product, saving $80k in annual licensing costs
- Led security remediation initiative reducing 400+ critical/high vulnerabilities across production systems
- Migrated CI/CD infrastructure to GitHub Actions, halving deployment times while reducing infrastructure costs
- Developed authentication layer with OAuth2 and role-based access control for internal deployment tools

**Optum, UnitedHealth Group** (Remote)| Associate Software Engineer | Sep 2022 - Sep 2023

- Led enterprise migration from Team Foundation Version Control to GitHub Enterprise Cloud
- Rebuilt CI/CD pipelines in GitHub Actions, reducing Azure DevOps infrastructure dependency
- Automated workflow tasks using Linux scripting and GitHub REST API

**State Street** (Remote)| Software Engineering Intern | Jan 2022 - Jun 2022

- Built Golang CLI tools for workflow automation

---

## My Journey in Software Engineering

I've spent the past few years building backend systems, automating infrastructure, and solving problems that matter. My journey started with a Go CLI tool during an internship at State Street, evolved through leading enterprise migrations and security remediation at Optum, and now focuses on architecting production-grade authZ platforms with OPA/Envoy and optimizing ML inference infrastructure on GPU clusters at Gruve.ai.

I've always believed in engineering systems that are both practical and robust — whether that's replacing a legacy IBM product to save $80k/year in licensing, designing token-family rotations with reuse detection, or root-causing etcd WAL fsync contention on an H200 cluster.

---

## Key Projects

### Multi-tenant AuthZ Platform

Architected a production-grade authentication/authorization system for a multi-service gRPC platform: OPA as policy decision point, Envoy ext_authz enforcement, EntitlementService as the single writer of RBAC bindings, and Postgres RLS as backstop. Designed token-family-based refresh rotation with single-use semantics and reuse detection for revocation.

### ML Weight-Caching Infrastructure (Alluxio + vLLM)

Operated and debugged an Alluxio Enterprise AI 3.8 deployment caching S3-hosted model weights for vLLM inference on H200 GPUs. Diagnosed etcd/worker I/O contention on shared RAID5, fixed TLS/zero-copy mutual exclusivity on the S3 proxy, and built topology-aware routing for cache locality.

---

## Technical Skills

**Languages & Frameworks**: Golang • JavaScript/TypeScript • ReactJS • Python

**Databases**: PostgreSQL (RLS) • MySQL • MSSQL

**DevOps & Cloud**: AWS • Docker • Kubernetes • GitHub Actions • Azure DevOps • Linux Scripting • PowerShell • Bazel/Bzlmod

**Architecture & Patterns**: gRPC • REST APIs • Microservices • Distributed Systems • OPA/Rego • Envoy ext_authz • Alluxio • etcd • vLLM

**Tools & Platforms**: Git • GitHub API • NodeJS • Webpack • CI/CD Pipelines • Ubuntu

**Focus Areas**: Backend Systems • AuthZ Platforms • ML Inference Infrastructure • Performance Optimization • Cloud Migration • Security & Vulnerability Management

---

## Let's Connect

Open to backend, infrastructure, and ML-infra engineering roles focused on Go, Kubernetes, authZ platforms, and performance optimization.

**Reach out via [LinkedIn](https://linkedin.com/in/c-j-atharva), [Bluesky](https://bsky.app/profile/cjatharva.bsky.social), or [GitHub](https://github.com/toothsy)**

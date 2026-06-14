# AI Rules & Guidelines

## 1. Language Rule (Strict)
- ALL code, variable names, branch names, commit messages, and repository structure MUST be in ENGLISH.
- ALL explanations, responses, and documentation text directed to the user MUST be in PORTUGUESE.

## 2. Core Philosophy
- Absolute focus on simplicity and readability.
- This is a portfolio project for Technical Storytelling, not production-ready enterprise code.
- Prioritize "why" over "how complex it is".

## 3. Mandatory Tech Stack
- Backend: FastAPI (Python)
- Infrastructure as Code: Terraform
- Cloud Provider: Google Cloud Platform (GCP)
- GCP Services: Cloud Run, Cloud Spanner, Pub/Sub, Memorystore (Redis), Global Load Balancer.

## 4. Anti-Patterns (Prohibited)
- NO overengineering.
- NO deep Repository Patterns or 10-layer Clean Architecture.
- NO unnecessary abstractions. Use direct, flat, and highly readable scripts.

## 5. Documentation & Comments
- Every Terraform resource and critical code block MUST have comments explaining the decision specifically in the context of handling high traffic (2M users, 80k tickets).
- Focus comments on scalability, concurrency, and state management.
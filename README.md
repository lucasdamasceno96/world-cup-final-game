# World Cup Final Ticketing Platform

## The Challenge (Business Case)
Selling 80,000 tickets for the World Cup Final to a global audience of 2 million concurrent users. The system must prevent overselling, handle massive traffic spikes without crashing, and provide a fair, low-latency experience. This project demonstrates architectural decisions for high-concurrency event-driven systems on GCP.

## Proposed Architecture
*(Insert Architecture Diagram Here - e.g., draw.io or Excalidraw export)*

**High-Level Flow:**
1. Global Load Balancer distributes traffic.
2. Cloud Run hosts the stateless FastAPI application, scaling automatically.
3. Memorystore (Redis) handles rate limiting and temporary ticket reservation locks.
4. Pub/Sub queues the actual purchase requests to smooth out database write spikes.
5. Cloud Spanner provides globally consistent, strongly transactional inventory management to prevent overselling.

## Tech Stack
- **Compute:** Google Cloud Run (Serverless, auto-scaling)
- **Database:** Google Cloud Spanner (Horizontal scaling, strong consistency)
- **Cache/Locking:** Google Cloud Memorystore for Redis (Sub-millisecond reservation locks)
- **Messaging:** Google Pub/Sub (Asynchronous processing, load leveling)
- **Networking:** Global External HTTP(S) Load Balancer
- **Backend:** FastAPI (Python)
- **IaC:** Terraform

## Trade-offs & Design Decisions
*(Reserved for future elaboration)*
- **Spanner vs. Firestore:** Chose Spanner for strong ACID transactions across distributed nodes, critical for inventory integrity.
- **Synchronous vs. Asynchronous:** Ticket reservation is synchronous (fast lock), but final purchase is asynchronous (Pub/Sub) to absorb write spikes.
- **Simplicity vs. Perfection:** Omitted complex microservice boundaries in favor of a modular monolith to keep the portfolio focused on cloud infrastructure and concurrency patterns.
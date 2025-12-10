# CSC-581-Project-AI-Trip-Advisor

AI Trip Advisor – Cloud-Native Travel Planning Platform
CSC 581 – Final Project

Authors: Sultan Fahim · James McKim · Karan Khademi · Will Huff · Clinton Uguwanyi
Department of Computer Science · West Chester University of Pennsylvania

🧭 Overview

The AI Trip Advisor is a cloud-native, Kubernetes-orchestrated travel-planning platform that turns raw user preferences into personalized travel itineraries using distributed microservices and AI-driven processing.

It showcases:

Real-time itinerary generation

Scalable microservices

Automated data orchestration

Intelligent LLM-assisted trip planning

📄 Table of Contents

Overview

Architecture

System Workflow

Pod Grouping

Routing & Services

Scaling & Self-Healing

Persistence Design

Known Limitations

Future Work

🏗️ 1. Architecture Recap

The system is built entirely using a microservices architecture, deployed on Kubernetes, and organized into multiple pods:

Pods
Pod	Purpose	Notes
Frontend (Node.js)	User interface, input handling	Horizontally scalable
Backend (Flask/Python)	Workflow orchestration; API gateway	System “brain”
AI Agent Service	LLM itinerary generation + geocoding	CPU-intensive
MongoDB Stateful Pod	Persistent storage	Uses PVC
(Optional) Scheduler/Worker	Background itinerary jobs	For async workloads
🖼️ 1.1 Architecture Diagram

(Insert your diagram here — recommended: PNG or SVG)

[ User ] → Frontend → Backend → AI Agent → External APIs
                       ↓
                    MongoDB

⚙️ 1.2 Architectural Choices

Microservices over Monolith → Independent scaling & deployment

Docker Containerization → Environment consistency

Kubernetes Orchestration → Self-healing, scaling, service discovery

Loose Coupling → Replace components without breaking others

🔄 2. Data Flow & System Workflow

High-level workflow:

User Input (destination, interests, budget)

Backend Validation

AI Agent Invocation

Geocoding + LLM Itinerary Generation

Itinerary Returned to Backend

Persistence in MongoDB

Frontend Rendering

🧩 3. Pod Grouping & Sidecar Decisions
3.1 Pod Grouping
Pod	Function	Rationale
Frontend	UI + traffic-heavy	Benefits from replicas
Backend	Orchestration	Core controller
AI Agent	LLM + geocoding	CPU-heavy tasks
MongoDB	Data storage	Requires StatefulSet
3.2 Sidecar Considerations

Sidecars considered but not implemented:

Fluentd Logging Sidecar → log aggregation

Redis Cache Sidecar → reduce geocoding calls

We avoided these to keep the architecture minimal for demonstration.

🌐 4. Services, Ingress & Routing
4.1 Services

ClusterIP – backend → AI Agent

ClusterIP – backend → MongoDB

NodePort + Ingress – expose frontend

4.2 Routing Diagram
External User → Ingress → Frontend Service → Backend Service
                                      ↓
                               AI Agent Service
                                      ↓
                                  MongoDB

4.3 Resilience Features

Pod restarts via liveness/readiness probes

DNS-based discovery for stable communication

Load balancing across replicas

📈 5. Scaling & Self-Healing Behavior
5.1 Horizontal Scaling Tests

Observations:

Frontend scales very efficiently

Backend scaling reduces latency

AI Agent was the main bottleneck — adding replicas improves throughput

5.2 Self-Healing Tests

Simulated:

Pod deletion

Failing probes

Heavy traffic

Results:

Kubernetes restarts pods automatically

Requests redirect to healthy replicas

MongoDB maintains integrity thanks to PVC

🗄️ 6. Persistence Design
6.1 MongoDB Collections

users → profiles & preferences

requests → raw user input

itineraries → final generated plans

6.2 Verification

Tested insert/retrieval via backend API

Verified persistence across pod restarts

Simulated MongoDB failure & rescheduling

⚠️ 7. Known Limitations

LLM latency under heavy load

No API rate-limiting

Geocoding not cached → higher latency

Minimal authentication

UI is basic

Scheduler not fully developed

⭐ 8. Future Work

Add Redis or Memcached

Implement OAuth authentication

CI/CD with GitHub Actions + ArgoCD

Add pricing/hotel/transportation data

Distributed tracing with OpenTelemetry

Autoscaling with custom CPU/memory rules

Improved responsive UI

🎉 Thanks for Visiting!

If you like this project, consider ⭐ starring the repo!


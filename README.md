# Cloud-Based Digital Health Record & Appointment Management System for Migrant Worker Clinics

> **Semester 5 Mini Project — Cloud Computing Domain**  
> A scalable, cloud-native healthcare platform designed to streamline medical record keeping and appointment scheduling for migrant worker clinics.

---

## 📌 Project Overview

Migrant workers often face barriers in accessing continuous, organized healthcare due to mobility, language barriers, and fragmented record-keeping. This platform provides:
- **Digital Health Records**: Secure, centralized patient health history accessible across clinic locations.
- **Appointment Management**: Simplified scheduling and queue management for clinic visits.
- **Multilingual & Mobile-First Interface**: Accessible on mobile devices for healthcare workers and clinic staff.
- **Cloud Infrastructure**: Scalable containerized backend microservices deployed on Google Cloud Platform with managed PostgreSQL database.

---

## 🛠️ Technology Stack

| Layer | Technology |
| :--- | :--- |
| **Mobile Application** | Flutter, Riverpod (State Management) |
| **Backend API** | Node.js, Express.js |
| **Database** | PostgreSQL (Google Cloud SQL) |
| **Authentication** | Firebase Auth (Phone OTP) |
| **Push Notifications** | Firebase Cloud Messaging (FCM) |
| **Containerization** | Docker |
| **CI/CD Pipeline** | GitHub Actions |
| **Cloud Hosting** | Google Cloud Run, Google Cloud SQL |

---

## 📁 Repository Structure (Planned)

```text
.
├── mobile_app/         # Flutter Mobile Application
├── backend/            # Node.js Express REST API
├── docker/             # Dockerfiles & docker-compose configurations
├── .github/            # GitHub Actions workflows for CI/CD
├── README.md           # Project Documentation
└── .gitignore          # Git ignore rules for Flutter, Node.js & IDEs
```

---

## 🚀 Getting Started (Setup Instructions Placeholder)

*Detailed setup guides for local development, database migrations, and cloud deployment will be updated as modules are developed.*

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable)
- [Node.js](https://nodejs.org/) (v18+ LTS)
- [Docker Desktop](https://www.docker.com/)
- [Google Cloud SDK (gcloud CLI)](https://cloud.google.com/sdk/docs/install)
- [Git](https://git-scm.com/)

### Quick Start (Local Development)
```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/<your-repo-name>.git
cd <your-repo-name>

# 2. Setup backend (Coming Soon - Day 6+)
# cd backend && npm install

# 3. Setup mobile app (Coming Soon - Day 7+)
# cd mobile_app && flutter pub get
```

---

## 📄 License & Attribution

Developed as part of the Semester 5 Mini Project for Cloud Computing.

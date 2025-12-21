# Commited Platform - Complete Infrastructure Setup Guide
## From Zero to Hero: Building a Microservices Classroom Platform

**Version:** 1.0  
**Last Updated:** December 2025  
**Project:** Commited - AI-Powered Classroom Management Platform

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Overview](#project-overview)
3. [Architecture Deep Dive](#architecture-deep-dive)
4. [Phase 1: Environment Setup](#phase-1-environment-setup)
5. [Phase 2: GitHub Organization & Repositories](#phase-2-github-organization--repositories)
6. [Phase 3: Database Infrastructure](#phase-3-database-infrastructure)
7. [Phase 4: Service Development](#phase-4-service-development)
8. [Phase 5: Docker Configuration](#phase-5-docker-configuration)
9. [Phase 6: Networking & Communication](#phase-6-networking--communication)
10. [Phase 7: Integration & Testing](#phase-7-integration--testing)
11. [Phase 8: Production Deployment](#phase-8-production-deployment)
12. [Troubleshooting Guide](#troubleshooting-guide)
13. [Best Practices](#best-practices)

---

## Prerequisites

### Required Software

Install the following on your development machine:

#### Core Tools
- **Git** (v2.40+): `git --version`
- **Docker Desktop** (v24.0+): `docker --version` and `docker-compose --version`
- **Node.js** (v18+ LTS): `node --version`
- **npm or yarn**: `npm --version`

#### Language-Specific Tools
- **Java JDK 17+**: `java -version`
- **Maven** (v3.8+): `mvn --version`
- **PHP** (v8.2+): `php --version`
- **Composer**: `composer --version`
- **Python** (v3.11+): `python --version`
- **pip**: `pip --version`
- **.NET SDK** (v8.0+): `dotnet --version`

#### Database Tools
- **Oracle SQL Developer** or **DBeaver** (for database management)
- **Oracle Instant Client** (for local Oracle connectivity)

#### Optional but Recommended
- **Postman** or **Insomnia** (API testing)
- **VSCode** with extensions:
  - Docker
  - Remote - Containers
  - GitLens
  - Language-specific extensions
- **k9s** (if using Kubernetes later)

### Required Accounts

1. **GitHub Account** (with organization creation capability)
2. **Docker Hub Account** (for pushing images)
3. **Oracle Account** (for downloading Oracle container images)
4. **OpenAI API Key** (for AI analysis features)

### System Requirements

- **RAM**: Minimum 16GB (32GB recommended)
- **Disk Space**: 50GB+ free space
- **OS**: Windows 10/11 Pro, macOS 12+, or Linux (Ubuntu 20.04+)

---

## Project Overview

### What We're Building

**Commited** is a Google Classroom clone with AI-powered code analysis capabilities:

- **Teachers** create courses and assignments
- **Students** submit GitHub repository links as solutions
- **AI** analyzes submissions for code quality, plagiarism, and provides feedback
- **Real-time** notifications and analytics

### Technology Stack Summary

| Component | Technology | Purpose |
|-----------|-----------|---------|
| API Gateway | Spring Boot | Entry point, routing, authentication |
| Auth Service | Spring Boot/.NET | User management, JWT tokens |
| Course Service | Spring Boot | Course and enrollment management |
| Assignment Service | Symfony (PHP) | Assignment lifecycle management |
| Submission Service | Python (FastAPI) | Handle student submissions |
| AI Analysis Service | Python (FastAPI) | Code analysis with AI |
| Notification Service | .NET | Real-time notifications |
| Analytics Service | Python (FastAPI) | Data aggregation and insights |
| Frontend | React | User interface |
| Database | Oracle DB | Persistent data storage |
| Message Queue | RabbitMQ | Async communication |
| Cache | Redis | Session storage, caching |

### Service Communication Flow

```
User → Frontend → API Gateway → [Services] ⇄ Oracle DB
                                     ↓
                                 RabbitMQ → AI Analysis
                                     ↓
                              Notification Service
```

---

## Architecture Deep Dive

### Microservices Architecture Principles

#### 1. Service Independence
Each service:
- Has its own codebase and repository
- Can be developed, deployed, and scaled independently
- Owns its data (database per service pattern - with schemas)
- Communicates through well-defined APIs

#### 2. API Gateway Pattern
- Single entry point for all client requests
- Handles authentication and authorization
- Routes requests to appropriate services
- Implements rate limiting and caching

#### 3. Data Management Strategy

**Schema-per-Service Pattern:**
```
Oracle Database
├── COMMITED_AUTH (Auth Service)
├── COMMITED_COURSES (Course Service)
├── COMMITED_ASSIGNMENTS (Assignment Service)
├── COMMITED_SUBMISSIONS (Submission Service)
├── COMMITED_ANALYTICS (Analytics Service)
└── COMMITED_NOTIFICATIONS (Notification Service)
```

#### 4. Communication Patterns

**Synchronous (REST):**
- Client ↔ API Gateway
- Service ↔ Service (for immediate responses)

**Asynchronous (Message Queue):**
- Submission Service → AI Analysis Service
- Any Service → Notification Service

**Real-time (WebSocket):**
- Notification Service → Frontend

---

## Phase 1: Environment Setup

### Step 1.1: Install Docker Desktop

#### Windows
```powershell
# Download Docker Desktop from docker.com
# Enable WSL 2 backend
wsl --install

# Verify installation
docker --version
docker-compose --version
```

#### macOS
```bash
# Install via Homebrew
brew install --cask docker

# Or download from docker.com
# Start Docker Desktop

# Verify
docker --version
docker-compose --version
```

#### Linux (Ubuntu/Debian)
```bash
# Update packages
sudo apt-get update

# Install dependencies
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
docker compose version
```

### Step 1.2: Configure Docker Resources

Open Docker Desktop → Settings → Resources:

- **CPUs**: 4-6 cores
- **Memory**: 8-12 GB
- **Swap**: 2 GB
- **Disk**: 50 GB+

### Step 1.3: Install Development Tools

#### Java & Maven
```bash
# macOS
brew install openjdk@17 maven

# Ubuntu/Debian
sudo apt install openjdk-17-jdk maven

# Windows (Use Chocolatey)
choco install openjdk17 maven
```

#### PHP & Composer
```bash
# macOS
brew install php@8.2 composer

# Ubuntu/Debian
sudo apt install php8.2 php8.2-cli php8.2-fpm composer

# Windows
choco install php composer
```

#### Python
```bash
# macOS
brew install python@3.11

# Ubuntu/Debian
sudo apt install python3.11 python3.11-venv python3-pip

# Windows
choco install python311
```

#### .NET SDK
```bash
# macOS
brew install dotnet-sdk

# Ubuntu/Debian
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0

# Windows
choco install dotnet-sdk
```

### Step 1.4: Install Database Tools

#### Oracle SQL Developer
1. Download from: https://www.oracle.com/database/sqldeveloper/
2. Extract and run
3. No installation required

#### DBeaver (Alternative)
```bash
# macOS
brew install --cask dbeaver-community

# Ubuntu/Debian
sudo snap install dbeaver-ce

# Windows
choco install dbeaver
```

### Step 1.5: Setup Oracle Container Registry Access

Oracle Database images are not on Docker Hub. You need Oracle Container Registry access:

1. Go to: https://container-registry.oracle.com
2. Sign in with your Oracle account
3. Search for "database"
4. Accept the license for "Oracle Database Express Edition"
5. Login to Oracle registry from terminal:

```bash
docker login container-registry.oracle.com
# Username: your-oracle-email@example.com
# Password: your-oracle-password
```

---

## Phase 2: GitHub Organization & Repositories

### Step 2.1: Create GitHub Organization

1. Go to GitHub.com
2. Click your profile → "Your organizations"
3. Click "New organization"
4. Choose "Create a free organization"
5. Organization name: `commited-platform`
6. Contact email: your-email@example.com
7. Organization belongs to: "My personal account"

### Step 2.2: Create Repository Structure

Create these repositories in your organization:

```bash
# Clone this script and run it
# create-repos.sh

#!/bin/bash

ORG="commited-platform"
REPOS=(
    "commited-api-gateway"
    "commited-auth-service"
    "commited-course-service"
    "commited-assignment-service"
    "commited-submission-service"
    "commited-ai-analysis-service"
    "commited-notification-service"
    "commited-analytics-service"
    "commited-frontend"
    "commited-infrastructure"
    "commited-shared-libraries"
    "commited-docs"
)

for repo in "${REPOS[@]}"; do
    gh repo create "$ORG/$repo" --public --description "$repo for Commited Platform"
done
```

**Or manually** create each repository via GitHub UI with:
- Public/Private: Your choice
- Initialize with README: Yes
- .gitignore: Choose appropriate template
- License: MIT (recommended)

### Step 2.3: Clone Repositories Locally

Create a workspace directory:

```bash
# Create workspace
mkdir -p ~/workspace/commited-platform
cd ~/workspace/commited-platform

# Clone all repositories
git clone https://github.com/commited-platform/commited-api-gateway.git
git clone https://github.com/commited-platform/commited-auth-service.git
git clone https://github.com/commited-platform/commited-course-service.git
git clone https://github.com/commited-platform/commited-assignment-service.git
git clone https://github.com/commited-platform/commited-submission-service.git
git clone https://github.com/commited-platform/commited-ai-analysis-service.git
git clone https://github.com/commited-platform/commited-notification-service.git
git clone https://github.com/commited-platform/commited-analytics-service.git
git clone https://github.com/commited-platform/commited-frontend.git
git clone https://github.com/commited-platform/commited-infrastructure.git
git clone https://github.com/commited-platform/commited-shared-libraries.git
git clone https://github.com/commited-platform/commited-docs.git
```

Your workspace should look like:
```
~/workspace/commited-platform/
├── commited-api-gateway/
├── commited-auth-service/
├── commited-course-service/
├── commited-assignment-service/
├── commited-submission-service/
├── commited-ai-analysis-service/
├── commited-notification-service/
├── commited-analytics-service/
├── commited-frontend/
├── commited-infrastructure/
├── commited-shared-libraries/
└── commited-docs/
```

---

## Phase 3: Database Infrastructure

### Step 3.1: Setup Infrastructure Repository

Navigate to infrastructure repo:

```bash
cd commited-infrastructure
```

Create directory structure:

```bash
mkdir -p docker-compose
mkdir -p database/init-scripts
mkdir -p database/migrations
mkdir -p kubernetes
mkdir -p monitoring
mkdir -p scripts
mkdir -p configs
```

### Step 3.2: Create Docker Compose for Database

Create `docker-compose/database.yml`:

```yaml
version: '3.8'

services:
  oracle-db:
    image: container-registry.oracle.com/database/express:21.3.0-xe
    container_name: commited-oracle-db
    hostname: oracle-db
    environment:
      - ORACLE_PWD=CommitedDB2024!
      - ORACLE_CHARACTERSET=AL32UTF8
    ports:
      - "1521:1521"
      - "5500:5500"
    volumes:
      - oracle-data:/opt/oracle/oradata
      - ./database/init-scripts:/docker-entrypoint-initdb.d/startup
    healthcheck:
      test: ["CMD", "healthcheck.sh"]
      interval: 30s
      timeout: 10s
      retries: 5
    networks:
      - commited-network

  redis:
    image: redis:7-alpine
    container_name: commited-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    command: redis-server --appendonly yes
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3
    networks:
      - commited-network

  rabbitmq:
    image: rabbitmq:3.12-management-alpine
    container_name: commited-rabbitmq
    environment:
      - RABBITMQ_DEFAULT_USER=commited
      - RABBITMQ_DEFAULT_PASS=CommitedMQ2024!
    ports:
      - "5672:5672"
      - "15672:15672"
    volumes:
      - rabbitmq-data:/var/lib/rabbitmq
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "ping"]
      interval: 30s
      timeout: 10s
      retries: 5
    networks:
      - commited-network

volumes:
  oracle-data:
    driver: local
  redis-data:
    driver: local
  rabbitmq-data:
    driver: local

networks:
  commited-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.28.0.0/16
```

### Step 3.3: Create Database Initialization Scripts

> **Note:** Database schema design is still in progress. SQL scripts will be added once the design is finalized. For now, we'll create placeholder directories for future scripts.

Create the directory structure:

```bash
# Create directories for future SQL scripts
mkdir -p database/init-scripts
mkdir -p database/migrations/{auth,courses,assignments,submissions,analytics,notifications}

# Create a README to document the schema design process
cat > database/README.md << 'EOF'
# Database Schema Design

## Status: IN PROGRESS

This directory will contain:

1. **init-scripts/**: Initial database setup scripts
   - Schema creation for each microservice
   - User/role setup
   - Cross-schema grants

2. **migrations/**: Service-specific migration scripts
   - Organized by service
   - Version-controlled schema changes

## Schema-per-Service Pattern

Each microservice will have its own Oracle schema:

- `commited_auth` - Auth Service
- `commited_courses` - Course Service  
- `commited_assignments` - Assignment Service
- `commited_submissions` - Submission Service
- `commited_analytics` - Analytics Service
- `commited_notifications` - Notification Service

## Next Steps

1. Finalize entity relationship diagrams
2. Define table structures for each service
3. Create initial migration scripts
4. Setup cross-schema relationships
5. Document access patterns

EOF

# Create placeholder for schema creation
cat > database/init-scripts/00_placeholder.sql << 'EOF'
-- Placeholder file
-- Actual schema creation scripts will be added here once design is finalized

-- Expected scripts:
-- 01_create_schemas.sql
-- 02_create_tables_auth.sql
-- 03_create_tables_courses.sql
-- 04_create_tables_assignments.sql  
-- 05_create_tables_submissions.sql
-- 06_create_tables_analytics.sql
-- 07_create_tables_notifications.sql

SELECT 'Database schema design in progress' AS status FROM dual;
EXIT;
EOF
```

For now, we'll configure Oracle DB to start without initialization scripts
# 📚 Pahana Edu — Online Billing System

> A production-ready, Java OOP web application (MVC) for bookstore billing & inventory management.  
>  
> Deployed on **Apache Tomcat 9**. RESTful APIs expose business functions for distributed clients.

[![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=openjdk)](https://adoptium.net/)
[![Tomcat](https://img.shields.io/badge/Tomcat-9.0-yellow?style=for-the-badge&logo=apachetomcat)](https://tomcat.apache.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Build Status](https://img.shields.io/github/actions/workflow/status/yourusername/PahanaEdu/ci.yml?branch=main&style=for-the-badge)](https://github.com/yourusername/PahanaEdu/actions)

---

## 🚀 Quick Demo (Animated)
> Replace these placeholders with real GIFs (record dashboards using LICEcap / ScreenToGif / OBS and add to `/docs/gifs/`)

![Dashboard animation (placeholder)](docs/gifs/dashboard-demo.gif)
![Billing flow (placeholder)](docs/gifs/billing-flow.gif)

> Tip: For lightweight, smooth animation use **Lottie** (export from After Effects with Bodymovin) and host `.json` in `docs/animations/`. Use on website / GitHub Pages — GitHub READMEs can show GIFs/SVGs; Lottie needs a webpage wrapper.

---

## 📌 Table of Contents
- [About](#about)  
- [Architecture](#architecture)  
- [Highlights & Features](#highlights--features)  
- [Getting Started](#getting-started)  
  - [Prerequisites](#prerequisites)  
  - [Local Setup (Docker)](#local-setup-docker)  
- [API Endpoints](#api-endpoints)  
- [Database Schema](#database-schema)  
- [Testing & Quality](#testing--quality)  
- [CI / CD](#ci--cd)  
- [Security & Production Notes](#security--production-notes)  
- [Performance & Monitoring](#performance--monitoring)  
- [Roadmap / Enhancements](#roadmap--enhancements)  
- [Contributing](#contributing)  
- [License](#license)

---

## 📘 About
**Pahana Edu** is a modular, extensible billing system built with:
- Java (Servlets + JSP), JDBC (HikariCP pool)
- MVC pattern, DAO layer, Factory & Singleton patterns
- RESTful APIs for distributed clients
- MySQL / PostgreSQL support

Designed for production use in educational bookstores — multi-role dashboards (Admin, Cashier, StoreKeeper), inventory control, billing, supplier mapping, and reporting.

---

## 🏗 Architecture (3-Tier + Patterns)




**Layers**
1. **Presentation (Client)** — JSP + Bootstrap: role-based dashboards, client-side validation & animations.
2. **Application (Tomcat)** — Servlets (controllers), Services (business logic), REST endpoints, DAO layer for persistence.
3. **Data (DB)** — MySQL/Postgres accessed via JDBC + HikariCP.

**Design patterns**: MVC, DAO, Factory, Singleton, Service Layer.

---

## ✨ Highlights & Features
- ✅ Role-based dashboards (Admin, Cashier, StoreKeeper)  
- ✅ Billing with line items, discounts, and history  
- ✅ Inventory: stock counts, low-stock alerts, supplier mapping  
- ✅ REST APIs (JSON) for external clients  
- ✅ Dark/Light UI toggle + animated counters and card hover effects  
- ✅ Connection pooling (HikariCP) + centralized DAOFactory  
- ✅ Sample SQL seed data & migration scripts

---

## 🛠 Getting Started

### Prerequisites
- Java 17+ (OpenJDK/Adoptium)  
- Apache Tomcat 9.x  
- MySQL 8+ (or PostgreSQL)  
- Maven 3.6+  
- (Optional) Docker & Docker Compose

### Local setup — Docker (recommended)
1. Copy `.env.example` → `.env` and configure DB credentials.
2. Start DB:
    ```bash
    docker-compose up -d
    ```
3. Build & deploy the app:
    ```bash
    mvn clean package
    cp target/PahanaEdu.war /path/to/tomcat/webapps/
    ```

4. Access at [http://localhost:8080/PahanaEdu](http://localhost:8080/PahanaEdu)

---

## 🔗 API Endpoints

| Method | Endpoint                | Description                |
|--------|------------------------|----------------------------|
| GET    | `/api/books`           | List all books             |
| POST   | `/api/bill`            | Create a new bill          |
| GET    | `/api/inventory`       | Inventory status           |
| ...    | ...                    | ...                        |

See [API Docs](docs/api.md) for full details.

---

## 🗄 Database Schema

![ER Diagram](docs/architecture/er-diagram.png)

- **Users**: id, username, password, role
- **Books**: id, title, author, price, stock
- **Bills**: id, user_id, date, total
- **Bill_Items**: id, bill_id, book_id, qty, price
- **Suppliers**: id, name, contact

Migration scripts: [`/db/migrations/`](db/migrations/)

---

## 🧪 Testing & Quality

- JUnit & Mockito for unit/integration tests
- REST API tests with Postman/newman
- Code style: Google Java Format
- CI: GitHub Actions (build, test, lint)

---

## 🚦 CI / CD

- Automated build & test on push (GitHub Actions)
- Docker image build & push (optional)
- Deploy to Tomcat via SCP or CI/CD pipeline

---

## 🔒 Security & Production Notes

- Passwords hashed (BCrypt)
- Input validation (server & client)
- HTTPS recommended for deployment
- Environment variables for secrets

---

## 📈 Performance & Monitoring

- Connection pooling (HikariCP)
- SQL query optimization
- Logging: SLF4J + Logback
- Monitoring: Prometheus/JMX (optional)

---

## 🛣 Roadmap / Enhancements

- [ ] OAuth2 SSO integration
- [ ] PDF invoice export
- [ ] Mobile-friendly UI
- [ ] Supplier portal

---

## 🤝 Contributing

1. Fork & clone the repo
2. Create a feature branch
3. Commit & push changes
4. Open a Pull Request



---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

> _Crafted with ❤️ by the Dinitha Thewmika to Pahana Edu team. For questions, open an issue or contact [maintainer@example.com](mailto:dinithabc2001@gmail.com)._

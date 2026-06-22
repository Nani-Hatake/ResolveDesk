# ResolveDesk

Enterprise IT Helpdesk & Ticket Management System built with React, ASP.NET Core, and SQL Server.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | React 18 + Vite |
| Backend | C# ASP.NET Core 10 Web API |
| Database | SQL Server Express (raw ADO.NET) |
| Styling | Plain CSS |

---

## Project Structure

```
ResolveDesk/
├── schema.sql                        # Database DDL — run this first
│
├── Backend/
│   ├── ResolveDesk.csproj
│   ├── Program.cs                    # App setup, CORS, controller mapping
│   ├── appsettings.json              # Connection string config
│   ├── Models/
│   │   └── Models.cs                 # User, Ticket, Comment POCOs + request models
│   └── Controllers/
│       ├── TicketsController.cs      # GET all, GET by id, POST create, PATCH update
│       ├── CommentsController.cs     # GET comments by ticket, POST new comment
│       └── UsersController.cs        # GET users (filterable by role)
│
└── Frontend/
    ├── index.html
    ├── vite.config.js
    ├── package.json
    └── src/
        ├── index.jsx                 # React entry point
        ├── index.css                 # Global styles
        ├── App.jsx                   # Root component, view routing
        └── components/
            ├── TicketList.jsx        # Dashboard table of all tickets
            ├── TicketDetail.jsx      # Single ticket view with controls + comments
            └── CreateTicket.jsx      # New ticket submission form
```

---

## Getting Started

### Prerequisites

- [.NET 10 SDK](https://dotnet.microsoft.com/download)
- [Node.js 18+](https://nodejs.org/)
- SQL Server Express (or any SQL Server instance)

### 1. Database Setup

Open SQL Server Management Studio (or `sqlcmd`) and run the schema file:

```bash
sqlcmd -S localhost\SQLEXPRESS -C -i schema.sql
```

This creates the `ResolveDesk` database with `users`, `tickets`, and `comments` tables, and inserts three seed users.

### 2. Backend

Update the connection string in [Backend/appsettings.json](Backend/appsettings.json) to match your SQL Server instance:

```json
"DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=ResolveDesk;Trusted_Connection=True;TrustServerCertificate=True;"
```

Then start the API (runs on `http://localhost:5000`):

```bash
cd Backend
dotnet run --urls http://localhost:5000
```

### 3. Frontend

```bash
cd Frontend
npm install
npm run dev
```

Vite starts at `http://localhost:3000`.

---

## Seed Data

The schema inserts three users to get you started immediately:

| Name | Email | Role |
|---|---|---|
| Admin User | admin@resolvedesk.com | admin |
| IT Agent One | agent@resolvedesk.com | agent |
| Jane Employee | jane@resolvedesk.com | employee |

> Passwords in the seed data are placeholder hashes. A real auth implementation would use BCrypt to hash passwords on registration.

---

## API Reference

Base URL: `http://localhost:5000`

### Tickets

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/tickets` | Fetch all tickets (with creator and assignee names) |
| `GET` | `/api/tickets/:id` | Fetch a single ticket by ID |
| `POST` | `/api/tickets` | Create a new ticket |
| `PATCH` | `/api/tickets/:id` | Update status and/or assigned agent |

**POST /api/tickets — Request body:**
```json
{
  "title": "VPN not connecting",
  "description": "Remote access fails with error 691.",
  "priority": "high",
  "category": "Network",
  "createdBy": 3
}
```

**PATCH /api/tickets/:id — Request body (all fields optional):**
```json
{
  "status": "in_progress",
  "assignedTo": 2
}
```

### Comments

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/tickets/:id/comments` | Fetch all comments for a ticket |
| `POST` | `/api/tickets/:id/comments` | Add a comment to a ticket |

**POST /api/tickets/:id/comments — Request body:**
```json
{
  "authorId": 2,
  "body": "Investigating the VPN config now."
}
```

### Users

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/users` | Fetch all users |
| `GET` | `/api/users?role=agent` | Fetch users filtered by role |

---

## Ticket Fields

| Field | Values |
|---|---|
| `status` | `open` · `in_progress` · `resolved` · `closed` |
| `priority` | `low` · `medium` · `high` · `critical` |
| `role` | `employee` · `agent` · `admin` |

---

## Features

- **Ticket Dashboard** — sortable table listing all tickets with priority and status badges
- **Ticket Detail View** — full ticket information with inline status and assignment controls
- **Live Comment Timeline** — threaded comments appended to the UI instantly on submit
- **Create Ticket Form** — controlled React form with category and priority dropdowns
- **CORS Configured** — backend accepts requests from `http://localhost:3000`

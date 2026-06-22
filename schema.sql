CREATE DATABASE ResolveDesk;
GO

USE ResolveDesk;
GO

CREATE TABLE users (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    full_name     NVARCHAR(100)  NOT NULL,
    email         NVARCHAR(150)  NOT NULL UNIQUE,
    password_hash NVARCHAR(255)  NOT NULL,
    role          NVARCHAR(20)   NOT NULL DEFAULT 'employee',
    created_at    DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT chk_user_role CHECK (role IN ('employee', 'agent', 'admin'))
);

CREATE TABLE tickets (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    title       NVARCHAR(200)  NOT NULL,
    description NVARCHAR(MAX)  NOT NULL,
    priority    NVARCHAR(20)   NOT NULL DEFAULT 'medium',
    category    NVARCHAR(50)   NOT NULL,
    status      NVARCHAR(20)   NOT NULL DEFAULT 'open',
    created_by  INT            NOT NULL,
    assigned_to INT            NULL,
    created_at  DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    updated_at  DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT fk_ticket_creator  FOREIGN KEY (created_by)  REFERENCES users(id),
    CONSTRAINT fk_ticket_assignee FOREIGN KEY (assigned_to) REFERENCES users(id),
    CONSTRAINT chk_priority CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    CONSTRAINT chk_status   CHECK (status   IN ('open', 'in_progress', 'resolved', 'closed'))
);

CREATE TABLE comments (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    ticket_id  INT           NOT NULL,
    author_id  INT           NOT NULL,
    body       NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT fk_comment_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_author FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE INDEX idx_tickets_created_by  ON tickets(created_by);
CREATE INDEX idx_tickets_assigned_to ON tickets(assigned_to);
CREATE INDEX idx_comments_ticket_id  ON comments(ticket_id);

INSERT INTO users (full_name, email, password_hash, role) VALUES
('Admin User',   'admin@resolvedesk.com', '$2a$11$placeholder_hash_admin', 'admin'),
('IT Agent One', 'agent@resolvedesk.com', '$2a$11$placeholder_hash_agent', 'agent'),
('Jane Employee','jane@resolvedesk.com',  '$2a$11$placeholder_hash_jane',  'employee');

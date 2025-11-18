# BookNest Backend API

Backend REST API for BookNest - Personal Library Management Platform

## Overview

BookNest Backend provides a comprehensive REST API for managing personal book libraries, reading tracking, and reading statistics. Built with Node.js, Express, TypeScript, and SQL Server.

## Features

- RESTful API architecture with versioning support
- Multi-tenancy with account-based data isolation
- Automatic database migrations on startup
- Comprehensive error handling and validation
- Type-safe development with TypeScript
- Production-ready configuration

## Technology Stack

- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: Microsoft SQL Server
- **Validation**: Zod
- **Testing**: Jest

## Getting Started

### Prerequisites

- Node.js 18.0.0 or higher
- npm 9.0.0 or higher
- SQL Server instance

### Installation

1. Install dependencies:
```bash
npm install
```

2. Configure environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

3. Start development server:
```bash
npm run dev
```

### Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build production bundle
- `npm start` - Start production server
- `npm test` - Run test suite
- `npm run lint` - Run ESLint
- `npm run lint:fix` - Fix ESLint issues

## Project Structure

```
backend/
├── migrations/          # Database migration files
├── src/
│   ├── api/            # API controllers
│   ├── routes/         # Route definitions
│   ├── services/       # Business logic
│   ├── middleware/     # Express middleware
│   ├── utils/          # Utility functions
│   ├── constants/      # Application constants
│   ├── instances/      # Service instances
│   ├── migrations/     # Migration runner code
│   └── server.ts       # Application entry point
├── package.json
├── tsconfig.json
└── README.md
```

## API Documentation

### Base URL

- Development: `http://localhost:3000/api/v1`
- Production: `https://api.yourdomain.com/api/v1`

### Health Check

```
GET /health
```

Returns server health status.

## Database Migrations

The application automatically runs database migrations on startup. Migrations are located in the `migrations/` directory and are executed in a schema-isolated manner to support multi-tenancy.

### Migration Configuration

- Migrations run automatically unless `SKIP_MIGRATIONS=true`
- Schema isolation based on `PROJECT_ID` environment variable
- Idempotent migrations with checksum-based execution

## Environment Variables

### Required Variables

- `DB_SERVER` - Database server address
- `DB_NAME` - Database name
- `DB_USER` - Database username
- `DB_PASSWORD` - Database password
- `PROJECT_ID` - Project identifier for schema isolation

### Optional Variables

- `NODE_ENV` - Environment (development/production)
- `PORT` - Server port (default: 3000)
- `DB_PORT` - Database port (default: 1433)
- `DB_ENCRYPT` - Enable encryption (default: true)
- `SKIP_MIGRATIONS` - Skip migrations (default: false)

## Development Guidelines

### Code Style

- Follow TypeScript strict mode
- Use ESLint for code quality
- 2-space indentation
- Single quotes for strings
- Semicolons required

### Testing

- Write unit tests for services
- Write integration tests for API endpoints
- Maintain test coverage above 80%

## Deployment

### Production Build

```bash
npm run build
```

### Start Production Server

```bash
npm start
```

## License

MIT

## Support

For issues and questions, please open an issue in the project repository.
/**
 * @summary
 * BookNest Backend API Server
 * Main application entry point with database migration support
 *
 * @module server
 */

import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import { config } from '@/config';
import { errorMiddleware } from '@/middleware/error';
import { notFoundMiddleware } from '@/middleware/notFound';
import apiRoutes from '@/routes';
import { runDatabaseMigrations } from './migrations/migration-runner';

const app: Application = express();

app.use(helmet());
app.use(cors(config.api.cors));
app.use(compression());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(morgan('combined'));

app.get('/health', (req: Request, res: Response) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'BookNest API',
    version: config.api.version,
  });
});

app.use('/api', apiRoutes);

app.use(notFoundMiddleware);
app.use(errorMiddleware);

let server: any;

async function startApplication() {
  try {
    console.log('\n========================================');
    console.log('BOOKNEST API SERVER');
    console.log('========================================\n');

    console.log('Checking database migrations...');
    await runDatabaseMigrations({
      skipIfNoNewMigrations: true,
      logLevel: 'minimal',
    });
    console.log('✓ Database ready\n');

    server = app.listen(config.api.port, () => {
      console.log('========================================');
      console.log(`✓ Server running on port ${config.api.port}`);
      console.log(`✓ Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(
        `✓ API available at http://localhost:${config.api.port}/api/${config.api.version}`
      );
      console.log('========================================\n');
    });
  } catch (error: any) {
    console.error('\n========================================');
    console.error('✗ FAILED TO START APPLICATION');
    console.error('========================================');
    console.error(`Error: ${error.message}\n`);
    process.exit(1);
  }
}

process.on('SIGTERM', () => {
  console.log('\nSIGTERM received, closing server gracefully');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

startApplication();

export default server;

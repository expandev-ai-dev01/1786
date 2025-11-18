/**
 * @summary
 * Database connection pool management
 * Provides singleton database connection pool
 *
 * @module instances/database
 */

import sql from 'mssql';
import { config } from '@/config';

let pool: sql.ConnectionPool | null = null;

export async function getPool(): Promise<sql.ConnectionPool> {
  if (!pool) {
    pool = await sql.connect({
      server: config.database.server,
      port: config.database.port,
      database: config.database.database,
      user: config.database.user,
      password: config.database.password,
      options: {
        encrypt: config.database.encrypt,
        trustServerCertificate: config.database.options.trustServerCertificate,
        enableArithAbort: config.database.options.enableArithAbort,
      },
    });
  }
  return pool;
}

export async function closePool(): Promise<void> {
  if (pool) {
    await pool.close();
    pool = null;
  }
}

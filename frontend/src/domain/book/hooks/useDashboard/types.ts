import type { DashboardStats } from '../../types';

export interface UseDashboardReturn {
  stats: DashboardStats | undefined;
  isLoading: boolean;
  error: Error | null;
  refetch: () => void;
}

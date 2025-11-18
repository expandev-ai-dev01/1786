import { useQuery } from '@tanstack/react-query';
import { dashboardService } from '../../services/dashboardService';
import type { UseDashboardReturn } from './types';

export const useDashboard = (): UseDashboardReturn => {
  const { data, isLoading, error, refetch } = useQuery({
    queryKey: ['dashboard', 'stats'],
    queryFn: dashboardService.getStats,
  });

  return {
    stats: data,
    isLoading,
    error: error as Error | null,
    refetch,
  };
};

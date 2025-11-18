import { authenticatedClient } from '@/core/lib/api';
import type {
  DashboardStats,
  AnnualGoal,
  CreateAnnualGoalDto,
  UpdateAnnualGoalDto,
  ReadingInsight,
} from '../types';

export const dashboardService = {
  async getStats(): Promise<DashboardStats> {
    const response = await authenticatedClient.get('/dashboard/stats');
    return response.data.data;
  },

  async getCurrentYearGoal(): Promise<AnnualGoal | null> {
    try {
      const response = await authenticatedClient.get('/dashboard/goal');
      return response.data.data;
    } catch (error: unknown) {
      if (typeof error === 'object' && error !== null && 'response' in error) {
        const axiosError = error as { response: { status: number } };
        if (axiosError.response?.status === 404) {
          return null;
        }
      }
      throw error;
    }
  },

  async createGoal(data: CreateAnnualGoalDto): Promise<AnnualGoal> {
    const response = await authenticatedClient.post('/dashboard/goal', data);
    return response.data.data;
  },

  async updateGoal(data: UpdateAnnualGoalDto): Promise<AnnualGoal> {
    const response = await authenticatedClient.put('/dashboard/goal', data);
    return response.data.data;
  },

  async getInsights(): Promise<ReadingInsight[]> {
    const response = await authenticatedClient.get('/dashboard/insights');
    return response.data.data;
  },
};

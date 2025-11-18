import { authenticatedClient } from '@/core/lib/api';
import type { ReadingProgress, UpdateProgressDto } from '../types';

export const progressService = {
  async getByBookId(bookId: string): Promise<ReadingProgress | null> {
    try {
      const response = await authenticatedClient.get(`/books/${bookId}/progress`);
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

  async update(bookId: string, data: UpdateProgressDto): Promise<ReadingProgress> {
    const response = await authenticatedClient.put(`/books/${bookId}/progress`, data);
    return response.data.data;
  },
};

import { authenticatedClient } from '@/core/lib/api';
import type { BookReview, CreateReviewDto, UpdateReviewDto } from '../types';

export const reviewService = {
  async getByBookId(bookId: string): Promise<BookReview | null> {
    try {
      const response = await authenticatedClient.get(`/books/${bookId}/review`);
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

  async create(bookId: string, data: CreateReviewDto): Promise<BookReview> {
    const response = await authenticatedClient.post(`/books/${bookId}/review`, data);
    return response.data.data;
  },

  async update(bookId: string, data: UpdateReviewDto): Promise<BookReview> {
    const response = await authenticatedClient.put(`/books/${bookId}/review`, data);
    return response.data.data;
  },

  async delete(bookId: string): Promise<void> {
    await authenticatedClient.delete(`/books/${bookId}/review`);
  },
};

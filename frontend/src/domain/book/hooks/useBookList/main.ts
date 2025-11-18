import { useQuery } from '@tanstack/react-query';
import { bookService } from '../../services/bookService';
import type { UseBookListOptions, UseBookListReturn } from './types';

export const useBookList = (options: UseBookListOptions = {}): UseBookListReturn => {
  const { filters, enabled = true } = options;

  const { data, isLoading, error, refetch } = useQuery({
    queryKey: ['books', filters],
    queryFn: () => bookService.list(filters),
    enabled,
  });

  return {
    books: data,
    isLoading,
    error: error as Error | null,
    refetch,
  };
};

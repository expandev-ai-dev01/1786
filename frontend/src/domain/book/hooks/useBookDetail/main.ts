import { useQuery } from '@tanstack/react-query';
import { bookService } from '../../services/bookService';
import type { UseBookDetailOptions, UseBookDetailReturn } from './types';

export const useBookDetail = (options: UseBookDetailOptions): UseBookDetailReturn => {
  const { bookId, enabled = true } = options;

  const { data, isLoading, error, refetch } = useQuery({
    queryKey: ['book', bookId],
    queryFn: () => bookService.getById(bookId),
    enabled: enabled && !!bookId,
  });

  return {
    book: data,
    isLoading,
    error: error as Error | null,
    refetch,
  };
};

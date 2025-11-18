import type { Book, BookListParams } from '../../types';

export interface UseBookListOptions {
  filters?: BookListParams;
  enabled?: boolean;
}

export interface UseBookListReturn {
  books: Book[] | undefined;
  isLoading: boolean;
  error: Error | null;
  refetch: () => void;
}

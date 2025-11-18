import type { Book } from '../../types';

export interface UseBookDetailOptions {
  bookId: string;
  enabled?: boolean;
}

export interface UseBookDetailReturn {
  book: Book | undefined;
  isLoading: boolean;
  error: Error | null;
  refetch: () => void;
}

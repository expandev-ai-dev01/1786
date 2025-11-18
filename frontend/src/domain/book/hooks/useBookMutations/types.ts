import type { Book, CreateBookDto, UpdateBookDto } from '../../types';

export interface UseBookMutationsReturn {
  createBook: (data: CreateBookDto) => Promise<Book>;
  updateBook: (id: string, data: UpdateBookDto) => Promise<Book>;
  deleteBook: (id: string) => Promise<void>;
  moveToShelf: (id: string, shelf: 'Lido' | 'Lendo' | 'Quero Ler') => Promise<Book>;
  isCreating: boolean;
  isUpdating: boolean;
  isDeleting: boolean;
  isMoving: boolean;
}

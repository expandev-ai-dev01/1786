import type { Book } from '../../types';

export interface BookCardProps {
  book: Book;
  onEdit?: (book: Book) => void;
  onDelete?: (bookId: string) => void;
  onMoveToShelf?: (bookId: string, shelf: 'Lido' | 'Lendo' | 'Quero Ler') => void;
  onViewDetails?: (bookId: string) => void;
}

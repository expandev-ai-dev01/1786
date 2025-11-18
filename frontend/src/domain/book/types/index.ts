export interface Book {
  id: string;
  userId: string;
  title: string;
  author: string;
  yearPublished?: number;
  genre?: string;
  coverUrl?: string;
  shelf: 'Lido' | 'Lendo' | 'Quero Ler';
  totalPages?: number;
  dateAdded: string;
  isbn?: string;
}

export interface BookReview {
  id: string;
  bookId: string;
  userId: string;
  rating: number;
  review?: string;
  dateReviewed: string;
  dateUpdated?: string;
}

export interface ReadingProgress {
  id: string;
  bookId: string;
  userId: string;
  pagesRead: number;
  percentComplete: number;
  dateStarted: string;
  dateLastUpdated: string;
  dateCompleted?: string;
}

export interface AnnualGoal {
  id: string;
  userId: string;
  year: number;
  targetBooks: number;
  booksRead: number;
  percentComplete: number;
}

export interface ReadingInsight {
  id: string;
  userId: string;
  type:
    | 'Ritmo de Leitura'
    | 'Gênero Favorito'
    | 'Autor Favorito'
    | 'Período Mais Produtivo'
    | 'Comparativo Anual';
  description: string;
  dateGenerated: string;
  relatedData?: Record<string, unknown>;
}

export interface BookListParams {
  shelf?: 'Lido' | 'Lendo' | 'Quero Ler';
  genre?: string;
  search?: string;
  sortBy?: 'title' | 'author' | 'dateAdded' | 'rating';
  sortOrder?: 'asc' | 'desc';
}

export interface CreateBookDto {
  title: string;
  author: string;
  yearPublished?: number;
  genre?: string;
  coverUrl?: string;
  shelf: 'Lido' | 'Lendo' | 'Quero Ler';
  totalPages?: number;
  isbn?: string;
}

export interface UpdateBookDto {
  title?: string;
  author?: string;
  yearPublished?: number;
  genre?: string;
  coverUrl?: string;
  shelf?: 'Lido' | 'Lendo' | 'Quero Ler';
  totalPages?: number;
  isbn?: string;
}

export interface CreateReviewDto {
  rating: number;
  review?: string;
}

export interface UpdateReviewDto {
  rating?: number;
  review?: string;
}

export interface UpdateProgressDto {
  pagesRead: number;
}

export interface CreateAnnualGoalDto {
  targetBooks: number;
}

export interface UpdateAnnualGoalDto {
  targetBooks: number;
}

export interface DashboardStats {
  totalBooks: number;
  booksRead: number;
  booksReading: number;
  booksWantToRead: number;
  totalPagesRead: number;
  averageRating: number;
  currentYearGoal?: AnnualGoal;
  booksByMonth: Array<{ month: string; count: number }>;
  genreDistribution: Array<{ genre: string; count: number }>;
  recentBooks: Book[];
}

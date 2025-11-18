import { authenticatedClient } from '@/core/lib/api';
import type { Book, BookListParams, CreateBookDto, UpdateBookDto } from '../types';

export const bookService = {
  async list(params?: BookListParams): Promise<Book[]> {
    const response = await authenticatedClient.get('/books', { params });
    return response.data.data;
  },

  async getById(id: string): Promise<Book> {
    const response = await authenticatedClient.get(`/books/${id}`);
    return response.data.data;
  },

  async create(data: CreateBookDto): Promise<Book> {
    const response = await authenticatedClient.post('/books', data);
    return response.data.data;
  },

  async update(id: string, data: UpdateBookDto): Promise<Book> {
    const response = await authenticatedClient.put(`/books/${id}`, data);
    return response.data.data;
  },

  async delete(id: string): Promise<void> {
    await authenticatedClient.delete(`/books/${id}`);
  },

  async moveToShelf(id: string, shelf: 'Lido' | 'Lendo' | 'Quero Ler'): Promise<Book> {
    const response = await authenticatedClient.patch(`/books/${id}/shelf`, { shelf });
    return response.data.data;
  },
};

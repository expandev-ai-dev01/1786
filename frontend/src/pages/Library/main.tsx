import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useBookList } from '@/domain/book/hooks/useBookList';
import { useBookMutations } from '@/domain/book/hooks/useBookMutations';
import { BookCard } from '@/domain/book/components/BookCard';
import { BookForm } from '@/domain/book/components/BookForm';
import { LoadingSpinner } from '@/core/components/LoadingSpinner';
import type { Book } from '@/domain/book/types';

export const LibraryPage = () => {
  const navigate = useNavigate();
  const [selectedShelf, setSelectedShelf] = useState<'Lido' | 'Lendo' | 'Quero Ler' | 'all'>('all');
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingBook, setEditingBook] = useState<Book | null>(null);
  const [searchTerm, setSearchTerm] = useState('');

  const { books, isLoading, refetch } = useBookList({
    filters: selectedShelf !== 'all' ? { shelf: selectedShelf } : undefined,
  });

  const { createBook, updateBook, deleteBook, moveToShelf, isCreating, isUpdating } =
    useBookMutations();

  const handleAddBook = async (data: any) => {
    try {
      await createBook(data);
      setShowAddForm(false);
      refetch();
    } catch (error: unknown) {
      console.error('Erro ao adicionar livro:', error);
    }
  };

  const handleUpdateBook = async (data: any) => {
    if (!editingBook) return;
    try {
      await updateBook(editingBook.id, data);
      setEditingBook(null);
      refetch();
    } catch (error: unknown) {
      console.error('Erro ao atualizar livro:', error);
    }
  };

  const handleDeleteBook = async (bookId: string) => {
    if (!confirm('Tem certeza que deseja remover este livro?')) return;
    try {
      await deleteBook(bookId);
      refetch();
    } catch (error: unknown) {
      console.error('Erro ao remover livro:', error);
    }
  };

  const handleMoveToShelf = async (bookId: string, shelf: 'Lido' | 'Lendo' | 'Quero Ler') => {
    try {
      await moveToShelf(bookId, shelf);
      refetch();
    } catch (error: unknown) {
      console.error('Erro ao mover livro:', error);
    }
  };

  const filteredBooks = books?.filter(
    (book) =>
      book.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      book.author.toLowerCase().includes(searchTerm.toLowerCase())
  );

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Minha Biblioteca</h1>
          <div className="flex gap-4">
            <button
              onClick={() => navigate('/dashboard')}
              className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors"
            >
              Dashboard
            </button>
            <button
              onClick={() => setShowAddForm(true)}
              className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Adicionar Livro
            </button>
          </div>
        </div>

        <div className="mb-6 flex flex-col sm:flex-row gap-4">
          <input
            type="text"
            placeholder="Buscar por título ou autor..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <div className="flex gap-2">
            <button
              onClick={() => setSelectedShelf('all')}
              className={`px-4 py-2 rounded-lg transition-colors ${
                selectedShelf === 'all'
                  ? 'bg-blue-600 text-white'
                  : 'bg-white text-gray-700 hover:bg-gray-100'
              }`}
            >
              Todos
            </button>
            <button
              onClick={() => setSelectedShelf('Quero Ler')}
              className={`px-4 py-2 rounded-lg transition-colors ${
                selectedShelf === 'Quero Ler'
                  ? 'bg-purple-600 text-white'
                  : 'bg-white text-gray-700 hover:bg-gray-100'
              }`}
            >
              Quero Ler
            </button>
            <button
              onClick={() => setSelectedShelf('Lendo')}
              className={`px-4 py-2 rounded-lg transition-colors ${
                selectedShelf === 'Lendo'
                  ? 'bg-blue-600 text-white'
                  : 'bg-white text-gray-700 hover:bg-gray-100'
              }`}
            >
              Lendo
            </button>
            <button
              onClick={() => setSelectedShelf('Lido')}
              className={`px-4 py-2 rounded-lg transition-colors ${
                selectedShelf === 'Lido'
                  ? 'bg-green-600 text-white'
                  : 'bg-white text-gray-700 hover:bg-gray-100'
              }`}
            >
              Lido
            </button>
          </div>
        </div>

        {(showAddForm || editingBook) && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-lg p-6 max-w-2xl w-full max-h-[90vh] overflow-y-auto">
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                {editingBook ? 'Editar Livro' : 'Adicionar Novo Livro'}
              </h2>
              <BookForm
                initialData={editingBook || undefined}
                onSubmit={editingBook ? handleUpdateBook : handleAddBook}
                onCancel={() => {
                  setShowAddForm(false);
                  setEditingBook(null);
                }}
                isSubmitting={isCreating || isUpdating}
              />
            </div>
          </div>
        )}

        {filteredBooks && filteredBooks.length > 0 ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-6">
            {filteredBooks.map((book) => (
              <BookCard
                key={book.id}
                book={book}
                onEdit={setEditingBook}
                onDelete={handleDeleteBook}
                onMoveToShelf={handleMoveToShelf}
                onViewDetails={(id) => navigate(`/book/${id}`)}
              />
            ))}
          </div>
        ) : (
          <div className="text-center py-12">
            <p className="text-gray-500 text-lg">Nenhum livro encontrado</p>
            <button
              onClick={() => setShowAddForm(true)}
              className="mt-4 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Adicionar Primeiro Livro
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default LibraryPage;

import { getBookCardClassName } from './variants';
import type { BookCardProps } from './types';

export const BookCard = (props: BookCardProps) => {
  const { book, onEdit, onDelete, onMoveToShelf, onViewDetails } = props;

  return (
    <div className={getBookCardClassName({})}>
      <div className="aspect-[2/3] bg-gray-200 relative">
        {book.coverUrl ? (
          <img src={book.coverUrl} alt={book.title} className="w-full h-full object-cover" />
        ) : (
          <div className="flex items-center justify-center h-full text-gray-400">
            <span className="text-4xl">📚</span>
          </div>
        )}
        <div className="absolute top-2 right-2">
          <span className="px-2 py-1 text-xs font-semibold rounded-full bg-blue-600 text-white">
            {book.shelf}
          </span>
        </div>
      </div>
      <div className="p-4">
        <h3 className="font-bold text-lg text-gray-900 mb-1 line-clamp-2">{book.title}</h3>
        <p className="text-sm text-gray-600 mb-2">{book.author}</p>
        {book.yearPublished && <p className="text-xs text-gray-500 mb-2">{book.yearPublished}</p>}
        {book.genre && (
          <span className="inline-block px-2 py-1 text-xs bg-gray-100 text-gray-700 rounded">
            {book.genre}
          </span>
        )}
        <div className="mt-4 flex gap-2">
          {onViewDetails && (
            <button
              onClick={() => onViewDetails(book.id)}
              className="flex-1 px-3 py-2 text-sm bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors"
            >
              Ver Detalhes
            </button>
          )}
          {onEdit && (
            <button
              onClick={() => onEdit(book)}
              className="px-3 py-2 text-sm bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition-colors"
            >
              Editar
            </button>
          )}
        </div>
        {onMoveToShelf && (
          <div className="mt-2">
            <select
              value={book.shelf}
              onChange={(e) => onMoveToShelf(book.id, e.target.value as any)}
              className="w-full px-2 py-1 text-sm border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="Quero Ler">Quero Ler</option>
              <option value="Lendo">Lendo</option>
              <option value="Lido">Lido</option>
            </select>
          </div>
        )}
        {onDelete && (
          <button
            onClick={() => onDelete(book.id)}
            className="mt-2 w-full px-3 py-2 text-sm bg-red-600 text-white rounded hover:bg-red-700 transition-colors"
          >
            Remover
          </button>
        )}
      </div>
    </div>
  );
};

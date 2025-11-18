import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import type { BookFormProps } from './types';

const bookSchema = z.object({
  title: z.string().min(1, 'Título é obrigatório').max(200, 'Título muito longo'),
  author: z.string().min(1, 'Autor é obrigatório').max(100, 'Nome do autor muito longo'),
  yearPublished: z.number().min(0).max(new Date().getFullYear()).optional().or(z.literal('')),
  genre: z.string().max(50).optional(),
  coverUrl: z.string().url('URL inválida').optional().or(z.literal('')),
  shelf: z.enum(['Lido', 'Lendo', 'Quero Ler']),
  totalPages: z.number().min(1).optional().or(z.literal('')),
  isbn: z.string().optional(),
});

type BookFormData = z.infer<typeof bookSchema>;

export const BookForm = (props: BookFormProps) => {
  const { initialData, onSubmit, onCancel, isSubmitting = false } = props;

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<BookFormData>({
    resolver: zodResolver(bookSchema),
    defaultValues: {
      title: initialData?.title || '',
      author: initialData?.author || '',
      yearPublished: initialData?.yearPublished || ('' as any),
      genre: initialData?.genre || '',
      coverUrl: initialData?.coverUrl || '',
      shelf: initialData?.shelf || 'Quero Ler',
      totalPages: initialData?.totalPages || ('' as any),
      isbn: initialData?.isbn || '',
    },
  });

  const handleFormSubmit = async (data: BookFormData) => {
    const cleanedData = {
      ...data,
      yearPublished: data.yearPublished || undefined,
      totalPages: data.totalPages || undefined,
      coverUrl: data.coverUrl || undefined,
      genre: data.genre || undefined,
      isbn: data.isbn || undefined,
    };
    await onSubmit(cleanedData as any);
  };

  return (
    <form onSubmit={handleSubmit(handleFormSubmit)} className="space-y-4">
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">Título *</label>
        <input
          {...register('title')}
          type="text"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        {errors.title && <p className="mt-1 text-sm text-red-600">{errors.title.message}</p>}
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">Autor *</label>
        <input
          {...register('author')}
          type="text"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        {errors.author && <p className="mt-1 text-sm text-red-600">{errors.author.message}</p>}
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Ano de Publicação</label>
          <input
            {...register('yearPublished', { valueAsNumber: true })}
            type="number"
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          {errors.yearPublished && (
            <p className="mt-1 text-sm text-red-600">{errors.yearPublished.message}</p>
          )}
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Total de Páginas</label>
          <input
            {...register('totalPages', { valueAsNumber: true })}
            type="number"
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          {errors.totalPages && (
            <p className="mt-1 text-sm text-red-600">{errors.totalPages.message}</p>
          )}
        </div>
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">Gênero</label>
        <input
          {...register('genre')}
          type="text"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        {errors.genre && <p className="mt-1 text-sm text-red-600">{errors.genre.message}</p>}
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">URL da Capa</label>
        <input
          {...register('coverUrl')}
          type="url"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        {errors.coverUrl && <p className="mt-1 text-sm text-red-600">{errors.coverUrl.message}</p>}
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">ISBN</label>
        <input
          {...register('isbn')}
          type="text"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        {errors.isbn && <p className="mt-1 text-sm text-red-600">{errors.isbn.message}</p>}
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">Estante *</label>
        <select
          {...register('shelf')}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="Quero Ler">Quero Ler</option>
          <option value="Lendo">Lendo</option>
          <option value="Lido">Lido</option>
        </select>
        {errors.shelf && <p className="mt-1 text-sm text-red-600">{errors.shelf.message}</p>}
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          disabled={isSubmitting}
          className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          {isSubmitting ? 'Salvando...' : 'Salvar'}
        </button>
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            disabled={isSubmitting}
            className="px-4 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 disabled:opacity-50 transition-colors"
          >
            Cancelar
          </button>
        )}
      </div>
    </form>
  );
};

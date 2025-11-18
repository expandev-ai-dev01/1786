import { useMutation, useQueryClient } from '@tanstack/react-query';
import { bookService } from '../../services/bookService';
import type { UseBookMutationsReturn } from './types';

export const useBookMutations = (): UseBookMutationsReturn => {
  const queryClient = useQueryClient();

  const createMutation = useMutation({
    mutationFn: bookService.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['books'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: any }) => bookService.update(id, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['books'] });
      queryClient.invalidateQueries({ queryKey: ['book', variables.id] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: bookService.delete,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['books'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
    },
  });

  const moveMutation = useMutation({
    mutationFn: ({ id, shelf }: { id: string; shelf: 'Lido' | 'Lendo' | 'Quero Ler' }) =>
      bookService.moveToShelf(id, shelf),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['books'] });
      queryClient.invalidateQueries({ queryKey: ['book', variables.id] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
    },
  });

  return {
    createBook: createMutation.mutateAsync,
    updateBook: (id, data) => updateMutation.mutateAsync({ id, data }),
    deleteBook: deleteMutation.mutateAsync,
    moveToShelf: (id, shelf) => moveMutation.mutateAsync({ id, shelf }),
    isCreating: createMutation.isPending,
    isUpdating: updateMutation.isPending,
    isDeleting: deleteMutation.isPending,
    isMoving: moveMutation.isPending,
  };
};

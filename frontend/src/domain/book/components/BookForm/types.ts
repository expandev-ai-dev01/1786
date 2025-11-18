import type { CreateBookDto, UpdateBookDto } from '../../types';

export interface BookFormProps {
  initialData?: UpdateBookDto;
  onSubmit: (data: CreateBookDto | UpdateBookDto) => Promise<void>;
  onCancel?: () => void;
  isSubmitting?: boolean;
}

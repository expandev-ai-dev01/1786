import { clsx } from 'clsx';

export interface BookCardVariantProps {
  className?: string;
}

export function getBookCardClassName(props: BookCardVariantProps): string {
  const { className } = props;

  return clsx(
    'bg-white rounded-lg shadow-md overflow-hidden transition-transform hover:scale-105 hover:shadow-lg',
    className
  );
}

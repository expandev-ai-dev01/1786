import type { DashboardStatsProps } from './types';

export const DashboardStatsComponent = (props: DashboardStatsProps) => {
  const { stats } = props;

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-sm font-medium text-gray-500 mb-2">Total de Livros</h3>
          <p className="text-3xl font-bold text-gray-900">{stats.totalBooks}</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-sm font-medium text-gray-500 mb-2">Livros Lidos</h3>
          <p className="text-3xl font-bold text-green-600">{stats.booksRead}</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-sm font-medium text-gray-500 mb-2">Lendo Agora</h3>
          <p className="text-3xl font-bold text-blue-600">{stats.booksReading}</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-sm font-medium text-gray-500 mb-2">Quero Ler</h3>
          <p className="text-3xl font-bold text-purple-600">{stats.booksWantToRead}</p>
        </div>
      </div>

      {stats.currentYearGoal && (
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">
            Meta Anual {stats.currentYearGoal.year}
          </h3>
          <div className="mb-2">
            <div className="flex justify-between text-sm text-gray-600 mb-1">
              <span>
                {stats.currentYearGoal.booksRead} de {stats.currentYearGoal.targetBooks} livros
              </span>
              <span>{stats.currentYearGoal.percentComplete.toFixed(0)}%</span>
            </div>
            <div className="w-full bg-gray-200 rounded-full h-4">
              <div
                className="bg-blue-600 h-4 rounded-full transition-all"
                style={{ width: `${Math.min(stats.currentYearGoal.percentComplete, 100)}%` }}
              />
            </div>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Livros por Mês</h3>
          <div className="space-y-2">
            {stats.booksByMonth.map((item) => (
              <div key={item.month} className="flex justify-between items-center">
                <span className="text-sm text-gray-600">{item.month}</span>
                <span className="text-sm font-semibold text-gray-900">{item.count} livros</span>
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Gêneros Favoritos</h3>
          <div className="space-y-2">
            {stats.genreDistribution.map((item) => (
              <div key={item.genre} className="flex justify-between items-center">
                <span className="text-sm text-gray-600">{item.genre}</span>
                <span className="text-sm font-semibold text-gray-900">{item.count} livros</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="bg-white p-6 rounded-lg shadow">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Estatísticas Gerais</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <p className="text-sm text-gray-500">Total de Páginas Lidas</p>
            <p className="text-2xl font-bold text-gray-900">
              {stats.totalPagesRead.toLocaleString()}
            </p>
          </div>
          <div>
            <p className="text-sm text-gray-500">Avaliação Média</p>
            <p className="text-2xl font-bold text-gray-900">{stats.averageRating.toFixed(1)} ⭐</p>
          </div>
        </div>
      </div>
    </div>
  );
};

import { useNavigate } from 'react-router-dom';

export const HomePage = () => {
  const navigate = useNavigate();

  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="text-center max-w-2xl px-4">
        <h1 className="text-5xl font-bold text-gray-900 mb-4">Bem-vindo ao BookNest</h1>
        <p className="text-xl text-gray-600 mb-8">
          Sua biblioteca pessoal e clube de leitura virtual. Organize seus livros, acompanhe seu
          progresso e alcance suas metas de leitura.
        </p>
        <div className="flex gap-4 justify-center">
          <button
            onClick={() => navigate('/library')}
            className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold"
          >
            Ir para Biblioteca
          </button>
          <button
            onClick={() => navigate('/dashboard')}
            className="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
          >
            Ver Dashboard
          </button>
        </div>
      </div>
    </div>
  );
};

export default HomePage;

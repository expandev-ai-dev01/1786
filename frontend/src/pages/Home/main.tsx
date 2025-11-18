/**
 * @page HomePage
 * @summary Welcome page for BookNest application
 * @domain core
 * @type landing-page
 * @category public
 */
export const HomePage = () => {
  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Bem-vindo ao BookNest</h1>
        <p className="text-lg text-gray-600">Sua biblioteca pessoal e clube de leitura virtual</p>
      </div>
    </div>
  );
};

export default HomePage;

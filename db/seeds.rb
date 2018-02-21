# Categorias
[
  { name: 'Acessórios',              description: 'Acessórios como boné, guarda-chuvas, pulseiras, anéis...' },
  { name: 'Adiantamento de salário', description: 'Parte do salário recebido no meio do mês' },
  { name: 'Ajuda a família',         description: 'Dinheiro doado para qualquer membro da família, sem nenhum retorno esperado' },
  { name: 'Alimentação',             description: 'Referente aos gastos compras em feiras e mercados de alimentos' },
  { name: 'Aluguel de imóvel',       description: 'Valor gasto com alguel para moradia' },
  { name: 'Calçados',                description: 'Gastos com calçados' },
  { name: 'Comida de rua',           description: 'Gastos em restaurantes, lanches na rua, pasteis na feira, ou salgadinhos em mercado' },
  { name: 'Comunhão',                description: 'Dinheiro doado para qualquer pessoa de fora da família sem nenhum retorno esperado' },
  { name: 'Comunicação',             description: 'Gastos com crédito de celular' },
  { name: 'Conta de gás',            description: 'Gastos com a conta de gás de casa' },
  { name: 'Conta de Internet',       description: 'Gastos com a conta de internet de casa' },
  { name: 'Conta de luz',            description: 'Gastos com a conta de luz de casa' },
  { name: 'Cosméticos',              description: 'Gastos com sabonetes, cremes e desodorantes' },
  { name: 'Cursos',                  description: 'Gastos com formação em cursos de idioma, habilidades técnicas e afins' },
  { name: 'Décimo terceiro',         description: 'Dinheiro recebido referente ao 13 salário' },
  { name: 'Eletrônicos',             description: 'Dinheiro gasto com aparelhos eletrônicos, como celulares, laptops, computador, e afins' },
  { name: 'Empréstimos',             description: 'Dinheiro dado ou recebido de alguém com retorno esperado' },
  { name: 'Encontros',               description: 'Gastos com formação humana e/ou espiritual' },
  { name: 'Férias',                  description: 'Gastos com viagens de lazer' },
  { name: 'Freelas',                 description: 'Gastos recebidos por atividades de trabalho pontuais ou informais' },
  { name: 'Investimento',            description: 'Dinheiro direcionado para algum investimento, como tesouro direto, bolsa de valores e afins' },
  { name: 'Lazeres',                 description: 'Gastos com cinemas, teatros, show e afins' },
  { name: 'Móveis',                  description: 'Gastos com móveis e/ou eletrodomésticos, como TV, mesas, e afins' },
  { name: 'Participação no Lucros',  description: 'Dinheiro recebido como participação nos lucros e resultados da empresa na qual se trabalha' },
  { name: 'Resgate de investimento', description: 'Dinheiro recuperado de algum investimento feito anteriormente' },
  { name: 'Salário',                 description: 'Restante ou todo o salário devido do mês, recebido no início do mês subsequente' },
  { name: 'Transporte',              description: 'Gastos com transportes públicos ou aluguéis de veículos' },
  { name: 'Venda de passivos',       description: 'Dinheiro recebido pela venda de algum bem' },
  { name: 'Vestuário',               description: 'Gastos com roupas' }
].each do |params|
  Category.find_or_create_by(params)
end

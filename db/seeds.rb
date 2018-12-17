# Categorias
Category.find_or_create_by(name: 'Casa').tap do |category|
  [
    { 'name' => 'Luz',                'category_id' => category.id },
    { 'name' => 'Internet',           'category_id' => category.id },
    { 'name' => 'Água',               'category_id' => category.id },
    { 'name' => 'Gás',                'category_id' => category.id },
    { 'name' => 'Limpeza',            'category_id' => category.id },
    { 'name' => 'Aluguel',            'category_id' => category.id },
    { 'name' => 'Móveis',             'category_id' => category.id },
    { 'name' => 'Decoração',          'category_id' => category.id },
    { 'name' => 'Segurança',          'category_id' => category.id },
    { 'name' => 'Alimentação',        'category_id' => category.id },
    { 'name' => 'Manutenção de casa', 'category_id' => category.id },
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

Category.find_or_create_by(name: 'Espiritualidade').tap do |category|
  [
    { 'name' => 'Dízimo',                'category_id' => category.id },
    { 'name' => 'Comunhão de bens',      'category_id' => category.id },
    { 'name' => 'Formação espiritual',   'category_id' => category.id },
    { 'name' => 'Encontros espirituais', 'category_id' => category.id },
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

Category.find_or_create_by(name: 'Educação').tap do |category|
  [
    { 'name' => 'Cursos',              'category_id' => category.id },
    { 'name' => 'Mensalidade escolar', 'category_id' => category.id },
    { 'name' => 'Material escolar',    'category_id' => category.id },
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

Category.find_or_create_by(name: 'Transporte').tap do |category|
  [
    { 'name' => 'Transporte coletivo', 'category_id' => category.id },
    { 'name' => 'Aluguel de carros',   'category_id' => category.id },
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

Category.find_or_create_by(name: 'Geral').tap do |category|
  [
    { 'name' => 'Mercado',              'category_id' => category.id },
    { 'name' => 'Higiene pessoal',      'category_id' => category.id },
    { 'name' => 'Impostos e taxas',     'category_id' => category.id },
    { 'name' => 'Presentes',            'category_id' => category.id },
    { 'name' => 'Doações',              'category_id' => category.id },
    { 'name' => 'Categoria genérica',   'category_id' => category.id },
    { 'name' => 'Investimentos',        'category_id' => category.id },
    { 'name' => 'Eletrônicos',          'category_id' => category.id },
    { 'name' => 'Categoria genérica',   'category_id' => category.id },
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

Category.find_or_create_by(name: 'Lazer').tap do |category|
  [
    { 'name' => 'Cinema',               'category_id' => category.id },
    { 'name' => 'Bares e restaurantes', 'category_id' => category.id },
    { 'name' => 'Diversão',             'category_id' => category.id }
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

Category.find_or_create_by(name: 'Pessoal').tap do |category|
  [
    { 'name' => 'Acessórios',        'category_id' => category.id },
    { 'name' => 'Vestuário',         'category_id' => category.id },
    { 'name' => 'Calçados',          'category_id' => category.id },
    { 'name' => 'Cosméticos',        'category_id' => category.id },
    { 'name' => 'Higiene pessoal',   'category_id' => category.id },
    { 'name' => 'Cartão de crédito', 'category_id' => category.id },
    { 'name' => 'Comunicação',       'category_id' => category.id },
    { 'name' => 'Empréstimos',       'category_id' => category.id },
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

Category.find_or_create_by(name: 'Saúde').tap do |category|
  [
    { 'name' => 'Medicamentos', 'category_id' => category.id },
    { 'name' => 'Consultas',    'category_id' => category.id },
    { 'name' => 'Exames',       'category_id' => category.id },
    { 'name' => 'Cirugias',     'category_id' => category.id },
    { 'name' => 'Terapias',     'category_id' => category.id },
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

Category.find_or_create_by(name: 'Trabalho').tap do |category|
  [
    { 'name' => 'Adiantamento de salário', 'category_id' => category.id },
    { 'name' => 'Participação nos lucros', 'category_id' => category.id },
    { 'name' => 'Reembolso de despesas',   'category_id' => category.id },
    { 'name' => 'Recisão contratual',      'category_id' => category.id },
    { 'name' => 'Prestação de serviços',   'category_id' => category.id },
    { 'name' => 'Seguro desemprego',       'category_id' => category.id },
    { 'name' => '13º Salário',             'category_id' => category.id },
    { 'name' => 'Salário',                 'category_id' => category.id },
    { 'name' => 'Férias',                  'category_id' => category.id },
  ].each do |sub_category|
    SubCategory.find_or_create_by(sub_category.merge(category_id: category.id))
  end
end

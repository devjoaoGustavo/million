module HomeHelper
  def welcome_message
    content_tag :h1 do
      if logged_in?
        <<-MSG
          Bem-vind@,
          #{current_user.presentation_name}.
          É uma grande alegria ter você aqui conosco.
          Este é o Million, seu gerenciador pessoal de finanças!
        MSG
      else
        "Bem-vind@ ao Million, seu gerenciador pessoal de finanças!"
      end
    end
  end
end

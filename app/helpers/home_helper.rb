module HomeHelper
  def welcome_message
    content_tag :h1 do
      if logged_in?
        <<-MSG
          Welcome,
          #{current_user.presentation_name}.
          It is a pleasure have you with us.
          I am Million, your patrimonial manager!
        MSG
      else
        "Welcome to Million, your patrimonial manager!"
      end
    end
  end
end

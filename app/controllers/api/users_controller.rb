# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    def redefine
      @user = User.find params[:id]
      if allowed_params[:password].blank? || allowed_params[:password_confirmation].blank?
        flash[:alert] = 'Informe corretamente a nova senha e a confirmação de senha'
        head :precondition_failed
      else
        @user.password              = allowed_params[:password]
        @user.password_confirmation = allowed_params[:password_confirmation]
        if @user.activate!
          session[:user_id] = @user.id
          flash[:notice] = 'Senha redefinida com sucesso.'
          head :ok
        else
          flash[:alert] = 'Senha e confirmação de senha devem ser iguais'
          head :precondition_failed
        end
      end
    end

    private

    def allowed_params
      params.permit(:id, :password, :password_confirmation)
    end
  end
end

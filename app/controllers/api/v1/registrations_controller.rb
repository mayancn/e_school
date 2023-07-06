module Api
  module V1
    class RegistrationsController < Api::V1::BaseController
      def create
        user = User.new
        user.email = params[:email]
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]
        if user.save
          render json: {status: 'CREATED', message: 'User created', data: user}, status: :created
        else
          # head(:unauthorized)
          render json: {status: 'UNAUTHORIZED', message: 'Email or Password wrong', data: 'Email or Password wrong'}, status: :unauthorized
        end
      end
      
      def destroy
        user = User.where(email: params[:email]).first
      end

      private
      def session_params
        params[:registration].permit(:email, :password, :password_confirmation)
      end
    end
  end
end
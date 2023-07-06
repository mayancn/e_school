module Api
  module V1
    class SessionsController < Api::V1::BaseController
    
      def create
        user = User.where(email: params[:email]).first
        if user&.valid_password?(params[:password])
          render json: {status: 'CREATED', message: 'User session created', data: user}, status: :created
        else
          render json: {status: 'UNAUTHORIZED', message: 'Email or Password wrong', data: 'Email or Password wrong'}, status: :unauthorized
          # head(:unauthorized)
        end
      end
          
      def destroy
        request.session_options[:skip] = true
      end

      private
      def session_params
        params[:session].permit(:email, :password)
      end
    end
  end
end
class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    # POST /login
    def login
        @user = User.find_by(email: params[:email])
        if @user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: @user.id)
            time = Time.now + 7.days.to_i
            render json: { token: token, exp: time.strftime("%d-%m-%Y %H:%M"),
                           user: @user }, status: :ok
        else
            render json: { error: "No autorizado" }, status: :unauthorized
        end
    end

    def current
        render json: { user: @current_user }, status: :ok
    end

    private

    def login_params
        params.permit(:email, :password)
    end
end

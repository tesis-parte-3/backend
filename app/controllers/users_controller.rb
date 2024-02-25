class UsersController < ApplicationController
  before_action :find_user, except: %i[create index]
  # before_action :validates_passwords, only: :recovery_password

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def forget_password
    @user = User.find_by(email: forget_password_params[:email])
    if @user
      # UserMailer.with(user: @user).reset_password_email.deliver_now # REPARAR
      render json: { message: "Email has been sent" }, status: :ok
    else
      render json: { message: "Email not found" }, status: :not_found
    end
  end

  def recovery_password
    @user = User.find_by(id: params[:user_id])

    if @user && @user.reset_password_token == params[:token]
      # require byebug

      # byebug()
      # render json: { message: "Token is valid", password_attributes: recovery_password }, status: :ok
      if @user.update(password: recovery_password[:password])
        @user.generate_password_token
        render json: { message: "Password has been updated", user: @user }, status: :ok
      else
        render json: { errors: "Invalid password" }, status: :unprocessable_entity
      end
    else
      render json: { message: "Invalid token" }, status: :forbidden
    end
  end

  # GET /users/:id
  def show
    @user = User.find(find_user[:id])
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    token = JsonWebToken.encode(user_id: @user.id)
    time = Time.now + 7.days.to_i
    if @user.save
      render json: { token: token, exp: time.strftime("%d-%m-%Y %H:%M"), user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/:id
  def update
   
    @user = User.find(find_user[:id ])
    # if @user && !@user.authenticate(edit_user_params[:currentPassword])
    #   render json: { message: "no password matches" }, status: :forbidden
    # else   
           
    #end

    if @user.update(
      name: edit_user_params[:name],
      email: edit_user_params[:email],
      password: edit_user_params[:password]
    )
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity       
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(find_user[:id])
    if @user.destroy
      render json: { message: "User has been destroyed", user: @user }, status: :ok
    else
      render json: { message: "User cannot be destroy" },
             status: :unprocessable_entity
    end
  end

  private

  # def validates_passwords
  #   unless (recovery_password_params[:password] == recovery_password_params[:password_confirmation] && recovery_password_params[:password].to_s.length >= 8)
  #     render json: { message: "passwords do not match" }, status: :forbidden
  #   end
  # end

  def find_user
    params.permit(:id)
  end

  def user_params
    params.permit(
      :name, :email, :dni, :password, :password_confirmation
    )
  end

  def recovery_password_params
    params.permit(:password)
  end


  def forget_password_params
    params.require(:user).permit(:email)
  end

  def edit_user_params
    params.require(:user).permit(
      :name, :email, :password, :currentPassword
    )
  end


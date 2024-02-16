class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/:id
  def show
    @user = User.find(find_user[:id])
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/:id
  def update
    @user = User.find(find_user[:id])
    if @user && !@user.authenticate(edit_user_params[:currentPassword])
      render json: { message: "no password matches" }, status: :forbidden
    else   
      unless @user.update(
        name: edit_user_params[:name],
        email: edit_user_params[:email],
      )
        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      else 
        render json: @user, status: :ok
      end     
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

  def find_user
    params.permit(:id)
  end

  def user_params
    params.permit(
      :name, :email, :dni, :password, :password_confirmation
    )
  end

  def edit_user_params
    params.require(:user).permit(
      :name, :email, :newPassword, :currentPassword, :password
    )
  end
end

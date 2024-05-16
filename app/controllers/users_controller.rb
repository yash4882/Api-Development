class UsersController < ApplicationController

  before_action :set_id, only: %i[show update destroy]   #before cation callback


  def index
    @users = User.includes(:images)  # eager loading its is also called n+1 quary and best way to solve it
    # render json: @users.map {|user| user.as_json(include: {images: {only: %i[id url]}})}
    render json: @users.as_json(include: {images: {only: %i[id url]}})
  end

  def show
    render json: @user.as_json(include: {images: {only: %i[id url]}})
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: {message: "Successfuly destroy"}
  end

  def set_id
    # for show, update, delete
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    render json: {message: error.message, status: "Id Not Found"}
  end

  private
  def user_params
    params.require(:user).permit(:name, :surname, images_attributes: [:id, :url])
  end

end

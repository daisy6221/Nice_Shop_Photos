class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_user
    name_str = params[:name]
    sanitized_name_str = name_str.gsub(/[^a-zA-Z0-9_]/, '')
    name_sym = sanitized_name_str.to_sym
    @user = User.find_by(name: name_sym)
  end

end

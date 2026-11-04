class ProfilesController < ApplicationController
  before_action :require_login

  def show
  end

  def edit
  end

  def update
    purge_avatar_if_requested

    if current_user.update(profile_params)
      redirect_to profile_path, notice: "Профиль сохранён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:nickname, :avatar)
  end

  def purge_avatar_if_requested
    return unless params.dig(:user, :remove_avatar) == "1"
    return if params.dig(:user, :avatar).present?

    current_user.avatar.purge if current_user.avatar.attached?
  end
end

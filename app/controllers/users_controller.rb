class UsersController < ApplicationController
  before_action :authenticate_user!
  layout 'student', except: %i[edit update]

  # GET /dashboard/
  def dashboard
    @user = authorize(current_user)
  end

  # GET /user/edit
  def edit
    @form = Users::EditForm.new(current_user)
  end

  def edit_v2
    @user = authorize(current_user)
  end

  # GET /users/delete_account
  def delete_account
    user = Users::ValidateDeletionTokenService.new(params[:token], current_user).authenticate
    if user.present?
      @token = params[:token]
    else
      flash[:error] = "That one-time link has already been used, or is invalid. Please try again."
      redirect_to root_path
    end
  end

  def upload_avatar
    @form = Users::UploadAvatarForm.new(current_user)
    if @form.validate(params[:user])
      avatar_url = @form.save!
      render json: { avatarUrl: avatar_url }
    else
      render 'edit'
    end
  end

  # PATCH /user
  def update
    @form = Users::EditForm.new(current_user)

    if @form.validate(params[:users_edit])
      @form.save!
      flash[:success] = 'Your profile has been updated.'
      redirect_to edit_user_path
    else
      render 'edit'
    end
  end
end

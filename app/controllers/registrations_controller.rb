class RegistrationsController < Devise::RegistrationsController

  def create
    user = User.new(user_params)
    respond_to do |format|
      if user.save
        format.html { redirect_to authenticated_root_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :role_ids, :password, :password_confirmation)
  end
end
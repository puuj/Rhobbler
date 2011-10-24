class Users::Show < Stache::View
  include InstructionImages
  include RockstarHelper

  def user
    @user
  end

  def form_action
    user_path(@user.id)
  end
end

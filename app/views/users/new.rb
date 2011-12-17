class Users::New < Stache::View
  include InstructionImages
  delegate :session_key, :to => :@user
  delegate :lastfm_username, :to => :@user
  delegate :form_authenticity_token, :to => :controller
end

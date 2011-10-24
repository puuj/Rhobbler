class Users::New < Stache::View
  include InstructionImages
  delegate :session_key, :to => :@user
  delegate :lastfm_username, :to => :@user
end

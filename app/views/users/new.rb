class Users::New < Stache::View
  include InstructionImages
  delegate :session_key, :to => :@user
  delegate :lastfm_username, :to => :@user
  delegate :form_authenticity_token, :to => :controller
  delegate :lastfm_token, :to => :controller
  delegate :lastfm_session, :to => :controller

  def lastfm_authorize_url
    "http://www.last.fm/api/auth/?api_key=#{Rockstar.lastfm_api_key}&token=#{lastfm_token}"
  end

  def registration_next_url
    new_user_url
  end
end

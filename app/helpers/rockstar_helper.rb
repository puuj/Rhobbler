module RockstarHelper
  def lastfm_authorize_url
    a = Rockstar::Auth.new
    token = a.token
    "http://www.last.fm/api/auth/?api_key=#{Rockstar.lastfm_api_key}&token=#{token}"
  end
end

# This module handles all of our interaction with Rhapsody in an app-neutral fashion
# This would be great to extract into a gem, but is it useful for anyone else?
#
require 'net/http'
module Rhapsody
  def self.fetch_listening_history(username)
    response = Net::HTTP.start("www.rhapsody.com", 80) do |http|
      http.get("/members/#{username}/listening_history.json")
    end

    case response.code
    when "200"
      parse_listening_history(response.body)
    when "404"
      raise RhapsodyUserNotAuthorizedError
    when "500"
      raise RhapsodyUserNotFoundError
    end
  end

private
  def self.parse_listening_history(content)
    JSON.parse(content).map do |listen|
      {
        :track_id  => listen["trackPlayed"]["trackId"],
        :played_at => Time.parse(listen["timePlayed"]),
        :title     => listen["trackPlayed"]["name"],
        :artist    => listen["trackPlayed"]["displayArtistName"]
      }
    end
  end
end


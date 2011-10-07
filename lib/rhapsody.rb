# This module handles all of our interaction with Rhapsody in an app-neutral fashion
# This would be great to extract into a gem, but is it useful for anyone else?
#
require 'net/http'
module Rhapsody
  def self.fetch_listening_history(username)
    response = Net::HTTP.start("www.rhapsody.com", 80) do |http|
      http.get("/members/#{username}/listening_history?timezoneOffset=0")
    end

    if response.code == "200"
      return parse_listening_history(response.body)
    elsif response.code == "404"
      raise RhapsodyUserNotAuthorizedError
    elsif response.code == "500"
      raise RhapsodyUserNotFoundError
    end
  end

private
  def self.parse_listening_history(content)
    results = {}
    doc = Nokogiri::HTML(content)

    date = Date.today
    doc.css("tracks > *").each do |tag|
      if tag.name == "h4"
        date = Date.parse(tag.content)
        results[date] ||= {}
      elsif tag.name == "ul"
        tag.css("li").each do |li|
          # TODO: Add more elements to this hash if anybody needs them
          results[date][li['track_name']] = {
            :artist     => li['artist_name'],
            :name       => li['track_name'],
            :track_id   => li['track_id']
          }
        end
      end
    end

    return results
  end
end

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
    day = {}
    doc.css("tracks > *").each do |tag|
      if tag.name == "h4"
        date = Date.parse(tag.content)
        results[date] ||= {}
        day = results[date]
      elsif tag.name == "ul"
        tag.css("li").each do |li|
          track_id = li['track_id']

          if day.has_key?(track_id)
            day[track_id][:count] += 1
          else
            results[date][li['track_id']] = {
              :artist     => li['artist_name'],
              :title      => li['track_name'],
              :count      => 1
            }
          end
        end
      end
    end

    return results
  end
end

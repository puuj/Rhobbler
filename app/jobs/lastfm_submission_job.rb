class LastfmSubmissionJob
  @queue = :lastfm
  extend Resque::Plugins::Enqueue

  def perform(listen_id)
    listen = Listen.find(listen_id)
    track = Rockstar::Track.new(listen.artist, listen.title)
    begin
      # Will raise error if lastfm fails
      status = track.scrobble(Time.now, listen.user.session_key)
      listen.submit!
      listen.track.verify_lastfm!
    rescue
    end

    return status
  end
end

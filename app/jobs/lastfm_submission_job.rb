class LastfmSubmissionJob
  @queue = :lastfm
  extend Resque::Plugins::Enqueue

  def perform(listen_id)
    listen = Listen.find(listen_id)
    track = Rockstar::Track.new(listen.artist, listen.title)
    track.scrobble(Time.now, listen.user.session_key)
  end
end

# This job does the actual submission to Rhapsdy using Rockstar
class LastfmSubmissionJob
  @queue = :lastfm
  extend Resque::Plugins::Enqueue

  def perform(listen_id)
    listen = Listen.find(listen_id)
    track = Rockstar::Track.new(listen.artist, listen.title)
    begin
      # Will raise error if lastfm fails
      status = track.scrobble(Time.now, listen.user.session_key)

      # Change the listen's status to submitted
      listen.submit!

      # Change the user's lastfm status to verified
      listen.user.verify_lastfm!
    rescue
      # TODO: Requeue upon failure?
    end

    return status
  end
end


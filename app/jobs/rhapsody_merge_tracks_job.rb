# This is the job that actually does the fetching of the rhapsody listening history
class RhapsodyMergeTracksJob
  @queue = :rhapsody
  extend Resque::Plugins::Enqueue

  # One job per user
  def self.perform(user_id)
    user = User.find(user_id)

    begin
      listens = Rhapsody.fetch_listening_history(user.rhapsody_username).map do |listen|
        Listen.where(
          :user_id   => user_id,
          :track_id  => listen[:track_id],
          :played_at => listen[:played_at]

        ).first_or_create(listen.merge(:user_id => user_id))
      end

      # If they haven't listened to anything since the last fetch, fetch again in an hour
      if listens.empty?
        Resque.enqueue_in(1.hour, RhapsodyMergeTracksJob, user_id)
      # If they're listening right now, requeue them sooner
      else
        Resque.enqueue_in(10.minutes, RhapsodyMergeTracksJob, user_id)
      end
    rescue RhapsodyUserNotAuthorizedError
      # For some reason they've made their listening history private again.
      # Deauthorize them until they fix it.
      user.deauthorize_rhapsody!
      user.save
    end
  end
end

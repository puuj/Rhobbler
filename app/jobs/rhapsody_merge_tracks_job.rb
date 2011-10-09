class RhapsodyMergeTracksJob
  @queue = :rhapsody
  extend Resque::Plugins::Enqueue

  def perform(user_id)
    user = User.find(user_id)

    begin
      listens = Rhapsody.fetch_listening_history(user.rhapsody_username)

      if listens.empty?
        Resque.enqueue_in(1.hour, RhapsodyMergeTracksJob, user_id)
      else
        # If they're listening right now, requeue them sooner
        Resque.enqueue_in(10.minutes, RhapsodyMergeTracksJob, user_id)
        Listen.merge(listens)
      end
    rescue RhapsodyUserNotAuthorizedError
      # For some reason they've made their listening history private again.
      # Deauthorize them until they fix it.
      user.deauthorize_rhapsody!
      user.save
    end
  end
end

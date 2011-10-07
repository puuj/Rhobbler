class RhapsodyMergeTracksJob
  @queue = :rhapsody
  extend Resque::Plugins::Enqueue

  def perform(user_id)
    user = User.find(user_id)

    begin
      response = Rhapsody.fetch_listening_history(user.rhapsody_username)
    rescue RhapsodyUserNotAuthorizedError
      # For some reason they've made their listening history private again.
      # Deauthorize them until they fix it.
      user.deauthorize_rhapsody!
      user.save
    end
  end
end

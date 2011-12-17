# This job attempts to fetch the Rhapsody listening history of a particular user
# Depending on the success of the fetch, it updates the user accordingly
#
class RhapsodyVerifyJob
  extend Resque::Plugins::Retry
  extend Resque::Plugins::Enqueue

  @queue = :rhapsody
  @retry_delay = 60

  # One job per user
  def perform(user_id)
    user = User.find(user_id)

    begin
      response = Rhapsody.fetch_listening_history(user.rhapsody_username)
      user.verify_rhapsody!
    rescue RhapsodyUserNotAuthorizedError
      user.deauthorize_rhapsody!

      # Re-raise to automatically retry. Hopefully the user will authorize us soon.
      raise RhapsodyUserNotAuthorizedError,
        "Could not gain access to listening history for user #{user_id} with Rhapsody member ID of #{user.rhapsody_username}"
    rescue RhapsodyUserNotFoundError
      user.deactivate_rhapsody!
    end
  end
end


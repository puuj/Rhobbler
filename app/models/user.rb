# This model represents a user of last.fm and Rhapsody.
#
# Fields:
# rhapsody_username - String:            Rhapsody username / "member identifier" (eg "y35j1")
# lastfm_username   - String - not null: Last.fm username
# session_key       - String - not null: Last.fm session key
# rhapsody_state    - String - not null: State of the User's submission state for Rhapsody
# lastfm_state      - String - not null: state of the User's submission state for last.fm
#
class User < ActiveRecord::Base
  has_many :listens

  validates_presence_of :lastfm_username, :session_key, :rhapsody_state, :lastfm_state
  validates_uniqueness_of :rhapsody_username, :lastfm_username

  state_machine :rhapsody_state, :namespace => 'rhapsody', :initial => :unverified do
    event :verify do
      transition all - [:verified] => :verified
    end

    event :deauthorize do
      transition [:unverified, :verified] => :unauthorized
    end

    event :deactivate do
      transition [:unverified, :verified] => :inactive
    end

    # New user, have not yet validated Rhapsody access
    state :unverified

    # User with verified Rhapsody access
    state :verified

    # User with an incorrect Rhapsody username
    state :inactive

    # User with an unathorized Rhapsody listening history
    state :unauthorized
  end

  state_machine :lastfm_state, :namespace => 'lastfm', :initial => :unverified do
    event :verify do
      transition all - [:verified] => :verified
    end

    event :deauthorize do
      transition [:unverified, :verified] => :unauthorized
    end

    event :deactivate do
      transition [:unverified, :verified] => :inactive
    end

    # New user, have not yet validated last.fm access
    state :unverified

    # User with verified last.fm access
    state :verified

    # User who has turned off scrobbling to last.fm
    state :inactive

    # User with an unathorized last.fm listening history
    state :unauthorized
  end
end


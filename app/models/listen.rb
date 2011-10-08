# Model representing a specific instance of a user listening to a particular song
# Due to Rhapsody's data provided we're limited to day-level granularity
#
# Fields:
# user_id  - FK     - not null: The ID of the User
# track_id - String - not null: The track ID provided by Rhapsody
# artist   - String - not null: The artist of the track
# title    - String - not null: The title of the track
# date     - Date   - not null: The date of the listen
# state    - String - not null: The submission status of this particular listen
#
class Listen < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :track_id, :date, :state, :artist, :title

  state_machine :state, :initial => :unsubmitted do
    event :submit do
      transition :unsubmitted => :submitted
    end

    state :unsubmitted
    state :submitted
  end

  # It would be great to decouple this from persistence
  after_create :submit_to_lastfm
  def submit_to_lastfm
    LastfmSubmissionJob.enqueue(self.id)
  end
end


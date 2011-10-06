# Model representing a specific instance of a user listening to a particular song
# Due to Rhapsody's data provided we're limited to day-level granularity
#
# Fields:
# user_id  - FK     - not null: The ID of the User
# track_id - String - not null: The track ID provided by Rhapsody
# date     - Date   - not null: The date of the listen
# state    - String - not null: The submission status of this particular listen
#
class Listen < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :track_id, :date, :state

  state_machine :state, :initial => :unsubmitted do
    event :submit do
      transition :unsubmitted => :submitted
    end

    state :unsubmitted
    state :submitted
  end
end


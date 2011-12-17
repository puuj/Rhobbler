FactoryGirl.define do
  sequence :username do |n|
    "user_#{n}"
  end

  sequence :track_id do |n|
    "tra#{n}"
  end

  factory :user do
    rhapsody_username  { Factory.next(:username) }
    rhapsody_state     'inactive'
    lastfm_username    { Factory.next(:username) }
    lastfm_state       'unverified'
    session_key        'foo'
  end

  factory :listen do
    association :user
    played_at   { Time.now }
    track_id    { Factory.next(:track_id) }
    artist      'Some Artist'
    title       'A Title'
  end
end

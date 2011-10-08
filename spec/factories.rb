FactoryGirl.define do
  sequence :username do |n|
    "user_#{n}"
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
    artist      'Some Artist'
    title       'A Title'
  end
end

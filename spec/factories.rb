FactoryGirl.define do
  sequence :username do |n|
    n.to_s
  end

  factory :user do
    rhapsody_username  { Factory.next(:username) }
    rhapsody_state     'inactive'
    lastfm_username    { Factory.next(:username) }
    lastfm_state       'unverified'
    session_key        'foo'
  end
end

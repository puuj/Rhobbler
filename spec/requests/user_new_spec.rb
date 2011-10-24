require 'spec_helper'

describe "UserNew" do
  before(:each) do
    mock_session = mock(Rockstar::Session)
    mock_session.should_receive(:key).and_return("ASESSIONKEY")
    mock_session.should_receive(:username).at_least(1).times.and_return("AUSERNAME")
    Rockstar::Auth.any_instance.stub(:session).with("ATOKEN").and_return(mock_session)
  end

  describe "for a non-existent user" do
    it "displays correct username" do
      visit new_user_path(:token => "ATOKEN")
      page.should have_content("AUSERNAME")
    end

    it "has input for rhapsody username" do
      visit new_user_path(:token => "ATOKEN")
      page.should have_selector("input[name='user[rhapsody_username]']")
    end
  end

  describe "for an already-existing user" do
    before(:each) do
      @user = Factory(:user,
        :lastfm_username   => "AUSERNAME",
        :rhapsody_username => "ARHAPSODYUSERNAME",
        :rhapsody_state    => "unverified"
      )
    end

    it "redirects to profile page" do
      visit new_user_path(:token => "ATOKEN")
      page.should have_content @user.rhapsody_username
    end
  end
end


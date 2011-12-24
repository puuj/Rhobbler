require 'spec_helper'

describe "UserIndex" do
  describe "with authorized token of an existing user" do
    before(:each) do
      mock_session
      mock_token

      @user = Factory(:user,
        :lastfm_username   => "AUSERNAME",
        :rhapsody_username => "ARHAPSODYUSERNAME",
        :rhapsody_state    => "unverified"
      )
    end

    it "redirects to profile page" do
      visit users_path
      page.should have_content @user.rhapsody_username
    end
  end

  describe "without authorized token" do
    before(:each) do
      mock_no_session
      mock_token
    end

    it "displays link to the new user page" do
      visit users_path
      page.should have_link("Click here", :href => new_user_url)
    end
  end
end

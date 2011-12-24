require 'spec_helper'

describe "UserNew" do
  context "without authorized token" do
    before(:each) do
      mock_no_session
      mock_token
    end

    it "displays link to last.fm" do
      visit new_user_path
      page.should have_link("go to last.fm")
    end
  end

  context "with authorized token" do
    before(:each) do
      mock_session
      mock_token
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
end


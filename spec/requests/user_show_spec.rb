require 'spec_helper'

describe "UserShow" do
  describe "for a verified rhapsody state" do
    before(:each) do
      @user = signup_with(:rhapsody_state => 'verified')
    end

    it "displays correct rhapsody username" do
      visit user_path(@user)
      rhapsody_segment = page.find("#rhapsody_state")
      rhapsody_segment.should have_content @user.rhapsody_username
      rhapsody_segment.should have_content "We are connected"
    end
  end

  describe "for an unverified rhapsody state" do
    before(:each) do
      @user = signup_with(:rhapsody_state => 'unverified')
    end

    it "displays correct rhapsody username" do
      visit user_path(@user)
      rhapsody_segment = page.find("#rhapsody_state")
      rhapsody_segment.should have_content @user.rhapsody_username
      rhapsody_segment.should have_content "We are currently attempting to connect"
    end
  end

  describe "for an unauthorized rhapsody state" do
    before(:each) do
      @user = signup_with(:rhapsody_state => 'unauthorized')
    end

    it "tells them to share the profile" do
      visit user_path(@user)
      rhapsody_segment = page.find("#rhapsody_state")
      rhapsody_segment.should have_content @user.rhapsody_username
      rhapsody_segment.should have_content "Share Profile"
    end
  end

  describe "for an inactive rhapsody state" do
    before(:each) do
      @user = signup_with(:rhapsody_state => 'inactive')
    end

    it "have form to update rhapsody username" do
      visit user_path(@user)
      fill_in "user_rhapsody_username", :with => "ANEWRHAPSODYUSERNAME"
      click_button "Try Again"
      rhapsody_segment = page.find("#rhapsody_state")
      rhapsody_segment.should have_content "ANEWRHAPSODYUSERNAME"
      rhapsody_segment.should have_content "We are currently attempting to connect"
    end
  end

  describe "for a verified last.fm state" do
    before(:each) do
      @user = signup_with(:lastfm_state => 'verified')
    end

    it "displays correct lastfm username" do
      visit user_path(@user)
      lastfm_segment = page.find("#lastfm_state")
      lastfm_segment.should have_content @user.lastfm_username
      lastfm_segment.should have_content "We are connected"
    end

    describe "with already scrobbled tracks" do
      before(:each) do
        @user.update_attribute(:rhapsody_state, 'verified')
        @listen = Factory.create(:listen,
          :user_id => @user.id,
          :submitted => true
        )
      end

      it "displays scrobble data" do
        visit user_path(@user)
        page.should have_content(@listen.artist)
        page.should have_content(@listen.title)
      end
    end
  end

  describe "for a unverified last.fm state" do
    before(:each) do
      @user = signup_with(:lastfm_state => 'unverified')
    end

    it "displays correct lastfm username" do
      visit user_path(@user)
      lastfm_segment = page.find("#lastfm_state")
      lastfm_segment.should have_content @user.lastfm_username
      lastfm_segment.should have_content "We are currently attempting to connect"
    end
  end

  describe "for an unauthorized last.fm state" do
    before(:each) do
      @user = signup_with(:lastfm_state => 'unauthorized')
    end

    it "displays a link to last.fm to reauthorize" do
      visit user_path(@user)
      lastfm_segment = page.find("#lastfm_state")
      lastfm_segment.should have_link("go to last.fm")
    end
  end

  describe "for an inactive last.fm state" do
    before(:each) do
      @user = signup_with(:lastfm_state => 'inactive')
    end

    it "displays a link to last.fm to reauthorize" do
      visit user_path(@user)
      lastfm_segment = page.find("#lastfm_state")
      lastfm_segment.should have_link("go to last.fm")
    end
  end

  def signup_with(options={})
    mock_session
    mock_token

    visit new_user_path(:token => "ATOKEN")
    fill_in "user_rhapsody_username", :with => "ARHAPSODYUSERNAME"
    click_button "Start Rhobbler!"

    user = User.first
    user.update_attributes(options)
    return user
  end
end


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
      lastfm_segment.should have_selector('a[href*="last.fm"]')
    end
  end

  describe "for an inactive last.fm state" do
    before(:each) do
      @user = signup_with(:lastfm_state => 'inactive')
    end

    it "displays a link to last.fm to reauthorize" do
      visit user_path(@user)
      lastfm_segment = page.find("#lastfm_state")
      lastfm_segment.should have_selector('a[href*="last.fm"]')
    end
  end

  def signup_with(options)
    @token = "ATOKEN"
    Rockstar::Auth.any_instance.
      stub(:token).
      and_return(@token)

    mock_session = mock(Rockstar::Session)
    mock_session.
      should_receive(:key).
      and_return("ASESSIONKEY")
    mock_session.
      should_receive(:username).
      at_least(1).times.
      and_return("AUSERNAME")
    Rockstar::Auth.any_instance.
      stub(:session).
      with(@token).
      and_return(mock_session)

    visit new_user_path(:token => @token)
    fill_in "user_rhapsody_username", :with => "ARHAPSODYUSERNAME"
    click_button "Start Rhobbler!"

    user = User.first
    user.update_attributes(options)
    return user
  end
end


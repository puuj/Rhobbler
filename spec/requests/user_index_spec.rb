require 'spec_helper'

describe "UserIndex" do
  describe "GET /users" do
    before(:each) do
      Rockstar::Auth.any_instance.stub(:token).and_return("ATOKEN")
    end

    it "displays link to last.fm" do
      visit users_path
      page.should have_selector('a[href*="last.fm"]')
    end
  end
end


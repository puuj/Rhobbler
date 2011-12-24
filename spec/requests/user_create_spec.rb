require 'spec_helper'

describe "UserCreate" do
  describe "New User Form, then submission" do
    before(:each) do
      mock_session = mock(Rockstar::Session)
      mock_session.should_receive(:key).and_return("ASESSIONKEY")
      mock_session.should_receive(:username).exactly(3).times.and_return("AUSERNAME")
      Rockstar::Auth.any_instance.stub(:session).with("ATOKEN").and_return(mock_session)
      Rockstar::Auth.any_instance.stub(:token).and_return("ATOKEN")
    end

    it "should register user" do
      visit new_user_path(:token => "ATOKEN")
      fill_in "user_rhapsody_username", :with => "ARHAPSODYUSERNAME"
      click_button "Start Rhobbler!"
      page.should have_content("ARHAPSODYUSERNAME")
      User.count.should == 1
    end
  end
end

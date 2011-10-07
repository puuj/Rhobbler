require "spec_helper"

describe Rhapsody do
  let(:username) { "anyusername" }
  let(:valid_body) { File.read(File.join(Rails.root, "spec", "fixtures", "listening_history.html")) }

  it "should give a response if 200" do
    stub_request(:get, "http://www.rhapsody.com/members/#{username}/listening_history?timezoneOffset=0").
      to_return(
        :body => "anything",
        :status => 200,
      )

    Rhapsody.fetch_listening_history(username).should eql({})
  end

  describe "response format" do
    before(:each) do
      stub_request(:get, "http://www.rhapsody.com/members/#{username}/listening_history?timezoneOffset=0").
        to_return(
          :body => valid_body,
          :status => 200,
        )
      @result = Rhapsody.fetch_listening_history(username)
    end

    it "should contain 12 results" do
      @result.size.should eql(12)
    end

    it "should say that on August 5th I listened to a bunch of The Knife" do
      day = @result[Date.parse("August 5th 2011")]

      day.size.should eql(4)

      {
        "We Share Our Mothers' Health" => 2,
        "The Captain" => 1,
        "Neverland" => 1,
        "Silent Shout" => 1
      }.each do |expected_track, count|
        track = day.values.detect {|t| t[:title] == expected_track }
        track.should_not be_nil
        track[:artist].should eql("The Knife")
        track[:count].should eql(count)
      end
    end
  end

  it "should throw RhapsodyUserNotAuthorizedError if 404" do
    stub_request(:get, "http://www.rhapsody.com/members/#{username}/listening_history?timezoneOffset=0").
      to_return(
        :body => "anything",
        :status => 404,
      )

    lambda {
      Rhapsody.fetch_listening_history(username)
    }.should raise_error(RhapsodyUserNotAuthorizedError)
  end

  it "should throw RhapsodyUserNotFoundError if 500" do
    stub_request(:get, "http://www.rhapsody.com/members/#{username}/listening_history?timezoneOffset=0").
      to_return(
        :body => "anything",
        :status => 500,
      )

    lambda {
      Rhapsody.fetch_listening_history(username)
    }.should raise_error(RhapsodyUserNotFoundError)
  end
end

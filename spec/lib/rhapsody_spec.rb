require "spec_helper"

describe Rhapsody do
  let(:username) { "anyusername" }
  let(:valid_body) { File.read(File.join(Rails.root, "spec", "fixtures", "listening_history.json")) }

  it "should give a response if 200" do
    stub_request(:get, "http://www.rhapsody.com/members/#{username}/listening_history.json").
      to_return(
        :body => "[]",
        :status => 200,
      )

    Rhapsody.fetch_listening_history(username).should eql([])
  end

  describe "response format" do
    before(:each) do
      stub_request(:get, "http://www.rhapsody.com/members/#{username}/listening_history.json").
        to_return(
          :body => valid_body,
          :status => 200,
        )
      @result = Rhapsody.fetch_listening_history(username)
    end

    it "should contain 149 results" do
      @result.size.should eql(149)
    end

    it "contains two listens for Heaven's On Fire" do
      listens = @result.select {|t| t[:title] == "Heaven's On Fire" }

      listens.should_not be_nil
      listens.size.should == 2

      listens.first[:artist].should eql("The Radio Dept.")
    end
  end

  it "should throw RhapsodyUserNotAuthorizedError if 404" do
    stub_request(:get, "http://www.rhapsody.com/members/#{username}/listening_history.json").
      to_return(
        :body => "anything",
        :status => 404,
      )

    lambda {
      Rhapsody.fetch_listening_history(username)
    }.should raise_error(RhapsodyUserNotAuthorizedError)
  end

  it "should throw RhapsodyUserNotFoundError if 500" do
    stub_request(:get, "http://www.rhapsody.com/members/#{username}/listening_history.json").
      to_return(
        :body => "anything",
        :status => 500,
      )

    lambda {
      Rhapsody.fetch_listening_history(username)
    }.should raise_error(RhapsodyUserNotFoundError)
  end
end

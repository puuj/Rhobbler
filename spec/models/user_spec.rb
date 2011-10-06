require "spec_helper"

describe User do
  describe "relationships" do
    it "should have a listens relationship" do
      User.new.should respond_to(:listens)
    end

    it "should allow setting of user" do
      listen_stub = stub_model(Listen)
      User.new(:listens => [listen_stub]).listen_ids.should == [listen_stub.id]
    end
  end

  describe "validations" do
    describe "rhapsody_username" do
      it "fails when given already-existing rhapsody_username" do
        first_user = Factory(:user)

        User.new(:rhapsody_username => first_user.rhapsody_username).should have(1).errors_on(:rhapsody_username)
      end

      it "succeeds when given unique rhapsody_username" do
        first_user = Factory(:user)

        User.new(:rhapsody_username => first_user.rhapsody_username.succ).should have(0).errors_on(:rhapsody_username)
      end
    end

    describe "lastfm_username" do
      it "fails validation without lastfm_username" do
        User.new(:lastfm_username => nil).should have(1).errors_on(:lastfm_username)
      end

      it "passes validation with lastfm_username" do
        User.new(:lastfm_username => "foo").should have(0).errors_on(:lastfm_username)
      end

      it "fails when given already-existing lastfm_username" do
        first_user = Factory(:user)

        User.new(:lastfm_username => first_user.lastfm_username).should have(1).errors_on(:lastfm_username)
      end

      it "succeeds when given unique lastfm_username" do
        first_user = Factory(:user)

        User.new(:lastfm_username => first_user.lastfm_username.succ).should have(0).errors_on(:lastfm_username)
      end
    end



    describe "session_key" do
      it "fails validation without a session_key" do
        User.new(:session_key => nil).should have(1).errors_on(:session_key)
      end

      it "passes validation with session_key" do
        User.new(:session_key => "foo").should have(0).errors_on(:session_key)
      end
    end
  end

  [:rhapsody, :lastfm].each do |service|
    describe "#{service}_state validations" do
      it "fails validation when state is explicitly nil" do
        User.new("#{service}_state" => nil).should have(2).errors_on("#{service}_state")
      end

      it "fails validation when invalid state" do
        User.new("#{service}_state" => 'foo').should have(1).errors_on("#{service}_state")
      end

      it "passes validation when no state is given" do
        User.new.should have(0).errors_on("#{service}_state")
      end

      it "passes validation when state is explicitly set" do
        User.new("#{service}_state" => 'verified').should have(0).errors_on("#{service}_state")
      end
    end

    describe "#{service} state" do
      it "should default to unverified" do
        User.new.send("#{service}_state").should == "unverified"
      end
    end

    describe "#{service} transitions" do
      [:unverified, :unauthorized, :inactive].each do |state|
        it "should verify from #{state}" do
          u = build(:user, "#{service}_state" => state.to_s)
          u.send("verify_#{service}!")
          u.send("#{service}_state").should == "verified"
        end
      end

      [:unverified, :verified].each do |state|
        it "should deauthorize from #{state}" do
          u = build(:user, "#{service}_state" => state.to_s)
          u.send("deauthorize_#{service}!")
          u.send("#{service}_state").should == "unauthorized"
        end
      end

      [:unverified, :verified].each do |state|
        it "should deactivate from #{state}" do
          u = build(:user, "#{service}_state" => state.to_s)
          u.send("deactivate_#{service}!")
          u.send("#{service}_state").should == "inactive"
        end
      end
    end
  end
end


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

    describe "rhapsody_state validations" do
      it "fails validation when state is explicitly nil" do
        User.new(:rhapsody_state => nil).should have(2).errors_on(:rhapsody_state)
      end

      it "fails validation when invalid state" do
        User.new(:rhapsody_state => 'foo').should have(1).errors_on(:rhapsody_state)
      end

      it "passes validation when no state is given" do
        User.new.should have(0).errors_on(:rhapsody_state)
      end

      it "passes validation when state is explicitly set" do
        User.new(:rhapsody_state => 'verified').should have(0).errors_on(:rhapsody_state)
      end
    end

    describe "lastfm_state validations" do
      it "fails validation when state is explicitly nil" do
        User.new(:lastfm_state => nil).should have(2).errors_on(:lastfm_state)
      end

      it "fails validation when invalid state" do
        User.new(:lastfm_state => 'foo').should have(1).errors_on(:lastfm_state)
      end

      it "passes validation when no state is given" do
        User.new.should have(0).errors_on(:lastfm_state)
      end

      it "passes validation when state is explicitly set" do
        User.new(:lastfm_state => 'verified').should have(0).errors_on(:lastfm_state)
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


  describe "rhapsody" do
    describe "state" do
      it "should default to unverified" do
        User.new.rhapsody_state.should == "inactive"
      end
    end

    describe "transitions" do
      describe "activate" do
        describe "as inactive user" do
          let(:user) { Factory(:user, :rhapsody_state => "inactive") }

          it "should move to unverified and queue a RhapsodyVerifyJob" do
            RhapsodyVerifyJob.should_receive(:enqueue).once.with(user.id)
            user.activate_rhapsody!
            user.rhapsody_state.should == "unverified"
          end
        end

        describe "as unauthorized user" do
          let(:user) { Factory(:user, :rhapsody_state => "unauthorized") }

          it "should move to unverified and queue a RhapsodyVerifyJob" do
            RhapsodyVerifyJob.should_receive(:enqueue).once.with(user.id)
            user.activate_rhapsody!
            user.rhapsody_state.should == "unverified"
          end
        end

        describe "as verified user" do
          let(:user) { Factory(:user, :rhapsody_state => "verified") }

          it "should move to unverified and queue a RhapsodyVerifyJob" do
            RhapsodyVerifyJob.should_receive(:enqueue).once.with(user.id)
            user.activate_rhapsody!
            user.rhapsody_state.should == "unverified"
          end
        end
      end

      describe "verify" do
        [:unverified, :unauthorized].each do |state|
          let(:user) { Factory(:user, :rhapsody_state => state.to_s) }

          it "should move to verified from #{state}" do
            RhapsodyMergeTracksJob.should_receive(:enqueue).once.with(user.id)

            user.verify_rhapsody!
            user.rhapsody_state.should == "verified"
          end
        end
      end

      describe "deauthorize" do
        [:unverified, :verified].each do |state|
          let(:user) { build(:user, :rhapsody_state => state.to_s) }

          it "should move to unauthorized from #{state}" do
            user.deauthorize_rhapsody!
            user.rhapsody_state.should == "unauthorized"
          end
        end
      end

      describe "deactivate" do
        [:unverified, :verified].each do |state|
          let(:user) { build(:user, :rhapsody_state => state.to_s) }

          it "should deactivate from #{state}" do
            user.deactivate_rhapsody!
            user.rhapsody_state.should == "inactive"
          end
        end
      end
    end
  end

  describe "lastfm" do
    describe "state" do
      it "should default to unverified" do
        User.new.lastfm_state.should == "unverified"
      end
    end

    describe "transitions" do
      describe "verify" do
        [:unverified, :unauthorized, :inactive].each do |state|
          let(:user) { build(:user, :lastfm_state => state.to_s) }
          it "should verify from #{state}" do
            user.verify_lastfm!
            user.lastfm_state.should == "verified"
          end
        end
      end

      describe "deauthorize" do
        [:unverified, :verified].each do |state|
          let(:user) { build(:user, :lastfm_state => state.to_s) }
          it "should deauthorize from #{state}" do
            user.deauthorize_lastfm!
            user.lastfm_state.should == "unauthorized"
          end
        end
      end

      describe "deactivate" do
        [:unverified, :verified].each do |state|
          let(:user) { build(:user, :lastfm_state => state.to_s) }
          it "should deactivate from #{state}" do
            user.deactivate_lastfm!
            user.lastfm_state.should == "inactive"
          end
        end
      end
    end
  end
end


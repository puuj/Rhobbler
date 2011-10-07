require "spec_helper"

describe RhapsodyVerifyJob do
  let(:user)  { build(:user, :rhapsody_state => "unverified") }

  describe "perform" do
    before(:each) do
      User.should_receive(:find).once.with(user.id).and_return(user)
    end

    it "should verify user if Rhapsody didn't throw an error" do
      Rhapsody.should_receive(:fetch_listening_history).once.
        with(user.rhapsody_username).
        and_return("success")
      RhapsodyVerifyJob.new.perform(user.id)

      user.rhapsody_verified?.should be_true
    end

    it "should deauthorize user if Rhapsody throws a RhapsodyUserNotAuthorizedError" do
      Rhapsody.should_receive(:fetch_listening_history).once.
        with(user.rhapsody_username).
        and_raise(RhapsodyUserNotAuthorizedError)

      lambda {
        RhapsodyVerifyJob.new.perform(user.id)
      }.should raise_error(
        RhapsodyUserNotAuthorizedError,
        "Could not gain access to listening history for user #{user.id} with Rhapsody member ID of #{user.rhapsody_username}"
      )

      user.rhapsody_unauthorized?.should be_true
    end

    it "should deactivate user if Rhapsody throws an RhapsodyUserNotFoundError" do
      Rhapsody.should_receive(:fetch_listening_history).once.
        with(user.rhapsody_username).
        and_raise(RhapsodyUserNotFoundError)
      RhapsodyVerifyJob.new.perform(user.id)

      user.rhapsody_inactive?.should be_true
    end
  end

  describe "enqueue" do
    before(:each) do
      ResqueSpec.reset!
    end

    it "should enqueue a user id" do
      RhapsodyVerifyJob.enqueue(14)
      RhapsodyVerifyJob.should have_queued(14)
    end
  end
end

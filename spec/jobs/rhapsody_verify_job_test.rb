require "spec_helper"

describe RhapsodyVerifyJob do
  it "should verify user if Rhapsody didn't throw an error" do
    user_stub = stub_model(User)
    Rhapsody.should_receive(:fetch_listening_history).once.
      with(user.rhapsody_username).
      and_return("success")

    RhapsodyVerifyJob.perform(user_stub.id)

    user_stub.verified.should be_true
  end
end

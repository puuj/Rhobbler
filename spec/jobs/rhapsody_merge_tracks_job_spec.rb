require "spec_helper"

describe RhapsodyMergeTracksJob do
  it "should be in the rhapsody queue" do
    RhapsodyMergeTracksJob.instance_variable_get(:@queue).should == :rhapsody
  end

  describe "perform" do
    let(:user) { Factory(:user, :rhapsody_state => 'verified') }

    it "should not add any tracks if given an empty set of tracks" do
      Rhapsody.
        should_receive(:fetch_listening_history).
        once.with(user.rhapsody_username).
        and_return({})

      RhapsodyMergeTracksJob.new.perform(user.id)
      Listen.count.should == 0
    end

    it "should deauthorize user if RhapsodyUserNotAuthorizedError is raised" do
      Rhapsody.
        should_receive(:fetch_listening_history).
        once.with(user.rhapsody_username).
        and_raise(RhapsodyUserNotAuthorizedError)

      RhapsodyMergeTracksJob.new.perform(user.id)
      Listen.count.should == 0

      user.reload
      user.rhapsody_unauthorized?.should be_true
    end
  end

  describe "enqueue" do
    before(:each) do
      ResqueSpec.reset!
    end

    it "should enqueue a user id" do
      RhapsodyMergeTracksJob.enqueue(14)
      RhapsodyMergeTracksJob.should have_queued(14)
    end
  end
end

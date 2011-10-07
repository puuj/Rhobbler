require "spec_helper"

describe RhapsodyMergeTracksJob do
  it "should be in the rhapsody queue" do
    RhapsodyMergeTracksJob.instance_variable_get(:@queue).should == :rhapsody
  end

  describe "perform" do
    let(:user) { stub_model(User, :rhapsody_state => 'verified') }

    before(:each) do
      User.should_receive(:find).
        once.with(user.id).
        and_return(user)
    end

    it "should not add any tracks if given an empty set of tracks" do
      Rhapsody.
        should_receive(:fetch_listening_history).
        once.with(user.rhapsody_username).
        and_return([])

      RhapsodyMergeTracksJob.new.perform(user.id)
      Listen.count.should == 0
    end

    it "should add a listen if given data for it" do
      track = {
        :date    =>  Date.today,
        :title    => "Test Track",
        :track_id => "Tra.12345",
        :artist   => "An Artist"
      }
      history = [track]

      Rhapsody.
        should_receive(:fetch_listening_history).
        once.with(user.rhapsody_username).
        and_return(history)

      Listen.should_receive(:merge).
        once.with(history).
        and_return(true)

      RhapsodyMergeTracksJob.new.perform(user.id)
    end

    it "should deauthorize user if RhapsodyUserNotAuthorizedError is raised" do
      Rhapsody.
        should_receive(:fetch_listening_history).
        once.with(user.rhapsody_username).
        and_raise(RhapsodyUserNotAuthorizedError)
      Listen.should_not_receive(:create)
      user.should_receive(:deauthorize_rhapsody!).once
      user.should_receive(:save).once

      RhapsodyMergeTracksJob.new.perform(user.id)
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

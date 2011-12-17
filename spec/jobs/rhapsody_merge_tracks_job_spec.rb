require "spec_helper"

describe RhapsodyMergeTracksJob do
  it "should be in the rhapsody queue" do
    RhapsodyMergeTracksJob.instance_variable_get(:@queue).should == :rhapsody
  end

  describe "perform" do
    let(:user) { stub_model(User, :rhapsody_state => 'verified') }

    before(:each) do
      Resque.redis.del(:delayed_queue_schedule)
      User.should_receive(:find).
        once.with(user.id).
        and_return(user)
    end

    describe "with an empty set of listens" do
      before(:each) do
        Rhapsody.
          should_receive(:fetch_listening_history).
          once.with(user.rhapsody_username).
          and_return([])
      end

      it "should not call User.merge_listens" do
        user.should_not_receive(:merge_listens)
        RhapsodyMergeTracksJob.new.perform(user.id)
      end

      it "should add an item to the delayed queue 1 hour from now" do
        Timecop.freeze do
          RhapsodyMergeTracksJob.new.perform(user.id)
          time = Resque.redis.zrange(:delayed_queue_schedule, 0, 1).first
          time.to_i.should eql(1.hour.from_now.to_i)
        end
      end
    end

    describe "with a single track" do
      let(:listens) { ["I AM NOT EMPTY"] }

      before(:each) do
        Rhapsody.
          should_receive(:fetch_listening_history).
          once.with(user.rhapsody_username).
          and_return(listens)
      end

      it "should call user.merge_listens" do
        user.should_receive(:merge_listens).
          once.with(listens).
          and_return(true)

        RhapsodyMergeTracksJob.new.perform(user.id)
      end

      it "should add an item to the delayed queue 10 minutes from now" do
        user.stub(:merge_listens)

        Timecop.freeze do
          RhapsodyMergeTracksJob.new.perform(user.id)
          time = Resque.redis.zrange(:delayed_queue_schedule, 0, 1).first
          time.to_i.should eql(10.minutes.from_now.to_i)
        end
      end
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

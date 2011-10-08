require "spec_helper"

describe LastfmSubmissionJob do
  it "should be in the lastfm queue" do
    LastfmSubmissionJob.instance_variable_get(:@queue).should == :lastfm
  end

  describe "perform" do
    let(:user) { build(:user, :lastfm_state => 'verified') }
    let(:listen) { build(:listen, :user => user) }

    before(:each) do
      Listen.should_receive(:find).
        once.with(listen.id).
        and_return(listen)
    end

    it "should attempt to scrobble" do
      Timecop.freeze do
        track_mock = mock(Rockstar::Track)
        track_mock.should_receive(:scrobble).
          once.with(Time.now, user.session_key)

        Rockstar::Track.
          should_receive(:new).
          once.with(listen.artist, listen.title).
          and_return(track_mock)

        LastfmSubmissionJob.new.perform(listen.id)
      end
    end
  end

  describe "enqueue" do
    before(:each) do
      ResqueSpec.reset!
    end

    it "should enqueue a listen id" do
      LastfmSubmissionJob.enqueue(14)
      LastfmSubmissionJob.should have_queued(14)
    end
  end
end

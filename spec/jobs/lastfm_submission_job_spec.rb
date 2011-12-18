require "spec_helper"

describe LastfmSubmissionJob do
  it "should be in the lastfm queue" do
    LastfmSubmissionJob.instance_variable_get(:@queue).should == :lastfm
  end

  describe "perform" do
    let(:user) { Factory(:user, :lastfm_state => 'verified') }
    let(:listen) { Factory(:listen, :user => user) }

    before(:each) do
      Timecop.freeze(Time.now)
      track_mock = mock(Rockstar::Track)
      track_mock.should_receive(:scrobble).
        once.with(Time.now, user.session_key).
        and_return("success")

      Rockstar::Track.
        should_receive(:new).
        once.with(listen.artist, listen.title).
        and_return(track_mock)
    end

    after(:each) do
      Timecop.return
    end

    it "should attempt to scrobble" do
      LastfmSubmissionJob.perform(listen.id).should == "success"
    end

    it "should update user" do
      user.deactivate_lastfm!
      LastfmSubmissionJob.perform(listen.id)

      user.reload
      user.lastfm_verified?.should be_true
    end

    it "should update track" do
      LastfmSubmissionJob.perform(listen.id)

      listen.reload
      listen.submitted?.should be_true
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

require "spec_helper"

describe Listen do
  describe "relationships" do
    it "should have a user relationship" do
      Listen.new.should respond_to(:user)
    end

    it "should allow setting of user" do
      user_stub = stub_model(User)
      Listen.new(:user => user_stub).user_id.should == user_stub.id
    end
  end

  describe "validations" do
    describe "user_id" do
      it "fails validation when no user_id" do
        Listen.new.should have(1).errors_on(:user_id)
      end

      it "passes validation when supplied user_id" do
        Listen.new(:user_id => 1).should have(0).errors_on(:user_id)
      end
    end

    describe "track_id" do
      it "fails validation when no track_id" do
        Listen.new.should have(1).errors_on(:track_id)
      end

      it "passes validation when given track_id" do
        Listen.new(:track_id => "12345").should have(0).errors_on(:track_id)
      end
    end

    describe "artist" do
      it "fails validation when no artist" do
        Listen.new.should have(1).errors_on(:artist)
      end

      it "passes validation when given artist" do
        Listen.new(:artist => "12345").should have(0).errors_on(:artist)
      end
    end

    describe "title" do
      it "fails validation when no title" do
        Listen.new.should have(1).errors_on(:title)
      end

      it "passes validation when given title" do
        Listen.new(:title => "12345").should have(0).errors_on(:title)
      end
    end

    describe "played_at" do
      it "fails validation when no played_at" do
        Listen.new.should have(1).errors_on(:played_at)
      end

      it "passes validation when given played_at" do
        Listen.new(:played_at => Time.now).should have(0).errors_on(:played_at)
      end

      describe "uniqueness" do
        let(:original) { original = Factory(:listen) }

        it "fails validation when another record with same played_at, user_id, track_id combo" do
          Listen.new(
            :played_at => original.played_at,
            :user_id => original.user_id,
            :track_id => original.track_id
          ).should have(1).errors_on(:played_at)
        end

        it "passes validation when another record with same user_id, track_id combo" do
          Listen.new(
            :played_at => original.played_at + 1.second,
            :user_id => original.user_id,
            :track_id => original.track_id
          ).should have(0).errors_on(:played_at)
        end
      end
    end

    describe "state" do
      it "fails validation when state is explicitly nil" do
        Listen.new(:state => nil).should have(2).errors_on(:state)
      end

      it "fails validation when invalid state" do
        Listen.new(:state => "foo").should have(1).errors_on(:state)
      end

      it "passes validation when no state is given" do
        Listen.new.should have(0).errors_on(:state)
      end

      it "passes validation when state is explicitly set" do
        Listen.new(:state => 'submitted').should have(0).errors_on(:state)
      end

      it "moves to submitted upon submit event" do
        listen = Factory(:listen, :state => 'unsubmitted')
        listen.submit!
        listen.submitted?.should be_true
      end
    end
  end

  it "enqueues LastfmSubmissionJob on submit_to_lastfm" do
    listen = stub_model(Listen)
    LastfmSubmissionJob.should_receive(:enqueue).
      once.with(listen.id)
    listen.submit_to_lastfm
  end
end


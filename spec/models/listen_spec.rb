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

    describe "date" do
      it "fails validation when no date" do
        Listen.new.should have(1).errors_on(:date)
      end

      it "passes validation when given date" do
        Listen.new(:date => Date.today).should have(0).errors_on(:date)
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
    end
  end
end


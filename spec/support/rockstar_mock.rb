def mock_session(token="ATOKEN", key="ASESSIONKEY", username="AUSERNAME")
  mock_session = mock(Rockstar::Session)
  mock_session.stub(:key).and_return(key)
  mock_session.should_receive(:username).at_least(1).times.and_return(username)
  Rockstar::Auth.any_instance.stub(:session).with(token).and_return(mock_session)
end

def mock_no_session(token="ATOKEN")
  Rockstar::Auth.any_instance.stub(:session).with(token).and_raise(NoMethodError)
end

def mock_token(token="ATOKEN")
  Rockstar::Auth.any_instance.stub(:token).and_return(token)
end

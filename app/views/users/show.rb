module Users
  class Show < Stache::View
    include InstructionImages

    def registration_next_url
      user_path(@user)
    end

    def recent_scrobbles
      listens = @user.listens.
        with_state(:submitted).
        order('updated_at DESC').
        limit(10)

      listens.map do |listen|
        {
          :artist => listen.artist,
          :title  => listen.title,
          :date   => l(listen.updated_at, :format => :db)
        }
      end
    end
  end
end


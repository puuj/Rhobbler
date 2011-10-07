module Resque
  module Plugins
    module Enqueue
      def enqueue(user_id)
        Resque.enqueue(self, user_id)
      end
    end
  end
end

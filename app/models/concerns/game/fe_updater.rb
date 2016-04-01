module Game
  module FEUpdater
    extend ActiveSupport::Concern

    included do
      after_save :broadcast_updates

      private

      def broadcast_updates
        ActionCable.server.broadcast self.class.name.pluralize.underscore, id => to_json(methods: include_in_to_json)
      end
    end
  end
end

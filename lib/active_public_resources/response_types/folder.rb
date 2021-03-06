module ActivePublicResources
  module ResponseTypes
    class Folder < BaseResponseType
      attr_accessor :parent_id, :videos, :exercises, :images

      def initialize
        super
        @videos    = []
        @exercises = []
        @images    = []
      end

      def kind
        'folder'
      end
    end
  end
end

module Bold
  module Flickr
    module AssetsControllerPatch

      def self.apply
        unless Bold::AssetsController < self
          Bold::AssetsController.prepend self
        end
      end

      def self.prepended(base)
        base.class_eval do
          helper :flickr
        end
      end

      private

      def valid_source?(source)
        super || 'flickr' == source
      end

    end
  end
end

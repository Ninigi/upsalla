module Upsalla
  class XMLParser
    require "gyoku"

    class << self
      def parse(hash)
        raw = Gyoku.xml(hash, key_converter: :camelcase)

        ["<?xml version=\"1.0\" ?>", raw].join
      end
    end
  end
end

module Upsalla
  module StringHelper
    def snake_case(string)
      return string.downcase if string.match(/\A[A-Z]+\z/)

      string.
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z])([A-Z])/, '\1_\2').
        downcase
    end

    def demodulize(string)
      if i = string.rindex("::")
        string[(i+2)..-1]
      else
        string
      end
    end
  end
end

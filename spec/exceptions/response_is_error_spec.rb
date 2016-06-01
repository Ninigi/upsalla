require "spec_helper"

RSpec.describe Upsalla::ResponseIsError do
  include Upsalla::StringHelper

  describe ".new(<#Hash>)" do
    it "should set the keys as attributes" do
      error_hash = {
        some_message: "Some Message",
        "SomeOtherMessage" => "Some Other Message",
        "ErrorDescription" => "A very fine error, indeed."
      }

      error = described_class.new error_hash

      error_hash.each do |key, value|
        expect(error).to respond_to(snake_case key.to_s)
        expect(error.send snake_case(key.to_s)).to eq value
      end
    end
  end
end

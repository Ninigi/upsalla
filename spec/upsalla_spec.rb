require "spec_helper"

describe Upsalla do
  it "has a version number" do
    expect(Upsalla::VERSION).not_to be nil
  end

  %i[@api_key @api_user @api_password].each do |instanve_var|
    it "should set #{instanve_var}" do
      expect(described_class.instance_variable_get instanve_var).not_to be_nil
    end
  end
end

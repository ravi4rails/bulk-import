require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "validations" do
    let(:company) { FactoryBot.build_stubbed(:company) }

    it "is valid with valid attributes" do
      expect(company).to be_valid
    end

    it "is not valid without a name" do
      company.name = nil
      expect(company).not_to be_valid
    end
  end
end

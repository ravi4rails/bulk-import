require 'rails_helper'

RSpec.describe Policy, type: :model do
  describe "validations" do
    let!(:policy) { FactoryBot.create(:policy) }

    it "is valid with valid attributes" do
      expect(policy).to be_valid
    end

    it "is not valid without a name" do
      policy.name = nil
      expect(policy).not_to be_valid
    end

    it "is not valid without a company" do
      policy.company = nil
      expect(policy).not_to be_valid
    end

    context "when name is unique" do
      let(:second_policy) { FactoryBot.build_stubbed(:second_policy) }
      it {expect(second_policy).to be_valid}
    end

    context "when name is not unique" do
      let(:policy_with_same_name) { FactoryBot.build_stubbed(:policy_with_same_name) }
      it {expect(policy_with_same_name).to be_invalid}
    end
  end

  describe "associations" do
    it { should belong_to(:company) }
    it { should have_and_belong_to_many(:employees) }
  end
end

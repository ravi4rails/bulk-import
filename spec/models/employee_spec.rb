require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe "validations" do
    let!(:employee) { FactoryBot.create(:employee) }

    it "is valid with valid attributes" do
      expect(employee).to be_valid
    end

    it "is not valid without a name" do
      employee.name = nil
      expect(employee).not_to be_valid
    end

    it "is not valid without a email" do
      employee.email = nil
      expect(employee).not_to be_valid
    end

    it "is not valid without a company" do
      employee.company = nil
      expect(employee).not_to be_valid
    end

    context "when email is unique" do
      let(:second_employee) { FactoryBot.build_stubbed(:second_employee) }
      it {expect(second_employee).to be_valid}
    end

    context "when email is not unique" do
      let(:employee_with_same_email) { FactoryBot.build_stubbed(:employee_with_same_email) }
      it {expect(employee_with_same_email).to be_invalid}
    end
  end

end

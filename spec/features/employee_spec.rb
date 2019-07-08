require 'rails_helper'

describe 'Employee' do
  let(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, scope: :user)
  end

  describe 'index' do
    before do
      visit employees_path
    end

    it 'can be reached successfully' do
      expect(page.status_code).to eq(200)
    end

    it 'has a title of Employees' do
      expect(page).to have_content(/Employees/)
    end

    it 'has a list of employees' do
      FactoryBot.create(:employee)
      FactoryBot.create(:second_employee)
      visit employees_path
      expect(page).to have_content(/Ravi|Kumar/)
    end
  end

  describe 'creation' do
    before(:all) do
      FactoryBot.create_list(:multiple_companies, 5)
    end
    before do
      visit new_employee_path
    end

    it 'has a new form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    context 'on submission' do
      before do
        fill_in 'employee[name]', with: 'David Wu'
        fill_in 'employee[email]', with: "david@test.com"
        select('Company No 2', from: 'Company')
        click_on "Create Employee"
      end

      it 'can be created from new form page' do
        expect(page).to have_content(/David Wu/)
      end

      it 'will belong to a company associated with it' do
        expect(Employee.last.company.name).to eq('Company No 2')
      end
    end
  end

  describe 'edit' do
    before(:all) do
      FactoryBot.create_list(:multiple_companies, 5)
    end

    let!(:employee) { FactoryBot.create(:employee) }

    it 'can be reached by clicking Edit on index page' do
      visit employees_path

      click_link("edit_#{employee.id}")
      expect(page.status_code).to eq(200)
    end

    it 'can be edited' do
      visit edit_employee_path(employee)

      fill_in 'employee[name]', with: 'Clancy Yang'
      select('Company No 2', from: 'Company')
      click_on "Update Employee"

      expect(page).to have_content("Clancy Yang")
      expect(page).to have_content("Company No 2")
    end

  end
end

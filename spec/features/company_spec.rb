require 'rails_helper'

describe 'Company' do
  let(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, scope: :user)
  end

  describe 'index' do
    before do
      visit companies_path
    end

    it 'can be reached successfully' do
      expect(page.status_code).to eq(200)
    end

    it 'has a title of Companies' do
      expect(page).to have_content(/Companies/)
    end

    it 'has a list of companies' do
      FactoryBot.build_stubbed(:company)
      FactoryBot.build_stubbed(:second_company)
      visit companies_path
      expect(page).to have_content(/My|New/)
    end
  end

  describe 'creation' do
    before do
      visit new_company_path
    end

    it 'has a new form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    it 'can be created from new form page' do
      fill_in 'company[name]', with: 'ABC Inc'
      click_on "Create Company"

      expect(page).to have_content("ABC Inc")
    end
  end

  describe 'edit' do
    let!(:company) { FactoryBot.create(:company) }

    it 'can be reached by clicking Edit on index page' do
      visit companies_path

      click_link("edit_#{company.id}")
      expect(page.status_code).to eq(200)
    end

    it 'can be edited' do
      visit edit_company_path(company)

      fill_in 'company[name]', with: 'XYZ Inc'
      click_on "Update Company"

      expect(page).to have_content("XYZ Inc")
    end

  end
end

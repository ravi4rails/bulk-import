require 'rails_helper'

describe 'Policy' do
  let(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, scope: :user)
  end

  describe 'index' do
    before do
      visit policies_path
    end

    it 'can be reached successfully' do
      expect(page.status_code).to eq(200)
    end

    it 'has a title of Policies' do
      expect(page).to have_content(/Policies/)
    end

    it 'has a list of policies' do
      FactoryBot.create(:policy)
      FactoryBot.create(:second_policy)
      visit policies_path
      expect(page).to have_content(/Casual|Sick/)
    end
  end

  describe 'creation' do
    before(:all) do
      FactoryBot.create_list(:multiple_companies, 5)
    end
    before do
      visit new_policy_path
    end

    it 'has a new form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    context 'on submission' do
      before do
        fill_in 'policy[name]', with: 'HR Policy'
        select('Company No 5', from: 'Company')
        click_on "Create Policy"
      end
      it 'can be created from new form page' do
        expect(page).to have_content(/HR Policy/)
      end

      it 'will belong to a company associated with it' do
        expect(Policy.last.company.name).to eq('Company No 5')
      end
    end
  end

  describe 'edit' do
    before(:all) do
      FactoryBot.create_list(:multiple_companies, 5)
    end

    let!(:policy) { FactoryBot.create(:policy) }

    it 'can be reached by clicking Edit on index page' do
      visit policies_path

      click_link("edit_#{policy.id}")
      expect(page.status_code).to eq(200)
    end

    it 'can be edited' do
      visit edit_policy_path(policy)

      fill_in 'policy[name]', with: 'Paternity Leave Policy'
      select('Company No 2', from: 'Company')
      click_on "Update Policy"

      expect(page).to have_content("Paternity Leave Policy")
      expect(page).to have_content("Company No 2")
    end

  end
end

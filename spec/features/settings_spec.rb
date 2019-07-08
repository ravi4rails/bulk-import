require 'rails_helper'

describe 'Settings' do
  let(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, scope: :user)
  end

  describe 'new bulk import' do
    before(:all) do
      FactoryBot.create_list(:multiple_companies, 5)
    end
    before do
      visit settings_new_import_path
    end

    it 'has a bulk import form that can be reached successfully' do
      expect(page.status_code).to eq(200)
    end

    describe 'import data on submission' do
      let(:csv_file) { 'spec/fixtures/valid_sample.csv' }

      context 'without error' do
        before do
          select('Company No 1', from: 'Company')
          attach_file('CSV File', csv_file)
        end

        it 'can import records from new bulk import page' do
          click_button "Import Data"
          expect(page.status_code).to eq(200)
        end

        it 'can increase Employee and Policy count' do
          expect{
            click_button "Import Data"
          }.to change{ Employee.count }.by(3).and \
               change{ Policy.count }.by(3)
        end

      end
    end

  end
end

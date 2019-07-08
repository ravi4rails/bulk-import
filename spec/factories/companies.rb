FactoryBot.define do
  factory :company do
    name { 'My Company' }
  end
  factory :second_company, class: Company do
    name { 'Second Company' }
  end
  factory :multiple_companies, class: Company do
    sequence(:name) { |n| "Company No #{n}" }
  end
end

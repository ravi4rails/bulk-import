FactoryBot.define do
  factory :policy do
    name { 'Casual Leave' }
    company
  end

  factory :second_policy, class: 'Policy' do
    name { 'Sick Leave' }
    company
  end

  factory :policy_with_same_name, class: 'Policy' do
    name { 'Casual Leave' }
    company
  end
end

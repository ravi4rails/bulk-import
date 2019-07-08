FactoryBot.define do
  factory :employee do
    name { 'Ravi Singh' }
    email { 'ravi@gmail.com' }
    company
  end

  factory :second_employee, class: Employee do
    name { 'Anand Kumar' }
    email { 'anand@email.com' }
    company
  end

  factory :employee_with_same_email, class: Employee do
    name { 'Ravi Sharma' }
    email { 'ravi@gmail.com' }
    company
  end
end

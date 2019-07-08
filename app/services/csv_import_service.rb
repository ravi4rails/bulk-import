class CsvImportService
  require 'csv'

  attr_accessor :file, :company_id

  def initialize(file, company_id)
    @file = file
    @company_id = company_id
    @response = { warnings: {}, new_employees_imported: 0, new_policies_imported: 0 }
  end

  def import
    CSV.foreach(file.path, headers: true, skip_blanks: true).with_index do |row, index|
      process_row(row.to_h, index+1)
    end
    @response
  end

  private

  def process_row(row, row_number)
    if valid_row?(row, row_number)
      employee_policies = get_employee_policies(row["Assigned Policies"].split("|"))
      create_employee(row, employee_policies)
    end
  end

  def valid_row?(row, row_number)
    if employee_exists?(row["Email"])
      @response[:warnings]["Row #{row_number}"] = "#{row["Email"]} already exists"
    elsif !manager_exists?(row["Report To"])
      @response[:warnings]["Row #{row_number}"] = "Manager with email #{row["Report To"]} does not exist"
    end

    @response[:warnings].empty?
  end

  def get_employee_policies(policies_raw)
    employee_policies = []
    policies_raw.each do |policy|
      employee_policies << get_policy_id(policy)
    end
    employee_policies
  end

  def get_policy_id(policy)
    saved_policy = Policy.find_by_name(policy)
    saved_policy ? saved_policy.id : create_policy(policy, company_id)
  end

  def create_policy(policy, company_id)
    new_policy = Policy.create!(name: policy, company_id: company_id)
    @response[:new_policies_imported] += 1
    new_policy.id
  end

  def create_employee(row, employee_policies)
    unless employee_exists?(row["Email"])
      Employee.create!(
        name: row["Employee Name"],
        email: row["Email"],
        phone: row["Phone"],
        parent_id: get_manager_id(row["Report To"]),
        company_id: company_id,
        policy_ids: employee_policies
      )
      @response[:new_employees_imported] += 1
    end
  end

  def manager_exists?(email)
    is_boss?(email) || employee_exists?(email)
  end

  def employee_exists?(email)
    Employee.where(email: email).exists?
  end

  def get_manager_id(email)
    is_boss?(email) ? nil : Employee.find_by_email(email).id
  end

  def is_boss?(email)
    email.nil? or email.empty?
  end
end

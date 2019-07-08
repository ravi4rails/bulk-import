module CsvImportable
  extend ActiveSupport::Concern

  def import_data(file, company_id)
    import_service = CsvImportService.new(file, company_id)
    response = import_service.import
    prepare_message(response)
  end

  def prepare_message(response)
    message = ''
    message += "#{response[:new_employees_imported]} New employees imported.<br/>"
    message += "#{response[:new_policies_imported]} New policies imported.<br/>"
    unless response[:warnings].empty?
      message += "<b>Warnings:</b><br/>"
      message += response[:warnings].map {|k, v| "#{k}: #{v}" }.join("<br/>")
    end
  end
end

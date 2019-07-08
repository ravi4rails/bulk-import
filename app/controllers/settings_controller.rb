class SettingsController < ApplicationController
  include CsvImportable

  def new_import
  end

  def create_import
    if params[:csv_file].content_type == "text/csv"
      import_response = import_data(params[:csv_file], params[:company_id])
      redirect_to companies_path, alert: import_response
    else
      redirect_to settings_new_bulk_import_path, error: "Please upload a valid csv file"
    end
  end
end

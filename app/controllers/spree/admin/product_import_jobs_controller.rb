class Spree::Admin::ProductImportJobsController < Spree::Admin::BaseController

  def index
    @product_import_jobs = collection
  end

  def create
    @product_import_job = collection.new(product_import_job_params)

    if @product_import_job.save
      @product_import_job.perform_async
      redirect_to admin_product_import_jobs_path, notice: 'Sent to worker'
    else
      redirect_to admin_product_import_jobs_path, notice: 'Unsupported file'
    end
  end

  def original_file
    @product_import = resource

    send_file(@product_import.input_file.current_path)
  end

  def errors_file
    @product_import = resource

    send_file(@product_import.errors_file.current_path)
  end

  private

    def collection
      ProductImportJob.all
    end

    def resource
      collection.find(params[:id])
    end

    def product_import_job_params
      params.require(:product_import_job).permit(
        :input_file
      )
    end
end

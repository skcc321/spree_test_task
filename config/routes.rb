Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Spree::Core::Engine.add_routes do
  namespace :admin do
    get "/product_import_jobs", to: "product_import_jobs#index"
    post "/product_import_jobs", as: :create_product_import_job, to:"product_import_jobs#create"
    get "/product_import_job/:id/original_file", as: :product_import_job_original_file, to:"product_import_jobs#original_file"
    get "/product_import_job/:id/errors_file", as: :product_import_job_errors_file, to:"product_import_jobs#errors_file"
  end
end

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :handle_general_exceptions

    rescue_from ActiveRecord::RecordNotFound do |exception|
      handle_exceptions(exception, 'Record you are looking for is not found', :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      handle_exceptions(exception, 'Something went wrong with your data entry', :unprocessable_entity)
    end
  end

  private

  def handle_exceptions(exception, message, status)
    raise exception if Rails.env.development?

    respond_to do |format|
      format.json { render json: { errors: message }, status: status }
    end
  end
end

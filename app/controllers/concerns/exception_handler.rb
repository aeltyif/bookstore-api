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

  def handle_general_exceptions(exception)
    handle_exceptions(exception, 'Something went wrong', :internal_server_error)
  end

  def handle_exceptions(exception, message, status)
    raise exception if Rails.env.development?

    render json: { errors: message }, status: status
  end
end

require 'token_authenticator'

class Api::V1::ApplicationController < ApplicationController
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound do |exception|
    handle_error(:not_found, 'The specified resource was not found')
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    handle_error(:unprocessable_entity, 'Invalid or missing parameters')
  end

  rescue_from TokenAuthenticator::ServiceUnavailableError do |exception|
    handle_error(:service_unavailable, 'Authentication failed')
  end

  def current_user
    @current_user ||= authenticate_with_http_token do |token, _|
      if ENV['TOKENS_URL'].present?
        find_or_create_user_by_tokens_api(token)
      else
        User.find_by(access_token: token)
      end
    end
  end

  def find_or_create_user_by_tokens_api(token)
    storage_limit = TokenAuthenticator.new(token).call
    return unless storage_limit
    user = User.find_by(access_token: token)
    if user
      return user if user.storage_limit == storage_limit
      user.update_columns(storage_limit: storage_limit)
      user
    else
      User.create!(access_token: token, storage_limit: storage_limit)
    end
  end

  def handle_error(status, message)
    render status: status, json: { "error" => {
      "reason"  => status.upcase,
      "details" => message
      }
    }
  end
end

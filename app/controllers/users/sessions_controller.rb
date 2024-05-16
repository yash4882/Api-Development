# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, options={})
    respond json: {
      status: :ok,
      data: {code: 200, message: 'user sign in successfully', data: resource }
    }
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    debugger
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
        status: 200,
        message: 'Signed Out Successfully'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: 'User Has No Active Session'
      }, status: :unauthorized
    end
  end
  # def respond_to_on_destroy
  #   token = request.headers['Authorization']&.split(' ')&.last

  #   if token.blank?
  #     render json: { status: 400, message: 'Token is missing' }, status: :bad_request
  #     return
  #   end

  #   # Check if the token is correctly formatted
  #   unless token.count('.') == 2
  #     render json: { status: 400, message: 'Token is not correctly formatted' }, status: :bad_request
  #     return
  #   end

  #   begin
  #     jwt_payload = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base)).first
  #     current_user = User.find_by(id: jwt_payload['sub'])
  #   rescue JWT::DecodeError => e
  #     render json: { status: 401, message: "Invalid token: #{e.message}" }, status: :unauthorized
  #     return
  #   end

  #   if current_user
  #     render json: {
  #       status: 200,
  #       message: 'Signed out successfully'
  #     }, status: :ok
  #   else
  #     render json: {
  #       status: 401,
  #       message: 'User has no active session'
  #     }, status: :unauthorized
  #   end
  # end

end

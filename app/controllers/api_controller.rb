class ApiController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }

  skip_before_action :authenticate_user!

  before_action :authenticate_request!, except: [:authenticate_user]

  attr_reader :current_user


  # GET /api/children
  def children

    @children = Child.all
    @children.order!(:first_name, :last_name)

    respond_to do |format|
      format.any {
        render json: @children,
        content_type: 'application/json'
      }
    end

  end


  # POST /api/sign_ins/create
  def create_sign_in

    @sign_in = SignIn.new(sign_in_params)

    if !@sign_in.child.nil?
      @sign_in.first_name = @sign_in.child.first_name
      @sign_in.last_name  = @sign_in.child.last_name
    end

    if @sign_in.save
      render status: 200, json: {
        message: "Successfully created sign_in record.",
        id: @sign_in.id
      }.to_json
    else
      render status: 500, json: {
        errors: @sign_in.errors
      }.to_json
    end
  end


  # POST /api/authenticate_user
  def authenticate_user
    user = User.find_for_database_authentication(email: params[:email])
    if user && user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
    end
  end


protected
  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end


private

  def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600}),
      user: {id: user.id, email: user.email}
    }
  end


  # Parameter white list
  def sign_in_params
    params
      .permit(
        :first_name,
        :last_name,
        :room,
        :sign_in_time,
        :newcomer,
        :label,
        :child_id
      )
  end

end

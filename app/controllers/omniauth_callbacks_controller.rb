class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  include DeviseTokenAuth::Concerns::SetUserByToken

  def facebook_login
    get_resource_from_auth_hash
    create_token_info
    set_token_on_resource
    create_auth_params

    if resource_class.devise_modules.include?(:confirmable)
      # don't send confirmation email!!!
      @resource.skip_confirmation!
    end


    @resource.save!

    sign_in(:user, @resource, store: false, bypass: false)

    yield if block_given?
    render_create_success
    update_auth_header
  end

  #########
  protected
  #########

  def update_auth_header
    # cannot save object if model has invalid params
    return unless @resource and @resource.valid? and @client_id

    # Generate new client_id with existing authentication
    @client_id = nil unless @used_auth_by_token

    if @used_auth_by_token and not DeviseTokenAuth.change_headers_on_each_request
      auth_header = @resource.build_auth_header(@token, @client_id)

      # update the response header
      response.headers.merge!(auth_header)

    else

      # Lock the user record during any auth_header updates to ensure
      # we don't have write contention from multiple threads
      @resource.with_lock do

        # determine batch request status after request processing, in case
        # another processes has updated it during that processing
        @is_batch_request = is_batch_request?(@resource, @client_id)

        auth_header = {}

        # extend expiration of batch buffer to account for the duration of
        # this request
        if @is_batch_request
          auth_header = @resource.extend_batch_buffer(@token, @client_id)

        # update Authorization response header with new token
        else
          auth_header = @resource.create_new_auth_token(@client_id)

          # update the response header
          response.headers.merge!(auth_header)
        end

      end # end lock

    end

  end

  def render_create_success
    render json: @resource.token_validation_response
  end

 def auth_hash
    @_auth_hash ||= params["auth_hash"]
    @_auth_hash
  end

  def omniauth_params
    if !defined?(@_omniauth_params)
      @_omniauth_params = {"resource_class"=>"User"}
    end
    @_omniauth_params
  end
end

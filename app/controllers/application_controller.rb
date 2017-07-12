class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_action :fluent_before
  # after_action  :fluent_log

  def after_sign_in_path_for(resource)
    member_root_path
  end

  private

  def fluent_before
    @start_time = Time.now
  end

  def fluent_log
    Fluent::Logger::FluentLogger.open(nil, host: 'localhost', port: 24224)
    channel = {
      start_time:   @start_time,
      response:     Time.now - @start_time,
      method:       request.request_method,
      request_path: request.fullpath,
      ip:           request.ip,
      referer:      request.referer,
      UA:           request.user_agent,
      controller:   controller_name,
      action:       action_name,
      params:       params,
      # user:         current_company_user.presence.try(:attributes),
      # company_user_id: current_company_user.presence.try(:id),
      machine:      @machine.try(:attributes),
    }

    Fluent::Logger.post("ekikai", channel)

    # throw channel
  end
end

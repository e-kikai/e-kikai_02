class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # after_action :fluent_log

  def after_sign_in_path_for(resource)
    member_root_path
  end

  # def fluent_log
  #   Fluent::Logger::FluentLogger.open(nil, :host => 'localhost', :port => 24224)
  #   channel = {
  #     time:         Time.now,
  #     method:       request.request_method,
  #     request_path: request.fullpath,
  #     ip:           request.ip,
  #     referer:      request.referer,
  #     UA:           request.user_agent,
  #     controller:   controller_name,
  #     action:       action_name,
  #     params:       params,
  #     user_id:      current_company_user.try(:id),
  #     machine_name:      @machine.try(:name),
  #     test1: { aaa: "bbb", ccc:"ddd"}
  #   }
  #   channel[:test]    = "test"
  #
  #   # if @machine.present?
  #   #   channel[:machine] = {
  #   #     name: @machine.name,
  #   #     maker: @machine.maker,
  #   #     model: @machine.model,
  #   #     addr1: @machine.addr1,
  #   #
  #   #     company_id:   @machine.company_id,
  #   #     company_name: @machine.company.name,
  #   #   }
  #   # end
  #
  #   Fluent::Logger.post("ekikai", channel)
  # end
end

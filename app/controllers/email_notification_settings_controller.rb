class EmailNotificationSettingsController < ApplicationController
  def index
  	@settings = current_user.email_notification_settings
  end
  def update
  	@setting = EmailNotificationSetting.find(params[:id])
  	@setting.timed_task_id =  params[:email_notification_setting][:timed_task_id][1]
  	@setting.save
  	respond_to do |format|
      format.html { redirect_to :back}
    	format.js
    end
  end

end

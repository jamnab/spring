class TimedTask < ActiveRecord::Base
	has_many :email_notification_settings
	
	def self.timed_jobs(unit)
		@tasks = TimedTask.all.where(measure_of_time: unit)
		@tasks.each do |task|
			@settings = task.email_notification_settings
			@settings.each do |setting|
				@type = setting.settings_for
				@user = setting.user	
				@activities = PublicActivity::Activity.where(recipient_id: @user.id)
				@activities = @activities.where(trackable_type: @type)
				@activities = @activities.where(collected: false)
				if !(@activities.empty?)
						
					Notifier.notification_update(@user,@activities).deliver!
				
				end
				@activities.each do |act|
					act.collected = true
					act.save
				end
			end
		end
	end
end

class TaskObserver < Mongoid::Observer
	def after_save(task)
		if task.user_id_changed? && task.user_id_was
			user = User.find(task.user_id_was)
			if task.parent_project.creator != user
				user.unfollow(task)
			end
			task.followers.each do |follower|
				notification_body = 	{
					resource_id: task.id,
					recipient_id: follower.id,
					subject: "Assignee changed for \"#{task.title}\" due #{task.due_when}",
					body: "#{task.user.name} got assigned",
					category: 'Task'
				}
				begin
				Pusher.trigger("private-#{follower.id}",
					'new_notification',notification_body)									
			    Notification.create(notification_body)
			   rescue Pusher::HTTPError,MultiJson::ParseError => e
			   	retry
			   end
			
			end
			notification_body = {
					resource_id: task.id,
					recipient_id: task.user_id,
					subject: "You have been assigned a task due #{task.due_when}",
					body: "Details - #{task.title}",
					category: 'Task'
				}
			#unless Rails.env.test?
				begin 
				Pusher.trigger("private-#{task.user_id}",
				'new_notification',notification_body)
					Notification.create(notification_body)
				rescue Pusher::HTTPError => e
			   	retry
			   end
		 	 #end
		end
		if task.status_changed? && task.status_was
				task.followers.each do |follower|
				notification_body = 	{
					resource_id: task.id,
					recipient_id: follower.id,
					subject: "Status changed for task due #{task.due_when}",
					body: "\"#{task.title}\" now has status #{task.status}",
					category: 'Task'
				}
				#unless Rails.env.test?
					begin
					Pusher.trigger("private-#{follower.id}",
						'new_notification',notification_body)				
					Notification.create(notification_body)
					rescue Pusher::HTTPError => e
			   	retry
			   end
				#end	
				end
			end

			 
	end
end

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = JobApplication.find(application_id)
    # Do something later
  end
end

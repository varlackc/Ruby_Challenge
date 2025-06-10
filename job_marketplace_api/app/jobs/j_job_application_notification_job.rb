class JJobApplicationNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    JobApplicationMailer.apply_notification(applicaiton).deliver_now
  end
end

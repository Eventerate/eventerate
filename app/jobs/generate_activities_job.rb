class GenerateActivitiesJob < ApplicationJob
  queue_as :default

  def perform(event_id, age_range, num_activities)
    event = Event.find(event_id)
    begin
      event.generate_activities_from_ai(age_range, num_activities)
      Rails.logger.info("AI activities generated successfully for event #{event_id}")
    rescue Faraday::TooManyRequestsError => e
      Rails.logger.warn("API rate limit for event #{event_id}: #{e.message}. Using predefined activities fallback.")
      event.assign_predefined_activities(age_range, num_activities)
    rescue StandardError => e
      Rails.logger.error("Failed to generate AI activities for event #{event_id}: #{e.message}. Using predefined activities fallback.")
      event.assign_predefined_activities(age_range, num_activities)
    end
  end
end

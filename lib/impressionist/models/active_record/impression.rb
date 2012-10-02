class Impression < ActiveRecord::Base
  attr_accessible :impressionable_type, :impressionable_id, :user_id,
  :controller_name, :action_name, :view_name, :request_hash, :ip_address,
  :session_hash, :message, :referrer

  after_save :update_impressions_counter_cache

  private

  # Charles - commenting out the counter_cache, as we're not using this anywhere.

  def update_impressions_counter_cache
    return unless Object.const_defined? self.impressionable_type
    impressionable_class = self.impressionable_type.constantize
    return unless impressionable_class.is_a? Class

    if impressionable_class.counter_cache_options
      resource = impressionable_class.find(self.impressionable_id)
      resource.try(:update_counter_cache)
    end
  end
end

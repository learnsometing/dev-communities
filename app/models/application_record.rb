# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def formatted_timestamp
    created_at.strftime('%B %e at %l:%M %P')
  end
end

# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def timestamp_formatted
    created_at.strftime("%B %e at %l:%M %P")
  end
end

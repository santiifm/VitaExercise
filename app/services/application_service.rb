# frozen_string_literal: true

class ApplicationService
  attr_reader :error, :success

  def self.exec(*args, &block)
    new(*args, &block).exec
  end
end

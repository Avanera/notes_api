class ApplicationService
  def self.call(**args)
    new(**args).call
  end

  attr_reader :result
  
    def initialize(**context)
      @result = ServiceResult.new
      @context = context
    end
  
  private

  class ServiceResult
    attr_accessor :success, :errors, :data

    def initialize
      @success = true
      @errors = []
      @data = {}
    end

    def success?
      @success
    end

    def failure?
      !@success
    end

    def add_error(message, field: nil, code: nil)
      @success = false
      @errors << { message: message, field: field, code: code }.compact
    end
  end
end

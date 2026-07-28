module Errors
  class Error < StandardError; end

  class Unauthorized < Error; end
  class Forbidden < Error; end
  class NotFound < Error; end
  class UnprocessableEntity < Error; end
  class InternalServerError < Error; end
  class InvalidParams < Error; end
end

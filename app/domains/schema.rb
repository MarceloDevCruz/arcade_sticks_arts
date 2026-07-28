class Schema
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  def validate!
    raise NotImplementedError "validate! not implemented"
  end

  def to_model!
    raise NotImplementedError "to_model! not implemented"
  end

  def to_params
    raise NotImplementedError "to_params not implemented"
  end

  def initialize(attrs = {})
    super
    @errors = ActiveModel::Errors.new(self)
  end
end

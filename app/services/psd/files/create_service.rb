class Psd::Files::CreateService
  include Wisper::Publisher
  include ActiveModel::Validations

  attr_reader :psd_file

  def initialize(params)
    @params = params
    @psd_file = nil
  end

  def call
    schema = Psd::FileSchema.new(@params)
    schema.validate!
    @psd_file = schema.to_model!
    @psd_file.save!
    broadcast(:psd_file_created, @psd_file.id)
    @psd_file
  rescue Errors::InvalidParams => e
    errors.add(:base, e.message)
    broadcast(:psd_file_create_failed, e.errors)
    nil
  rescue StandardError => e
    errors.add(:base, e.message)
    nil
  end

  def error
    errors.full_messages.first
  end
end

class Psd::FileSchema < Schema
  attribute :title, :string
  attribute :description, :string
  attribute :psd, :string

  validates :title, presence: true
  validates :psd, presence: true

  def validate!
    validate
    raise Errors::InvalidParams, errors.full_messages.to_sentence if errors.any?
  end

  def to_model!
    record = ::Psd::File.new(title:, description:)
    record.psd.attach(
      io: StringIO.new(psd),
      filename: "psd_#{Time.current.to_i}.psd",
      content_type: "application/vnd.adobe.photoshop"
    )
    record
  end

  def to_params
    { title:, description:, psd: }
  end
end

class Psd::File < ApplicationRecord
  self.table_name = "psd_files"

  has_one_attached :psd

  validates :title, presence: true
  validates :psd, presence: true

  after_create_commit :parse_psd_data

  private

  def parse_psd_data
    return unless psd.attached?

    begin
      temp_file = psd.download
      psd_obj = ::PSD.new(temp_file)
      psd_obj.parse!

      metadata = {
        width: psd_obj.header.width,
        height: psd_obj.header.height,
        layer_count: psd_obj.tree.descendant_layers.count
      }

      update(metadata: metadata)
    rescue => e
      Rails.logger.error "Erro ao processar PSD: #{e.message}"
    end
  end
end
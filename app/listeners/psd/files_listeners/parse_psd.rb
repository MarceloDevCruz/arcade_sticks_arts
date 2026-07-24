class Psd::FilesListeners::ParsePsd
  def self.psd_file_created(psd_file_id)
    psd_file = Psd::File.find_by(id: psd_file_id)
    return unless psd_file&.psd&.attached?

    process_psd(psd_file)
  rescue StandardError => e
    Rails.logger.error "[ParsePsd] Erro ao processar PSD ##{psd_file_id}: #{e.message}"
  end

  private

  def self.process_psd(psd_file)
    Tempfile.create(["psd", ".psd"]) do |tempfile|
      tempfile.binmode
      tempfile.write(psd_file.psd.download)
      tempfile.rewind

      psd_obj = ::PSD.new(tempfile.path)
      begin
        psd_obj.parse!

        png_bytes = psd_obj.image.to_png.to_blob

        psd_file.preview.attach(
          io: StringIO.new(png_bytes),
          filename: "preview_psd_#{psd_file.id}.png",
          content_type: "image/png"
        )

        psd_file.update!(
          metadata: {
            "width" => psd_obj.header.width.to_i,
            "height" => psd_obj.header.height.to_i,
            "layer_count" => psd_obj.tree.descendant_layers.count.to_i
          }
        )
      ensure
        psd_obj.close
      end
    end
  end
end
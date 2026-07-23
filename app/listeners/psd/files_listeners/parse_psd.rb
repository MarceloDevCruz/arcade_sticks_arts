module Psd
  module FilesListeners
    class ParsePsd
      def self.psd_file_created(psd_file_id)
        psd_file = Psd::File.find(psd_file_id)
        return unless psd_file.psd.attached?

        Tempfile.create(["psd", ".psd"]) do |tempfile|
          tempfile.binmode
          tempfile.write(psd_file.psd.download)
          tempfile.rewind

          psd_obj = ::PSD.new(tempfile.path)
          begin
            psd_obj.parse!

            psd_file.update!(
              metadata: {
                "width" => psd_obj.header.width,
                "height" => psd_obj.header.height,
                "layer_count" => psd_obj.tree.descendant_layers.count
              }
            )
          ensure
            psd_obj.close
          end
        end
      rescue StandardError => e
        Rails.logger.error "Erro ao processar PSD ##{psd_file_id}: #{e.message}"
      end
    end
  end
end

module Psd
  module FilesServices
    class Create
      include Wisper::Publisher

      def initialize(params)
        @domain = Psd::FileSchema.new(params.except(:psd).merge(psd: params.fetch(:psd, nil)))
      end

      def call
        @domain.validate!
        record = @domain.to_model!

        if record.save
          broadcast(:psd_file_created, record.id)
          true
        else
          false
        end
      rescue Errors::InvalidParams => e
        @domain.errors.add(:base, e.message)
        false
      rescue StandardError => e
        @domain.errors.add(:base, e.message)
        false
      end
    end
  end
end

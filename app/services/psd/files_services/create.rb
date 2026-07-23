module Psd
  module FilesServices
    class Create
      include Wisper::Publisher

      attr_reader :psd_file, :error

      def initialize(params)
        @params = params
      end

      def call
        @psd_file = Psd::File.new(@params)

        if @psd_file.save
          broadcast(:psd_file_created, @psd_file.id)
          true
        else
          @error = @psd_file.errors.full_messages.to_sentence
          false
        end
      end
    end
  end
end

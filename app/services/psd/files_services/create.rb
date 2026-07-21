module Psd
  module FilesServices
    class Create
      attr_reader :psd_file

      def initialize(params)
        @params = params
      end

      def call
        @psd_file = Psd::File.new(@params)
        
        if @psd_file.save
          true
        else
          false
        end
      end
    end
  end
end
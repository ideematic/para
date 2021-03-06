module Para
  module Exporter
    class Base < Para::Job::Base
      attr_reader :name, :model, :options

      def perform(model_name: nil, **options)
        @model = model_name && model_name.constantize
        @options = options
        @name = model.try(:model_name).try(:route_key).try(:parameterize)

        # Render file and store it in a Library::File object, allowing us
        # to retrieve that file easily from the job and subsequent requests
        #
        file = Para::Library::File.create!(attachment: render)
        store(:file_gid, file.to_global_id)
      end

      def file
        @file ||= GlobalID::Locator.locate(store(:file_gid))
      end

      def file_name
        @file_name ||= [name, extension].join
      end

      private

      def render
        Tempfile.new([name, extension]).tap do |file|
          file.binmode if binary?
          file.write(generate)
          file.rewind
        end
      end

      def generate
        fail NotImplementedError
      end

      # Default to writing string data to the exported file, allowing
      # subclasses to write binary data if needed
      def binary?
        false
      end

      def total_progress
        resources.length
      end

      # Allow passing a `:resources` option or a ransack search hash to filter
      # exported resources
      #
      def resources
        @resources ||= if options[:resources]
          options[:resources]
        elsif options[:search]
          model.search(options[:search]).result
        else
          model.all
        end
      end

      def encode(string)
        string.presence && string.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
      end
    end
  end
end

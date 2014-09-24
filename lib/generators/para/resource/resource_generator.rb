module Para
  class ResourceGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    argument :component_name, type: :string
    argument :attributes, type: :array

    desc 'Para resource generator'

    def welcome
      say 'Creating resource...'
      puts file_name
      puts component_name
      puts attributes.inspect

    end

    def copy_resource_controller
      template 'resource_controller.rb', "app/controllers/admin/#{plural_file_name}_controller.rb"
    end
  end
end
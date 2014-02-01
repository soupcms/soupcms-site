module SoupCMS
  module Rake
    module Model

      class Yaml < SoupCMS::Rake::Model::Base

        def parse_file
          document_hash = YAML.load(file.read)
          SoupCMS::Rake::ResolveFileReference.new(File.dirname(file)).parse(document_hash)
        end


      end


    end
  end
end

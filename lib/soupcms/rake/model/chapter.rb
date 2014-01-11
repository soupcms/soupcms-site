module SoupCMS
  module Rake
    module Model

      class Chapter < SoupCMS::Rake::Model::Markdown

        def doc_name
          document_name = super
          document_name.match('^[\d]-').post_match
        end

        def chapter_number
          File.basename(file).match('^[\d]')[0].to_i
        end


        def build
          super
          doc['chapter_number'] = chapter_number
          build_chapter_links
        end

        def build_chapter_links
          chapters = Dir.glob(File.join(File.dirname(file), '/*.{json,md}')).to_a
          index = chapters.index(file.path)
          if index > 0
            model = SoupCMS::Rake::Model::Chapter.new(File.new(chapters[index-1]))
            doc['prev_chapter'] = {'label' => model.title, 'link' => {'model_name' => 'chapters', 'match' => {'slug' => model.slug}}}
          end
          if index < (chapters.size-1)
            model = SoupCMS::Rake::Model::Chapter.new(File.new(chapters[index+1]))
            doc['next_chapter'] = {'label' => model.title, 'link' => {'model_name' => 'chapters', 'match' => {'slug' => model.slug}}}
          end
        end


      end


    end
  end
end

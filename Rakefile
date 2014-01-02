require 'soupcms/site'

require 'bundler/gem_tasks'

require 'mongo'
require 'json'

task :seed do
  conn = Mongo::MongoClient.new
  Dir.glob('seed/**/*.{json,md}').each do |afile|
    if afile.include?('ref_files')
      #puts "Ignoring ref file... #{afile}"
    else
      #puts "Importing file... #{afile}"
      begin
        SoupCMSModelBuilder.new(File.new(afile),conn).create()
      rescue => e
        puts "Error importing file... #{afile}"
        puts e
      end
    end
  end
  conn.close
end

task :clean do
  conn = Mongo::MongoClient.new
  %w(www blog docs).each do |app_name|
    db = conn.db(app_name)
    puts "Cleaning up the database...#{app_name}"
    db.collection_names.each { |coll_name|
      next if coll_name.match(/^system/)
      db[coll_name].remove
    }
  end
  conn.close
end


class SoupCMSModelBuilder

  def initialize(file, conn = nil); @file = file; @conn = conn; end
  attr_reader :file, :conn
  def doc_name
    doc_name = File.basename(file).split('.').first.split(';').first
    model == 'chapters' ? doc_name.match('^[\d]-').post_match : doc_name
  end
  def chapter_number; File.basename(file).match('^[\d]')[0].to_i end
  def tags; (get_attribute('tags') || '').split(',') end
  def get_attribute(attr_name) File.basename(file).split('.').first.split(';').collect{|t| t.split('=').last if t.include?(attr_name) }.compact[0] end
  def type; File.basename(file).split('.').last end
  def model; file.path.split('/')[2] end
  def app_name; file.path.split('/')[1] end
  def db; conn.db(app_name) end
  def coll; db[model] end
  def slug; doc['slug'] || doc_name end
  def content_flavor; File.basename(file).split('.').size > 2 ? File.basename(file).split('.')[1] : nil end

  def hero_image
    image_path = File.join(File.dirname(__FILE__), 'public', app_name, model, "images/#{doc_name}.*")
    hero_image = Dir.glob(image_path).to_a
    return File.join('/assets',app_name,model,'images',File.basename(hero_image[0])) unless hero_image.empty?
  end

  def doc; @doc ||= parse_file end
  def parse_file
    case type
      when 'md'
        doc_hash = { 'content' => { 'type' => 'markdown', 'value' => file.read } }
        doc_hash['content']['flavor'] = content_flavor if content_flavor
      when 'json'
        document_hash = JSON.parse(file.read)
        doc_hash = ParseFileContent.new(File.dirname(file)).parse(document_hash)
    end
    doc_hash
  end

  def old_doc
    @old_doc ||= (coll.find({'doc_id' => doc['doc_id'], 'latest' => true}).to_a[0] || {})
  end

  def update_old_doc
    coll.update({'_id' => old_doc['_id']}, {'$set' => {'latest' => false}}) unless old_doc.empty?
  end

  def build
    doc['doc_id'] = doc_name unless doc['doc_id']

    timestamp = file.mtime.to_i
    doc['publish_datetime'] = timestamp
    doc['version'] = timestamp
    doc['locale'] = 'en_US'
    doc['create_datetime'] = (old_doc.empty? ? timestamp : old_doc['create_datetime'] )
    doc['create_by'] = 'seed'
    doc['state'] = 'published'
    doc['latest'] = true

    build_model_specific_data
  end

  def build_model_specific_data
    case model
      when 'pages'
      when 'posts'
        doc['title'] = title
        doc['slug'] = slug
        doc['description'] = description
        doc['tags'] = tags
        doc['hero_image'] = { 'url' => hero_image} if hero_image
      when 'chapters'
        doc['title'] = title
        doc['slug'] = slug
        doc['description'] = description
        doc['tags'] = tags
        doc['hero_image'] = { 'url' => hero_image} if hero_image
        doc['chapter_number'] = chapter_number
        build_chapter_links
    end
  end

  def title
    return doc['title'] if doc['title']

    if doc['content'] && doc['content']['value']
      content_lines = doc['content']['value'].lines
      doc_title = content_lines.first.chomp
      doc['content']['value'] = content_lines[2] ? content_lines[2..-1].join("\n") : ''
    else
      doc_title = doc_name
    end
    doc_title.gsub('_',' ').gsub('#','').strip
  end

  def description
    return doc['description'] if doc['description']
    post_description = ''
    content_lines = doc['content']['value'].lines
    index = 0
    while post_description.length < 300 do
      post_description.concat(content_lines[index].chomp.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, ''))
      index += 1
    end
    post_description + '...'
  end

  def build_chapter_links
    chapters = Dir.glob(File.join(File.dirname(file), '/*.{json,md}')).to_a
    index = chapters.index(file.path)
    if index > 0
      model = SoupCMSModelBuilder.new(File.new(chapters[index-1]))
      doc['prev_chapter'] = {'label' => model.title, 'link' => {'model_name' => 'chapters', 'match' => {'slug' => model.slug}}}
    end
    if index < (chapters.size-1)
      model = SoupCMSModelBuilder.new(File.new(chapters[index+1]))
      doc['next_chapter'] = {'label' => model.title, 'link' => {'model_name' => 'chapters', 'match' => {'slug' => model.slug}}}
    end
  end

  def create
    build()
    if doc['publish_datetime'] == old_doc['publish_datetime']
      #puts "Skipping document #{file}, since no changes"
    else
      puts "Inserting document #{file.path}"
      coll.insert(doc)
      update_old_doc
    end
  end
end


class ParseFileContent

  def initialize(path)
    @path = path
  end

  def parse(document)
    if document.kind_of?(Array)
      document.collect { |doc| parse_for_file(doc) }
    elsif document.kind_of?(Hash)
      parse_for_file(document)
    end
  end

  def parse_for_file(document)
    document.each do |key, value|
      if value.kind_of?(Array)
        document[key] = value.collect { |item| item.kind_of?(Hash) ? parse_for_file(item) : item }
      elsif value.kind_of?(Hash)
        document[key] = parse_for_file(value)
      elsif value.kind_of?(String) && value.match(/^\$file:/)
        document[key] = File.read(File.join(@path,'ref_files',value.match(/\$file:([\w\.\-]*)/).captures[0]))
      end
    end
    @document = document
  end

end
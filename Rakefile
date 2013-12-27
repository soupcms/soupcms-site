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
      SoupCMSModelBuilder.new(File.new(afile),conn).create()
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
  def doc_name; File.basename(file).split('.').first end
  def type; File.basename(file).split('.').last end
  def model; file.path.split('/')[2] end
  def app_name; file.path.split('/')[1] end
  def db; conn.db(app_name) end
  def coll; db[model] end
  def slug; doc['slug'] || doc_name end

  def doc; @doc ||= parse_file end
  def parse_file
    case type
      when 'md'
        { 'content' => file.read }
      when 'json'
        JSON.parse(file.read)
    end
  end

  def old_doc
    @old_doc ||= (coll.find({'doc_id' => doc['doc_id'], 'latest' => true}).to_a[0] || {})
  end

  def update_old_doc
    coll.update({'_id' => old_doc['_id']}, {'$set' => {'latest' => false}}) unless old_doc.empty?
  end

  def build
    doc['doc_id'] = doc_name unless doc['doc_id']
    doc['slug'] = slug

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
        doc['description'] = description
      when 'chapters'
        doc['title'] = title
        build_chapter_links
    end
  end

  def title; doc['title'] || Titleize.new.titleize(doc['content'] ? doc['content'].lines.first.chomp : doc_name) end

  def description
    return doc['description'] if doc['description']
    post_description = ''
    content_lines = doc['content'].lines
    index = 1
    while post_description.length < 200 do
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
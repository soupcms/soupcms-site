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
      SoupCMSModelBuilder.new(File.new(afile),conn).create
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

  def initialize(file, conn); @file = file; @conn = conn; end
  attr_reader :file, :conn
  def doc_name; File.basename(file).split('.').first end
  def type; File.basename(file).split('.').last end
  def model; file.path.split('/')[2] end
  def app_name; file.path.split('/')[1] end
  def db; conn.db(app_name) end
  def coll; db[model] end
  def slug; doc_name end

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
    coll.update({'_id' => old_doc['_id']}, {'$set' => {'latest' => false}})
  end

  def build
    doc['doc_id'] = doc_name unless doc['doc_id']

    doc['slug'] = slug unless doc['slug']

    timestamp = file.mtime.to_i
    doc['publish_datetime'] = timestamp
    doc['version'] = timestamp
    doc['locale'] = 'en_US'
    doc['create_datetime'] = (old_doc.empty? ? timestamp : old_doc['create_datetime'] )
    doc['create_by'] = 'seed'
    doc['state'] = 'published'
    doc['latest'] = true
  end

  def create
    build
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
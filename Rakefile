require 'soupcms/site'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec


task :seed do
  Dir.glob('seed/**/*.{json,md}').each do |afile|
    if afile.include?('ref_files')
      #puts "Ignoring ref file... #{afile}"
    else
      #puts "Importing file... #{afile}"
      begin
        SoupCMS::Rake::Model::Base.create_model(File.new(afile))
      rescue => e
        puts "Error importing file... #{afile}"
        puts "#{e.backtrace.first}: #{e.message} (#{e.class})"
        puts "#{e.backtrace.drop(1).map{|s| s }.join("\n")}"
      end
    end
  end
end

task :clean do
  %w(www blog docs).each do |app_name|
    mongo_uri = ENV["MONGODB_URI_#{app_name}"] || "mongodb://localhost:27017/#{app_name}"
    conn = Mongo::MongoClient.from_uri(mongo_uri)
    db = conn.db
    puts "Cleaning up the database...#{app_name}"
    db.collection_names.each { |coll_name|
      next if coll_name.match(/^system/)
      db[coll_name].remove
    }
    conn.close
  end
end



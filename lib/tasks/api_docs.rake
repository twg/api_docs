namespace :test do
  task :prepare => :environment do
    if ApiDocs.config.reload_docs_folder
      Dir["#{ApiDocs.config.docs_path}/*.yml"].each do |file| 
        FileUtils.rm file
      end
    end
  end
end
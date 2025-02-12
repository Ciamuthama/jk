require 'json'
require 'fileutils'

class JsonKeeper
  DATA_FOLDER = 'data'

  def initialize
    FileUtils.mkdir_p(DATA_FOLDER) unless Dir.exist?(DATA_FOLDER)
  end

  def create_json(filename, content ={})
    filepath = File.join(DATA_FOLDER, "#{filename}.json")

    if File.exist?(filepath)
      puts "Error: File '#{filename}' already exists!🚫"
      return
    end

    File.write(filepath, JSON.pretty_generate(content))
    puts "Success: file '#{filename}' created successfully!🎉"
  end
end

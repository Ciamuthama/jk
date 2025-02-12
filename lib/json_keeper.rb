require 'json'
require 'fileutils'

class JsonKeeper
  DATA_FOLDER = 'data'

  def initialize
    FileUtils.mkdir_p(DATA_FOLDER) unless Dir.exist?(DATA_FOLDER)
  end

  def parse_value(value)
    case value
    when /\A\d+\z/
      value.to_i
    when /\A\d+\.\d+\z/
      value.to_f
    when /\A(true|false)\z/i
      value.downcase == 'true'
    when /\Anull\z/i
      nil
    else
      value
    end
  end

  def create_json(filename, data)
    filepath = File.join(DATA_FOLDER, "#{filename}.json")
  
    if File.exist?(filepath)
      puts "Error: File '#{filename}' already exists!🚫"
      return
    end
  
    File.write(filepath, JSON.pretty_generate(data))
    puts "Success: file '#{filename}' created successfully! 🎉"
  end
  
  
  
end

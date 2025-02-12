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
  
  def read_json(filename, key = nil)
    filepath = File.join(DATA_FOLDER, "#{filename}.json")

    unless File.exist?(filepath)
      puts "Error: File '#{filename}' does not exist! 🚫"
    end

    data = JSON.parse(File.read(filepath))

    if key
      if data.key?(key)
        puts "🏁 Value for '#{key}': #{data[key].inspect}"
      else
        puts "⚠️ Key '#{key}' not found in '#{filename}.json'."
      end
      
    else
      puts "📂 Full JSON Data:"
      puts JSON.pretty_generate(data)
    end
    
    data
  end
  

  def update_json(filename, key, new_value)
    filepath = File.join(DATA_FOLDER, "#{filename}.json")
  
    unless File.exist?(filepath)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end
  
    begin
      data = JSON.parse(File.read(filepath))
    rescue JSON::ParserError
      puts "Error: Invalid JSON format in '#{filename}.json'! 🚨"
      return
    end
  
    if data.key?(key)
      data[key] = parse_value(new_value)
      File.write(filepath, JSON.pretty_generate(data))
      puts "✅ Success: Key '#{key}' updated in '#{filename}.json'!"
    else
      puts "⚠️ Warning: Key '#{key}' not found in '#{filename}.json'. No changes made."
    end
  end

  def delete_json(filename)
    filepath = File.join(DATA_FOLDER, "#{filename}.json")
    unless File.exist?(filepath)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end

    File.delete(filepath)
    puts "✅ Success: File '#{filename}.json' deleted!"
  end
  

end

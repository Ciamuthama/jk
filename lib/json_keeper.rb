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
      puts "Error: File '#{filename}.json' not found! 🚫"
      return
    end
  
    data = JSON.parse(File.read(filepath))
  
    if key
      if data.key?(key)
        puts "✅ Value for '#{key}': #{data[key].inspect}"
      else
        puts "⚠️ Key '#{key}' not found in '#{filename}.json'."
      end
    else
      puts "📂 Full JSON Data:"
      puts JSON.pretty_generate(data)
    end
  
    data # Return the data in case it's needed elsewhere
  end
  
  

  def update_json(filename, key, new_value)
    filepath = File.join(DATA_FOLDER, "#{filename}.json")
    unless File.exist?(filepath)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end
  
    data = JSON.parse(File.read(filepath))
  
    # Detect if the user is adding a nested object
    print "Do you want to nest an object inside '#{key}'? (y/n): "
    nest_choice = gets.chomp.downcase
  
    if nest_choice == "y"
      nested_data = {}
      loop do
        print "Enter nested key (or press enter to finish): "
        nested_key = gets.chomp.strip
        break if nested_key.empty?
  
        print "Enter value for '#{nested_key}': "
        nested_value = gets.chomp.strip
        nested_data[nested_key] = parse_value(nested_value)
      end
      new_value = nested_data
    elsif new_value.include?(",")  # Convert comma-separated values into an array
      new_value = new_value.split(",").map(&:strip)
    else
      new_value = parse_value(new_value)
    end
  
    data[key] = new_value
    File.write(filepath, JSON.pretty_generate(data))
    puts "✅ Success: Updated '#{key}' in '#{filename}.json'!"
  end
  
  

  def add_nested_object(filename, key, json_string)
    filepath = File.join(DATA_FOLDER, "#{filename}.json")

    unless File.exist?(filepath)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end

    data = JSON.parse(File.read(filepath))

    begin
      nested_data = JSON.parse(json_string)
      data[key] = nested_data
      File.write(filepath, JSON.pretty_generate(data))
      puts "✅ Success: Nested object added under '#{key}' in '#{filename}.json'!"
    
    rescue JSON::ParserError
      puts "Error: Invalid JSON format in the provided JSON string! 🚨"
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

  def delete_key(filename, key)
    filepath = File.join(DATA_FOLDER, "#{filename}.json")

    unless File.exist?(filepath)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end

    data = JSON.parse(File.read(filepath))

    if data.key?(key)
      data.delete(key)
      File.write(filepath, JSON.pretty_generate(data))
      puts "✅ Success: Key '#{key}' deleted from '#{filename}.json'!"
    else
      puts "⚠️ Key '#{key}' not found in '#{filename}.json'."
    end
  end

  def search_json(filename, query)
    filepath = File.join(DATA_FOLDER, "#{filename}.json")
  
    unless File.exist?(filepath)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end
  
    data = JSON.parse(File.read(filepath))
    results = search_in_object(data, query)
  
    if results.empty?
      puts "🔎 No matches found for '#{query}'."
    else
      puts "✅ Found #{results.size} match(es):"
      results.each { |path, value| puts "📌 {#{path}: #{value}}" }
    end
  end
  
  def search_in_object(obj, query, path = "")
    results = {}
  
    obj.each do |key, value|
      new_path = path.empty? ? key : "#{path} -> #{key}"
  
      if key.include?(query) || value.to_s.include?(query)
        results[new_path] = value
      end
  
      if value.is_a?(Hash)
        results.merge!(search_in_object(value, query, new_path))
      end
    end
  
    results
  end
  
end

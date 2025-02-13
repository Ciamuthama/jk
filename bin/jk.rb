#!/usr/bin/env ruby

require_relative '../lib/json_keeper'

class JsonKeeperCLI
  def initialize
    @keeper = JsonKeeper.new
    @running = true
  end

  def start
    puts "Welcome to JSON Keeper!"
    
    while @running
      display_menu
      handle_choice
    end
  end

  private

  def display_menu
    puts "\n📂 JSON Keeper CLI 📂"
    puts "----------------------"
    puts "1. Create a new JSON file"
    puts "2. Read an existing JSON file"
    puts "3. Update a JSON file"
    puts "4. Delete a JSON file"
    puts "5. Delete a key from a JSON file"
    puts "6. Exit"
    puts "----------------------"
    print "Enter your choice: "
  end

  def handle_choice
    choice = gets.chomp

    case choice
    when "1"
        create_json_prompt
    when "2"
        read_json_prompt
    when "3"
        update_json_prompt
    when "4"
        delete_json_prompt
    when "5"
        delete_key_prompt
    when "6"
      puts "Goodbye!👋"
      @running = false
    else
      puts "😵 Invalid choice, please try again."
    end
  end

  def create_json_prompt
    print "Enter the filename (without .json extension): "
    filename = gets.chomp.strip
  
    data = {}
  
    loop do
      print "Enter a key (or press enter to finish): "
      key = gets.chomp.strip
      break if key.empty?
  
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
          nested_data[nested_key] = @keeper.parse_value(nested_value)
        end
        data[key] = nested_data
      else
        print "Enter a value for '#{key}' (comma-separated for list): "
        value = gets.chomp.strip
  
        # Convert comma-separated values to an array
        data[key] = value.include?(",") ? value.split(",").map(&:strip) : @keeper.parse_value(value)
      end
    end
  
    if data.empty?
      puts "Creating an empty JSON file..."
    end
  
    @keeper.create_json(filename, data)
  end
  
  


  
  def read_json_prompt
    print "Enter the filename (without .json extension): "
    filename = gets.chomp.strip
  
    print "Enter a key to retrieve (or press Enter to display the whole file): "
    key = gets.chomp.strip
    key = nil if key.empty?
  
    @keeper.read_json(filename, key)
  end
  

  def update_json_prompt
    print "Enter the filename (without .json extension): "
    filename = gets.chomp.strip
  
    filepath = File.join(JsonKeeper::DATA_FOLDER, "#{filename}.json")
    
    unless File.exist?(filepath)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end
  
    data = JSON.parse(File.read(filepath)) # Read existing data
  
    loop do
      print "Enter the key to update (or press enter to finish): "
      key = gets.chomp.strip
      break if key.empty?
  
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
          nested_data[nested_key] = @keeper.parse_value(nested_value)
        end
        data[key] = nested_data
      else
        print "Enter the new value for '#{key}' (comma-separated for list): "
        value = gets.chomp.strip
        data[key] = value.include?(",") ? value.split(",").map(&:strip) : @keeper.parse_value(value)
      end
    end
  
    if data.empty?
      puts "No updates made."
      return
    end
  
    # Save everything at once
    File.write(filepath, JSON.pretty_generate(data))
    puts "✅ Success: Updated '#{filename}.json' with new values!"
  end
  
  
  

  def delete_json_prompt
    print "Enter the filename (without .json extension) to delete: "
    filename = gets.chomp.strip

    @keeper.delete_json(filename)
  end


  def delete_key_prompt
    print "Enter the filename (without .json extension): "
    filename = gets.chomp.strip

    loop do
      print "Enter the key to delete: "
      key = gets.chomp.strip
      break if key.empty?

      @keeper.delete_key(filename, key)
      puts "Key '#{key}' deleted."

      print "Do you want to delete another key? (y/n): "
      continue = gets.chomp.strip.downcase
      break unless continue == 'y'
    end
  end

end
# Start the CLI
JsonKeeperCLI.new.start

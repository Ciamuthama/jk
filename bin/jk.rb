#!/usr/bin/env ruby

require_relative '../lib/json_keeper'

class JsonKeeperCLI
  def initialize
    @keeper = JsonKeeper.new
    @running = true
  end

  def start
    puts "Welcome to JSON Keeper! 🚀"
    
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
    puts "6. Search in a JSON file 🔎"
    puts "7. Exit"
    puts "----------------------"
    print "Enter your choice: "
  end
  
  def handle_choice
    choice = gets.chomp
  
    case choice
    when "1" then create_json_prompt
    when "2" then read_json_prompt
    when "3" then update_json_prompt
    when "4" then delete_json_prompt
    when "5" then delete_key_prompt
    when "6" then search_json_prompt
    when "7"
      puts "Goodbye! 👋"
      @running = false
    else
      puts "😵 Invalid choice, please try again."
    end
  end

  ## ✨ REFACTORED METHODS BELOW ✨ ##
  
  ### 🔹 Helper Methods to Avoid Repetitive Code ###
  def prompt_for_filename(action)
    print "Enter the filename (without .json extension) to #{action}: "
    gets.chomp.strip
  end

  def prompt_for_key(action)
    print "Enter the key to #{action} (or press enter to finish): "
    gets.chomp.strip
  end

  ### 🔹 Nested Object Handling (to avoid duplicating logic) ###
  def collect_nested_object
    nested_data = {}
    loop do
      nested_key = prompt_for_key("add inside the nested object")
      break if nested_key.empty?

      print "Enter value for '#{nested_key}': "
      nested_value = gets.chomp.strip
      nested_data[nested_key] = @keeper.parse_value(nested_value)
    end
    nested_data
  end

  ### 🔹 Create JSON File ###
  def create_json_prompt
    filename = prompt_for_filename("create")

    data = {}
    loop do
      key = prompt_for_key("add")
      break if key.empty?

      print "Do you want to nest an object inside '#{key}'? (y/n): "
      nest_choice = gets.chomp.downcase

      data[key] = nest_choice == "y" ? collect_nested_object : prompt_for_value(key)
    end

    @keeper.create_json(filename, data)
  end

  ### 🔹 Read JSON File ###
  def read_json_prompt
    filename = prompt_for_filename("read")
    
    print "Enter a key to retrieve (or press Enter for full file): "
    key = gets.chomp.strip
    key = nil if key.empty?

    @keeper.read_json(filename, key)
  end

  ### 🔹 Update JSON File ###
  def update_json_prompt
    filename = prompt_for_filename("update")

    unless @keeper.file_exists?(filename)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end

    loop do
      key = prompt_for_key("update")
      break if key.empty?

      print "Do you want to nest an object inside '#{key}'? (y/n): "
      nest_choice = gets.chomp.downcase

      new_value = nest_choice == "y" ? collect_nested_object : prompt_for_value(key)
      @keeper.update_json(filename, key, new_value)
    end
  end

  ### 🔹 Delete JSON File ###
  def delete_json_prompt
    filename = prompt_for_filename("delete")
    @keeper.delete_json(filename)
  end

  ### 🔹 Delete Key from JSON ###
  def delete_key_prompt
    filename = prompt_for_filename("delete a key from")

    loop do
      key = prompt_for_key("delete")
      break if key.empty?

      @keeper.delete_key(filename, key)
      print "Delete another key? (y/n): "
      break unless gets.chomp.downcase == 'y'
    end
  end

  ### 🔹 Search in JSON File ###
  def search_json_prompt
    filename = prompt_for_filename("search in")
    
    print "Enter the search query (key or value): "
    query = gets.chomp.strip

    @keeper.search_json(filename, query)
  end

  ### 🔹 Value Input Handling ###
  def prompt_for_value(key)
    print "Enter a value for '#{key}' (comma-separated for list): "
    value = gets.chomp.strip
    value.include?(",") ? value.split(",").map(&:strip) : @keeper.parse_value(value)
  end
end

# Start the CLI
JsonKeeperCLI.new.start

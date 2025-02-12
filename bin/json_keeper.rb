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
    puts "5. Exit"
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
      puts "Goodbye!👋"
      @running = false
    else
      puts "Invalid choice, please try again."
    end
  end

  def create_json_prompt
    print "Enter the filename (without .json extension): "
    filename = gets.chomp.strip

    print "Enter a key (or leave empty for an empty object): "
    key = gets.chomp.strip

    if key.empty?
      @keeper.create_json(filename, {})
      return
    end

    print "Enter a value for '#{key}': "
    value = gets.chomp.strip

    @keeper.create_json(filename, { key => @keeper.parse_value(value) })
  end


  
  def read_json_prompt
    print "Enter the filename (without .json extension) to read: "
    filename = gets.chomp.strip

    @keeper.read_json(filename)
  end
end

def update_json_prompt
  print "Enter the filename (without .json extension): "
  filename = gets.chomp.strip

  print "Enter the key to update (or create if it doesn't exist): "
  key = gets.chomp.strip

  print "Enter the new value for '#{key}': "
  value = gets.chomp.strip
  
  @keeper.update_json(filename, key, value)
end

def delete_json_prompt
  print "Enter the filename (without .json extension) to delete: "
  filename = gets.chomp.strip

  @keeper.delete_json(filename)
end

# Start the CLI
JsonKeeperCLI.new.start

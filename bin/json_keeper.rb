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
    puts "\nWhat would you like to do?"
    puts "1. Create a new JSON file"
    puts "2. Read an existing JSON file"
    puts "3. Update a JSON file"
    puts "4. Delete a JSON file"
    puts "5. Exit"
    print "Enter your choice: "
  end

  def handle_choice
    choice = gets.chomp

    case choice
    when "1"
        create_json_prompt
    when "2"
      puts "Feature not implemented yet!"
    when "3"
      puts "Feature not implemented yet!"
    when "4"
      puts "Feature not implemented yet!"
    when "5"
      puts "Goodbye!"
      @running = false
    else
      puts "Invalid choice, please try again."
    end
  end

  def create_json_prompt
    print "Enter the filename (without .json extension): "
    filename = gets.chomp.strip

    print "Enter JSON content (or press enter for an empty object{}): "
end

# Start the CLI
JsonKeeperCLI.new.start

module Update
  def update_json(filename, key, new_value)
    path = file_path(filename)

    unless file_exists?(filename)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end

    data = JSON.parse(File.read(path))

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
    elsif new_value.include?(",")
      new_value = new_value.split(",").map(&:strip)
    else
      new_value = parse_value(new_value)
    end

    data[key] = new_value
    File.write(path, JSON.pretty_generate(data))
    puts "✅ Success: Updated '#{key}' in '#{filename}.json'!"
  end
end

module Create
  def create_json(filename, data)
    path = file_path(filename)

    if file_exists?(filename)
      puts "Error: File '#{filename}' already exists!🚫"
      return
    end

    File.write(path, JSON.pretty_generate(data))
    puts "Success: File '#{filename}' created successfully! 🎉"
  end
end

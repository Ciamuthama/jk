module Delete
  def delete_json(filename)
    path = file_path(filename)

    unless file_exists?(filename)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end

    File.delete(path)
    puts "✅ Success: File '#{filename}.json' deleted!"
  end

  def delete_key(filename, key)
    path = file_path(filename)

    unless file_exists?(filename)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end

    data = JSON.parse(File.read(path))

    if data.key?(key)
      data.delete(key)
      File.write(path, JSON.pretty_generate(data))
      puts "✅ Success: Key '#{key}' deleted from '#{filename}.json'!"
    else
      puts "⚠️ Key '#{key}' not found in '#{filename}.json'."
    end
  end
end

module Read
  def read_json(filename, key = nil)
    path = file_path(filename)

    unless file_exists?(filename)
      puts "Error: File '#{filename}.json' not found! 🚫"
      return
    end

    data = JSON.parse(File.read(path))

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
  end
end

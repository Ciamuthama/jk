module Search
  def search_json(filename, query)
    path = file_path(filename)

    unless file_exists?(filename)
      puts "Error: File '#{filename}.json' does not exist! 🚫"
      return
    end

    data = JSON.parse(File.read(path))
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

      results.merge!(search_in_object(value, query, new_path)) if value.is_a?(Hash)
    end

    results
  end
end

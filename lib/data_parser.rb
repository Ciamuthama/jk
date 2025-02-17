module DataParser
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
end

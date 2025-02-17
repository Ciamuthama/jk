require 'json'
require 'fileutils'

module FileManager
  DATA_FOLDER = 'data'

  def initialize
    FileUtils.mkdir_p(DATA_FOLDER) unless Dir.exist?(DATA_FOLDER)
  end

  def file_path(filename)
    File.join(DATA_FOLDER, "#{filename}.json")
  end

  def file_exists?(filename)
    File.exist?(file_path(filename))
  end
end

require_relative 'file_manager'
require_relative 'data_parser'
require_relative 'create'
require_relative 'read'
require_relative 'update'
require_relative 'delete'
require_relative 'search'

class JsonKeeper
  include FileManager
  include DataParser
  include Create
  include Read
  include Update
  include Delete
  include Search
end

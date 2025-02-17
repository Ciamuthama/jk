# spec/json_keeper_spec.rb
require 'json'
require 'fileutils'
require_relative '../lib/json_keeper'

RSpec.describe JsonKeeper do
  before(:each) do
    FileUtils.rm_rf('data') # Clean up before each test
    @keeper = JsonKeeper.new
  end

  describe '#create_json' do
    it 'creates a JSON file with nested objects' do
      filename = 'test_file'
      data = {
        'user' => {
          'name' => 'John Doe',
          'address' => {
            'city' => 'New York',
            'zipcode' => '10001'
          }
        }
      }

      @keeper.create_json(filename, data)
      filepath = File.join(JsonKeeper::DATA_FOLDER, "#{filename}.json")
      expect(File.exist?(filepath)).to be true
      json_data = JSON.parse(File.read(filepath))
      expect(json_data['user']['address']['city']).to eq('New York')
    end
  end

  describe '#update_json' do
    it 'updates an existing JSON file with nested objects' do
      filename = 'test_file'
      initial_data = {
        'user' => {
          'name' => 'John Doe',
          'address' => {
            'city' => 'New York',
            'zipcode' => '10001'
          }
        }
      }
      @keeper.create_json(filename, initial_data)

      new_data = {
        'user' => {
          'address' => {
            'city' => 'San Francisco',
            'zipcode' => '94103'
          }
        }
      }
      @keeper.update_json(filename, 'user', new_data['user'])

      json_data = JSON.parse(File.read(File.join(JsonKeeper::DATA_FOLDER, "#{filename}.json")))
      expect(json_data['user']['address']['city']).to eq('San Francisco')
    end
  end

  describe '#delete_key' do
    it 'deletes a key from a JSON file, including nested keys' do
      filename = 'test_file'
      data = {
        'user' => {
          'name' => 'John Doe',
          'address' => {
            'city' => 'New York',
            'zipcode' => '10001'
          }
        }
      }
      @keeper.create_json(filename, data)
      @keeper.delete_key(filename, 'user')

      json_data = JSON.parse(File.read(File.join(JsonKeeper::DATA_FOLDER, "#{filename}.json")))
      expect(json_data.key?('user')).to be false
    end
  end

  describe '#search_json' do
    it 'finds a nested key when searching in a JSON file' do
      filename = 'test_file'
      data = {
        'user' => {
          'name' => 'John Doe',
          'address' => {
            'city' => 'New York',
            'zipcode' => '10001'
          }
        }
      }
      @keeper.create_json(filename, data)

      results = @keeper.search_in_object(JSON.parse(File.read(File.join(JsonKeeper::DATA_FOLDER, "#{filename}.json"))), 'city')
      expect(results).to include('user -> address -> city' => 'New York')
    end
  end
end

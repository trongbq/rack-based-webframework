require "multi_json"

module Rulers
    module Model
        class FileModel
            def initialize(filename)
                @filename = filename

                # If filename is "dir/37.json" then @id is 37
                basename = File.split(filename)[-1]
                @id = File.basename(basename, ".json").to_i

                obj = File.read(filename)
                @hash = MultiJson.load(obj)
            end

            def [](name)
                @hash[name.to_s]
            end

            def []=(naem, value)
                @hash[name.to_s] = value
            end

            class << self
                def find(id)
                    FileModel.new("db/quotes/#{id}.json")
                rescue
                    return nil
                end

                def all
                    files = Dir['db/quotes/*.json']
                    files.map { |f| FileModel.new(f) }
                end

                def create(attrs)
                    hash = {
                        'submitter' => attrs['submitter'] || '',
                        'quote' => attrs['quote'] || '',
                        'attribution' => attrs['attribution'] || ''
                    }

                    files = Dir['db/quotes/*.json']
                    names = files.map { |f| f.split('/')[-1] }
                    highest = names.map { |b| b[0...-5].to_i }.max
                    id = highest + 1
                    
                    STDERR.puts hash
                    STDERR.puts "*****************"
                    File.open("db/quotes/#{id}.json", "w") do |f|
                        f.write <<TEMPLATE
{
    "submitter": "#{hash['submitter']}",
    "quote": "#{hash['quote']}",
    "attribution": "#{hash['attribution']}"
}
TEMPLATE
                    end

                    FileModel.new("db/quotes/#{id}.json")
                end
            end
        end
    end
end

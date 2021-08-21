require 'sqlite3'
require 'rulers/sqlite_model'

class MyTable < Rulers::Model::SQLite
end

STDERR.puts MyTable.schema.inspect


# Create row
# mt = MyTable.create(
#     'title' => 'It happened!',
#     'posted' => 1,
#     'body' => 'It did!'
# )
# mt = MyTable.create('title' => 'I saw it')
# STDERR.puts "Count: #{MyTable.count}"

mt = MyTable.new('title' => 'I did it', 'posted' => 1, 'body' => 'Please check the title :)')
mt.save!
STDERR.puts mt.inspect
mt['title'] = 'Just make some change'
mt.save!
STDERR.puts mt.inspect
STDERR.puts "Count: #{MyTable.count}"

last_id = mt['id'].to_i
(1..last_id).each do |id|
    data = MyTable.find(id)
    STDERR.puts "Found title: #{data['title']}"
end

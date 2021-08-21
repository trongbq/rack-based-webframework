require 'sqlite3'
require 'rulers/util'

DB = SQLite3::Database.new('test.db')

module Rulers
    module Model
        class SQLite
            def initialize(data = nil)
                @hash = data
            end

            def [](name)
                @hash[name.to_s]
            end

            def []=(name, value)
                @hash[name.to_s] = value
            end

            def save!
                unless @hash['id']
                    self.class.create(@hash)
                    self['id'] = DB.execute('SELECT last_insert_rowid();')[0][0]
                    return true
                end

                fields = @hash.map do |k, v|
                    "#{k}=#{self.class.to_sql(v)}"
                end.join(',')
                DB.execute("UPDATE #{self.class.table} SET #{fields} WHERE id = #{@hash['id']}")
            end

            def save
                self.save! rescue false
            end

            class << self
                def table
                    Rulers.to_underscore(name)
                end

                def schema
                    return @schema if @schema

                    @schema = {}
                    DB.table_info(table) do |row|
                        @schema[row['name']] = row['type']
                    end
                    @schema
                end

                def to_sql(val)
                    case val
                    when Numeric
                        val.to_s
                    when String
                        "'#{val}'"
                    else
                        raise "Can't change #{val.class} to SQL!"
                    end
                end

                def create(values)
                    values.delete('id')
                    keys = schema.keys - ['id']
                    vals = keys.map do |key|
                        values[key] ? to_sql(values[key]) : 'null'
                    end

                    DB.execute("INSERT INTO #{table} (#{keys.join(',')}) VALUES (#{vals.join(',')});")
                    data = Hash[keys.zip(vals)]
                    sql = 'SELECT last_insert_rowid();'
                    data['id'] = DB.execute(sql)[0][0]
                    self.new(data)
                end

                def count
                    DB.execute("SELECT COUNT(*) FROM #{table}")[0][0]
                end

                def find(id)
                    row = DB.execute("SELECT #{schema.keys.join(',')} FROM #{table} WHERE id = #{id};")
                    data = Hash[schema.keys.zip(row[0])]
                    self.new(data)
                end
            end
        end
    end
end

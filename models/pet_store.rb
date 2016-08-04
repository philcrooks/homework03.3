require_relative ('../db/sql_runner')

class PetStore

  attr_reader :id
  attr_accessor :name, :address, :stock_type

  def self.retrieve_from_db
    sql = "SELECT * FROM pet_stores;"
    stores = SqlRunner.run(sql)
    @@stores = stores.map { | options | PetStore.new(options) }
    return @@stores.count
  end

  def self.find_by_id(store_id, from_db = true)
    if from_db
      sql = "SELECT * FROM pet_stores WHERE id = #{store_id};"
      return PetStore.new(SqlRunner.run(sql).first)
    else
      @@stores ||= []
      return @@stores.find { | store | store.id == store_id }
    end
  end

  def self.all(from_db = true)
    if from_db
      sql = "SELECT * FROM pet_stores;"
      stores = SqlRunner.run(sql)
      return stores.map { | options | PetStore.new(options) }
    else
      @@stores ||= []
      return @@stores
    end
  end

  def initialize ( options )
    @id = options['id'].to_i
    @name = options['name']
    @address = options['address']
    @stock_type = options['stock_type']
  end

  def save
    sql = "INSERT INTO pet_stores (name, address, stock_type) VALUES ('#{@name}', '#{@address}', '#{@stock_type}') RETURNING *;"
    @id = SqlRunner.run(sql).first['id']
    @@stores ||= []
    @@stores << self.clone
    return @id
  end

  def delete
    if @id
      begin
        sql = "DELETE FROM pet_stores WHERE id = #{@id};"
        SqlRunner.run(sql)
        @@stores ||= []
        # self may not be on the @@stores list but a store with the same id should be
        i = @@stores.find_index { | store | store.id == @id }
        @@stores.delete_at(i) if i
        @id = nil
      rescue
        # There's a good chance the delete will fail
        puts "The delete failed. Check you have removed all the pets from the store before deleting it."
      end
    end
    return @id
  end

  def update
    if @id
      sql = "UPDATE pet_stores SET (name, address, stock_type) = ('#{@name}', '#{@address}', '#{@stock_type}') WHERE id = #{@id} RETURNING *;"
      id = SqlRunner.run(sql).first['id']
      i = @@stores.find_index { | store | store.id == @id }
      @@stores[i] = self.clone if i && @@stores[i] != self
      return id
    end
    return nil
  end
end
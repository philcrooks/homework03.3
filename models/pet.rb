require_relative ('../db/sql_runner')

class Pet

  attr_reader :id
  attr_accessor :name, :type, :store_id

  def self.retrieve_from_db
    sql = "SELECT * FROM pets;"
    pets = SqlRunner.run(sql)
    @@pets = []
    @@pets = pets.map { | options | Pet.new(options) }
    return @@pets.count
  end

  def self.find_by_id(pet_id, from_db = true)
    if from_db
      sql = "SELECT * FROM pets WHERE id = #{pet_id};"
      return Pet.new(SqlRunner.run(sql).first)
    else
      @@pets ||= []
      return @@pets.find { | pet | pet.id == pet_id }
    end
  end

  def self.find_pets_in_store(store_id, from_db = true)
    if from_db
      sql = "SELECT * FROM pets WHERE store_id = '#{store_id}';"
      pets = SqlRunner.run(sql)
      return pets.map { | options | Pet.new(options) }
    else
      @@pets ||= []
      return @@pets.select { | pet | pet.store_id == store_id }
    end
  end

  def self.all (from_db = true)
    if from_db
      sql = "SELECT * FROM pets;"
      pets = SqlRunner.run(sql)
      return pets.map { | options | Pet.new(options) }
    else
      @@pets ||= []
      return @@pets
    end
  end

  def initialize ( options )
    @id = options['id'].to_i
    @name = options['name']
    @type = options['type']
    @store_id = options['store_id'].to_i
  end

  def save
    sql = "INSERT INTO pets (name, type, store_id) VALUES ('#{@name}', '#{@type}', #{@store_id}) RETURNING *;"
    @id = SqlRunner.run(sql).first['id']
    @@pets ||= []
    @@pets << self.clone
    return @id
  end

  def delete
    sql = "DELETE FROM pets WHERE id = #{@id};"
    SqlRunner.run(sql)
    @@pets ||= []
    # self may not be on the @@pets list but a pet with the same id should be
    i = @@pets.find_index { | pet | pet.id == @id }
    @@pets.delete_at(i) if i
    return @id
  end

  def update
    sql = "UPDATE pets SET (name, type, store_id) = ('#{@name}', '#{@type}', #{@store_id}) WHERE id = #{@id} RETURNING *;"
    id = SqlRunner.run(sql).first['id']
    @@pets ||= []
    i = @@pets.find_index { | pet | pet.id == @id }
    @@pets[i] = self.clone if i
    return id
  end

  def my_store
    return Store.find_by_id(@store_id)
  end
end

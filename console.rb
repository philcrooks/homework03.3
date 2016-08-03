require_relative ('models/pet_store')
require_relative ('models/pet')
require ('pry-byebug')

def setup
  store = PetStore.new({'name' => 'House of Hound', 'address' => '43 Roseburn Terrace, Edinburgh', 'stock_type' => 'dogs'})
  id = store.save()
  pet = Pet.new({'name' => 'Zeus', 'type' => 'Black Labrador', 'store_id' => id})
  pet.save()
  pet = Pet.new({'name' => 'Kyla', 'type' => 'Black Labrador', 'store_id' => id})
  pet.save()
  pet = Pet.new({'name' => 'Murphy', 'type' => 'Golden Retriever', 'store_id' => id})
  pet.save()


  store = PetStore.new({'name' => 'Serpentus Exotics', 'address' => '57-59 Main St, Dunfermline', 'stock_type' => 'exotics'})
  id = store.save()
  pet = Pet.new({'name' => 'Carolina', 'type' => 'Corn Snake', 'store_id' => id})
  pet.save()
  pet = Pet.new({'name' => 'Snowy', 'type' => 'Corn Snake', 'store_id' => id})
  pet.save()
  pet = Pet.new({'name' => 'Piebald', 'type' => 'Royal Python', 'store_id' => id})
  pet.save()
end

Pet.retrieve_from_db
PetStore.retrieve_from_db
binding.pry
nil

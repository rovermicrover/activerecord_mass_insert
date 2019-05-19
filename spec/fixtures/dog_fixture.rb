# frozen_string_literal: true

require 'securerandom'

class DogFixture
  def self.dogs
    [
      { name: 'Madison', breed: 'Golden', meta: { rescue: false, age: nil } },
      { name: 'Daisy', meta: { rescue: true, age: 18 } },
      { name: 'Gracey', meta: { rescue: false, nickname: 'Scoogie', age: 11 } },
      { name: 'Sadie', meta: { rescue: true, dingo_blood: true, age: 11 } },
      { name: 'Raymond', meta: { rescue: nil, nickname: 'Radar', tail: false, age: 11 } },
      { name: 'Nemo', meta: { rescue: true, number_of_ears: 1, age: 2 } }
    ]
  end

  def self.random_dogs
    Enumerator.new do |enumerator|
      loop do
        enumerator << random_dog
      end
    end
  end

  def self.random_dog
    name = Faker::Creature::Dog.name
    {
      name: name,
      nickname: name.first(4),
      breed: Faker::Creature::Dog.breed,
      age: Random.rand(20),
      rescue: Random.rand(1).eql?(1)
    }
  end
end

# frozen_string_literal: true

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
end

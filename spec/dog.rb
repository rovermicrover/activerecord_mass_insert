class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Dog < ApplicationRecord

end
# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend ActiveRecord::MassInsert::Helper
end

class Dog < ApplicationRecord
end

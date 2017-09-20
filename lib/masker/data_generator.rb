require 'faker'

module DataGenerator
  class << self
    def generate(type)
      case type
      when :name
        Faker::Name.name
      when :company_name
        Faker::Company.name
      when :first_name
        Faker::Name.first_name
      when :last_name
        Faker::Name.last_name
      when :email
        "#{SecureRandom.hex(8).upcase}_#{Faker::Internet.email}"
      when :text
        Faker::Lorem.sentence
      when :date
        Faker::Date.forward(1000)
      when :city
        "#{Faker::Address.city}_#{SecureRandom.hex(8).upcase}"
      when :domain_name
        Faker::Internet.domain_name
      when :country
        "#{Faker::Address.country}_#{SecureRandom.hex(8).upcase}"
      when :characters
        Faker::Lorem.characters(10)
      when :zip_code
        Faker::Address.zip_code
      when :year
        Faker::Number.between(1900, 2020)
      when :integer
        Faker::Number.number(8)
      when :low_integer
        Faker::Number.between(1, 200)
      when :float
        Faker::Number.decimal(2, 2)
      when :state
        "#{Faker::Address.state}_#{SecureRandom.hex(8).upcase}"
      when :phone
        Faker::Number.number(10)
      when :street_address
        Faker::Address.street_address
      else
        type
      end
    end
  end
end

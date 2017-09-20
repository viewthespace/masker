class PostgresFake
  VALUES = {
    users: [
      {
        id: 1,
        name: %Q['Rick Sanchez'],
        email: %Q['rick@rm.com'],
        ssn: %Q['111-11-1111'],
        device_id: 1,
        address_id: 1
      },
      {
        id: 2,
        name: %Q['Morty Smith'],
        email: %Q['morty@rm.com'],
        ssn: %Q['222-22-2222'],
        device_id: 2,
        address_id: 1
      }
    ],
    phones: [
      {
        id: 1,
        imei: %Q['1337abc'],
        number: %Q['123-456-7891'],
        brand: %Q['ios'],
        model: %Q['20000']
      },
      {
        id: 2,
        imei: %Q['cba7331'],
        number: %Q['7891-456-123'],
        brand: %Q['android'],
        model: %Q['pineapple']
      }
    ]
  }

  def initialize(pg)
    @pg = pg
  end

  def setup
    drop_tables
    create_tables
    populate_tables
  end

  def drop_tables
    pg.exec("DROP TABLE IF EXISTS users;")
    pg.exec("DROP TABLE IF EXISTS phones;")
    pg.exec("DROP TABLE IF EXISTS addresses;")
  end

  def create_tables
    pg.exec("CREATE TABLE users (id int primary key, name text, email text, ssn char(11), device_id int, address_id int);")
    pg.exec("CREATE TABLE phones (id int primary key, imei text, number text, brand text, model text);")
    pg.exec("CREATE TABLE addresses (id int primary key, city text, state text, zip_code int);")
  end

  def populate_tables
    VALUES[:users].each do |user|
      pg.exec("INSERT INTO users (id, name, email, ssn, device_id, address_id) VALUES (#{user.values.join(", ")});")
    end

    VALUES[:phones].each do |phone|
      pg.exec("INSERT INTO phones (id, imei, number, brand, model) VALUES (#{phone.values.join(", ")});")
    end

    pg.exec("INSERT INTO addresses (id, city, state, zip_code) VALUES (1, 'somewhere', 'IL', 1337);")
  end

  private

  attr_reader :pg
end

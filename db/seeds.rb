# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create! email: "user@fake.local",
                    public_key: "03cb388fb2c5c65041b27bd7d3019faf943b1a066126c6f1a2f403e226ed067995",
                    activated_at: Time.zone.now

user.sites.create! sid: "test",
                   domain: "fake.local",
                   verified: true

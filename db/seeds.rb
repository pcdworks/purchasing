# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PaymentMethod.create([
  { title: "Net30" },
  { title: "Net20" },
  { title: "Net15" },
  { title: "Compass Visa" },
  { title: "AMEX Business" },
  { title: "AMEX Delta" },
  { title: "BBVA Visa" },
  { title: "BOA" },
  { title: "United Chase" },
  { title: "Contract" }
])

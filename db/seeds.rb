# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Site.create!([
  { slug: "pipersheath", name: "Piper's Heath Golf Course"},
  { slug: "ospreyvalley", name: "Osprey Valley Golf Course"},
  { slug: "pheasantrun", name: "Pheasant Run Golf Course"},
  { slug: "eaglesnest", name: "Eagles Nest Golf Course"},
  { slug: "hockleyvalley", name: "Hockley Valley Golf Course"}
])

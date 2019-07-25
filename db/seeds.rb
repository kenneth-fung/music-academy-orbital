# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'

if ENV["01"]
  # seed students, tutors, courses, lessons, subscriptions, and reviews
  %w[01_students_and_tutors 02_courses_and_lessons 03_subscriptions 04_reviews].each do |part|
    require File.expand_path(File.dirname(__FILE__)) + "/seeds/#{part}.rb"
  end
elsif ENV["02"]
  # seed posts
  %w[05_posts].each do |part|
    require File.expand_path(File.dirname(__FILE__)) + "/seeds/#{part}.rb"
  end
elsif ENV["03"]
  # seed messages
  %w[06_messages].each do |part|
    require File.expand_path(File.dirname(__FILE__)) + "/seeds/#{part}.rb"
  end
else
  # seed everything
  Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |seed|
    load seed
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  # Account.delete_all
  Account.find_or_initialize_by(email: 'admin@example.com') do |a|
    a.nickname = 'Admin'
    a.password = 'password'
    a.password_confirmation = 'password'
    a.roles = %w(superadmin user)
    a.save!
  end

  flag = Flag.find_or_create_by(name: 'Test Flag', description: 'Test Description')
  Nation.find_or_create_by(flag: flag.id, name: 'Test Nation', description: 'Test Description')
end

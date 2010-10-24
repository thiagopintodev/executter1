# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

a = User.new
a.full_name=a.username=a.password='thiago'
a.email='thiago@oficina7.com'
a.save

b = User.new
b.full_name=b.username=b.password='flavio'
b.email='flavio@oficina7.com'
b.save

c = User.new
c.full_name=c.username=c.password='tatiane'
c.email='tatiane@oficina7.com'
c.save

a.my_create_post :body=>'thiago escreveu isso xD'
b.my_create_post :body=>'flavio escreveu isso lol'
c.my_create_post :body=>'tatiane escreveu isso :)'


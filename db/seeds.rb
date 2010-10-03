# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
=begin
if Flavour.count == 0
  Flavour.create!(:displaying => true, :name => "Orange",
  :colorBack => "#326496",
  :colorText => "#999999",
  :colorLink1 => "#f90",
  :colorLink2 => "#f60",
  :colorSideBar => "#ff6600",
  :colorSideBarBorder => "#fc0",
  :logo => File.open("db/seed/flavour-orange-logo.png", "r"),
  :background => File.open("db/seed/flavour-orange-bg.jpg", "r"
  )
)
end
=end

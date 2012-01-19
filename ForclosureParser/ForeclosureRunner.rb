require "./ForeclosureParser"
require './ListingDao'

if __FILE__ == $0
  parser = ForeclosureParser.new
  parser.parse(ARGV[0])

  dao = ListingDao.new
  dao.save parser.listings.values

  #parser.listings.each do |key, value|
  #  puts "listing #{value.id} \nAddress: #{value.address} \nPrice #{value.price}"
  #end
end

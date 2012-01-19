require "date"
require "time"
require "mongo"
require "./listing"

class ListingDao
  def save(listings)
    db = Mongo::Connection.new.db("properties")
    coll = db["listings"]

    listings.each{ |listing|
      listing.last_processed = DateTime.now
      coll.insert(listing.to_json)
    }
  end
end
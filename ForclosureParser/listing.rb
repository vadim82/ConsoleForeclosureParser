class Listing
  attr_accessor :price, :address, :id, :raw_data, :other_info, :last_processed

  def to_json()
    {
        'id' => @id,
        'address' => @address,
        'price' => @price,
        'raw_data' => @raw_data,
        "other_info" => @other_info,
        "last_processed" => @last_processed
    }
  end
end
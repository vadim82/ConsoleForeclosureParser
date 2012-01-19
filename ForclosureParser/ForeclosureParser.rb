require 'rubygems'
require 'open-uri'
require 'hpricot'
require "./listing"

class ForeclosureParser

  attr_reader :listings

  def parse(url)
    @listings = {}
    open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}") { |f|

        # Save the response body
        @response = f.read

        doc = Hpricot(@response)
        doc.search("hr").each{ |e|
          if (e.following_siblings[0] != nil)
            listing = Listing.new
            listing.id = e.following_siblings[0].search("b").inner_html
            property_info_nodes = []
            next_node = e.next
            begin
              property_info_nodes.push(next_node) unless next_node.to_html.chomp.empty?
              # match address
              if (next_node.next != nil && next_node.next.name == "br")
                listing.address = parse_address(next_node)
              end

              #match price
              price_match = /\$.*\d/.match(next_node.to_html)
              if (price_match != nil)
                listing.price = price_match[0]
              end

              next_node = next_node.next
            end until next_node == nil || next_node.name == "hr"

            listing.raw_data = property_info_nodes.join().gsub("\r\n\r\n", "")
            @listings[listing.id] = listing
          end
        }
    }


    #get url
  end

  def parse_address(node)
    if (node != nil)
      temp = node.to_html.gsub(/\r\n/," ")
      first_space = temp.index("&nbsp")
      if (first_space != nil && first_space > 0)
        temp = temp[0, first_space].chomp()
        temp.gsub(/- Premise A/, "").chomp()
      end
    end
  end

  private :parse_address


end
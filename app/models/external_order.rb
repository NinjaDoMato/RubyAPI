class ExternalOrder
    attr_accessor :id,
                  :store_id,
                  :date_created,
                  :date_closed,
                  :last_updated,
                  :total_amount,
                  :total_shipping,
                  :total_amount_with_shipping,
                  :paid_amount,
                  :expiration_date,
                  :total_shipping,
                  :status,

                  :shipping,
                  :buyer,
                  :order_items
    
    def initialize
        @id = -1
        @store_id = -1
        @date_created = ""  
        @date_closed = ""
        @last_updated = "" # inicializar as datas como a coisa certa dps
        @expiration_date = ""
        @total_amount = 0.0
        @total_shipping = 0.0
        @total_amount_with_shipping = 0.0
        @paid_amount = 0.0
        @status = ""

        @shipping = Shipping.new
        @buyer = Buyer.new
        @order_items = Array.new

    end

    class OrderItems
        attr_accessor :quantity,
                      :unit_price,
                      :full_unit_price,
    
                      :item

        def initialize
            @quantity = 0,
            @unit_price = 0.0,
            @full_unit_price = 0.0,

            @item = Item.new
        end
            
        class Item
            attr_accessor :id, :title

            def initialize
                @id = -1,
                @title = ""
            end 
        end 
    end

    class Shipping
        attr_accessor :id,
                      :date_created,
                      :shipment_type,

                      :receiver_address

        def initialize
            @id = -1
            @shipment_type = ""
            @date_created = ""

            @receiver_address = Address.new
        end 

        class Address
            attr_accessor :id,
                          :address_line,
                          :street_name,
                          :street_number,
                          :comment,
                          :zip_code,
                          :latitude,
                          :longitude,
                          :receiver_phone,
            
                          :city,
                          :country,
                          :state,
                          :neighborhood,

            def initialize
                @id = -1
                @address_line = ""
                @street_name = ""
                @street_number = ""
                @comment = ""
                @zip_code = ""
                @latitude = 0
                @longitude = 0
                @receiver_phone = ""
                
                @city = City.new
                @country = Country.new
                @state = State.new
                @neighborhood = Neighborhood.new
                
            end 
            
            class City
                attr_accessor :name

                def initialize
                    @name = ""
                end
            end 

            class State
                attr_accessor :name

                def initialize
                    @name = ""
                end
            end 

            class Country

                def initialize
                    @name = ""
                    @id = ""
                end
            end 

            class Neighborhood                
                attr_accessor :id, :name

                def initialize
                    @name = ""
                    @id = ""
                end
            end 
        end 
    end

    class Buyer 
        attr_accessor :id,
                      :nickname,
                      :email,
                      :first_name,
                      :last_name,

                      :phone,
                      :billing_info,

        def initialize
            @id = -1
            @nickname = ""
            @email = ""
            @first_name = ""
            @last_name = ""

            @phone  = Phone.new
            @billing_info = BillingInfo.new
        end 

        class Phone
            attr_accessor :area_code, :number,

            def initialize
                @area_code = 00
                @number = ""
            end 
        end 

        class BillingInfo
            attr_accessor :doc_type, :doc_number,

            def initialize
                @doc_type = ""
                @doc_number = ""
            end 
        end
    end 
end 
require 'date'

class InternalOrder
    attr_accessor :externalCode,
                  :storeId,
                  :subTotal,
                  :deliveryFee,
                  :country,
                  :state,
                  :city,
                  :district,
                  :street,
                  :complement,
                  :latitude,
                  :longitude,
                  :dtOrderCreate,
                  :postalCode,
                  :number,
                  
                  :customer,
                  :items,
                  :payments

    def initialize
        @externalCode = ""
        @storeId = -1
        @deliveryFee = ""
        @total = ""
        @country = ""
        @state = ""
        @city = ""
        @district = ""
        @street = ""
        @complement = ""
        @latitude = 0.0
        @longitude = 0.0
        @dtOrderCreate = ""
        @postalCode = ""
        @number = ""

        @subTotal = 0.0

        @customer = Customer.new
        @items = Array.new
        @payments = Array.new
    end

    def parse(order)
        begin
            # Check if the Json contains the attribute and if it is not null
            @externalCode = !order.id.nil? ? order.id : 0
            @storeId = !order.store_id.nil? ? order.store_id : 0

            @subTotal = !order.total_amount.nil? ? order.total_amount : 0.0
            @total = !order.total_amount_with_shipping.nil? ? order.total_amount_with_shipping : 0.0
            @deliveryFee = !order.total_shipping.nil? ? order.total_shipping : 0.0

            address = order.shipping.receiver_address
            @country = !address.country.nil? ? address.country.id : ""
            @state = !address.state.nil? ? address.state.name : ""
            @city = !address.city.nil? ? address.city.name : ""
            @district = !address.neighborhood.nil? ? address.neighborhood.name : ""
            @street = !address.street_name.nil? ? address.street_name : ""
            @number = !address.street_number.nil? ? address.street_number : ""
            @complement = !address.comment.nil? ? address.comment : ""
            @latitude = !address.latitude.nil? ? address.latitude : ""
            @longitude = !address.longitude.nil? ? address.longitude : ""
            @postalCode = !address.zip_code.nil? ? address.zip_code : ""

            # Convert the order creation date to the expected format
            date = DateTime.parse(order.date_created)
            parsedDate = date.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
            @dtOrderCreate = parsedDate

            # Gets the buyer info
            @customer = Customer.new
            @customer.externalCode = !order.buyer.id.nil? ? order.buyer.id : ""
            @customer.name = !order.buyer.nickname.nil? ? order.buyer.nickname : ""
            @customer.email = !order.buyer.email.nil? ? order.buyer.email : ""

            parsedPhone = "00000000000"

            # Gets the buyer phone and convert it to the expected format
            if !order.buyer.phone.nil?
                phone = order.buyer.phone
                number = phone.number.to_s
                code = phone.area_code.to_s

                number = number.gsub('-', '')
                number = number.gsub('(', '')
                number = number.gsub(')', '')
                number = number.gsub(' ', '')

                code = code.gsub(' ', '')
                code = code.gsub('(', '')
                code = code.gsub(')', '')

                # Remove the area code from the number if necessary
                if(number[0..1] == code && number.length > 10)
                    number = number.sub(code, '')
                end 

                parsedPhone = code.concat(number)      
            end

            @customer.contact = parsedPhone

            # Gets the order items
            @items = Array.new
            order.order_items.each do |orderItem| 
                item = Item.new
                item.externalCode = orderItem.item.id
                item.name = orderItem.item.title
                item.price = orderItem.unit_price
                item.quantity = orderItem.quantity
                item.total = orderItem.quantity * orderItem.unit_price

                item.subItems = Array.new

                @items << item
            end

            # Gets the order payments 
            @payments = Array.new
            order.payments.each do |orderPayment| 
                payment =  Payment.new
                payment.type = orderPayment.payment_type.upcase
                payment.value = orderPayment.total_paid_amount

                payments << payment
            end
        rescue => exception
            raise 
        end
    end 
    
    class Customer
        attr_accessor :externalCode,
                      :name,
                      :email,
                      :contact

        def initialize
            @externalCode = ""
            @name = ""
            @email = ""
            @contact = ""
        end
    end 

    class Item
        attr_accessor :externalCode,
                      :name,
                      :price,
                      :quantity,
                      :total,
                      :subItems

        def initialize
            @externalCode = ""
            @name = ""
            @price = 0.0
            @quantity = 0
            @total = 0.0

            @subItems = Array.new
        end
    end

    class Payment
        attr_accessor :type, :value

        def initialize
            @type = ""
            @value = 0.0
        end
    end 
end
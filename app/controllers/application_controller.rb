require 'json'
require 'rest-client'

class ApplicationController < ActionController::API

    def get
        render json: "Application Controller > It's on!",status: :ok
    end
    
    def parse_order

        begin
            orderJson = JSON.parse(params.to_json, object_class: OpenStruct)
            parsedOrder = InternalOrder.new
            parsedOrder.parse(orderJson)            

            url = "https://delivery-center-recruitment-ap.herokuapp.com/"
            headers = {"X-Sent" => Time.now.strftime("%Hh%M - %d/%m/%Y")}

            result = RestClient.post(url, parsedOrder.to_json, headers)

            render json:{data: parsedOrder}
        
        rescue => exception
            render json: { error: "Erro! Não foi possivel realizar a operação.\n#{exception}", status: 500}
        end
    end
end

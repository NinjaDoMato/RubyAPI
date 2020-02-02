Rails.application.routes.draw do

  get "application", to: "application#get"
  post "application/parse", to: "application#parse_order"

end

Rails.application.routes.draw do
  post '/update_shopify', to: 'stock_updates#update_shopify'
  post '/update_epos', to: 'stock_updates#update_epos'
end

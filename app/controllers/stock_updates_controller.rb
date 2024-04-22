class StockUpdatesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_webhook_signature

  def update_shopify
  end

  def update_epos
    # Parse the incoming webhook payload from Shopify
    webhook_data = JSON.parse(request.body.read)

    # Extract relevant information from the webhook payload
    order_id = webhook_data["id"]
    line_items = webhook_data["line_items"]

    # Process the webhook payload (e.g., update stock levels in Epos Now)
    update_stock_in_epos_now(order_id, line_items)

    # Respond to the webhook request with a success status
    head :ok
  end

  private

  def verify_webhook_signature
    # Extract the signature provided by Shopify from the request headers
    shopify_signature = request.headers["X-Shopify-Hmac-SHA256"]

    # Compute the expected signature using the secret key provided by Shopify
    calculated_signature = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha256"),
      ENV['SHOPIFY_WEBHOOK_SECRET'],
      request.body.read
    )

    # Compare the calculated signature with the signature provided by Shopify
    unless ActiveSupport::SecurityUtils.secure_compare(calculated_signature, shopify_signature)
      # If the signatures don't match, reject the request with a 401 Unauthorized status
      render plain: "Unauthorized", status: :unauthorized
    end
  end
end

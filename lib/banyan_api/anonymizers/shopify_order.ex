defmodule BanyanAPI.Anonymizers.ShopifyOrder do
  @moduledoc """
  as per: https://docs.google.com/spreadsheets/d/1O5Z_jcnNbBS95wMmpbJlinq4Zh32pJ7lGf0F_G7A-1s
    ** For each line item, we probably only need the product id, variant id, price, discount. We probably don't need the multi-currency sections either, which could get pretty bulky.

  |  **Attributes** | **Where do we see this attribute?** | **Should we store it?** | **Why?** | **Sub-properties** | https://help.shopify.com/en/themes/liquid/objects/order |
  | --- | --- | --- | --- | --- | --- |
  |  order.attributes | Shopify objects/order | no | just a list of other attributes, for our purposes we'll already know what we're wanting to store |  |  |
  |  order.billing_address | Shopify objects/order | no | privacy |  |  |
  |  order.cancelled | Shopify objects/order | yes | order reporting |  |  |
  |  order.cancelled_at | Shopify objects/order | no | if we have the order number/id, we can use that to cancel the order for reporting data |  |  |
  |  order.cancel_reason | Shopify objects/order | no | not needed for our products |  |  |
  |  order.cancel_reason_label | Shopify objects/order | no | additional language for same value, not needed for our products |  |  |
  |  order.cart_level_discount_applications | Shopify objects/order | yes | seems very applicable for USO/WHO |  |  |
  |  order.created_at | Shopify objects/order | yes | for reporting (shouldn't use our own determination of timestamp for consistency with Shopify reporting) |  |  |
  |  order.customer | Shopify objects/order | yes, filtered | JUST customer.id for privacy reasons | id |  |
  |  order.customer_url | Shopify objects/order | no | not needed for our products |  |  |
  |  order.discount_applications | Shopify objects/order | yes | seems very applicable for USO/WHO |  |  |
  |  order.email | Shopify objects/order | no | privacy |  |  |
  |  order.financial_status | Shopify objects/order | yes | USO reporting |  |  |
  |  order.financial_status_label | Shopify objects/order | no | additional language for same value, not needed for our products |  |  |
  |  order.fulfillment_status | Shopify objects/order | no | not needed for our products, we don't need to deal with fulfillment data |  |  |
  |  order.fulfillment_status_label | Shopify objects/order | no | additional language for same value, not needed for our products |  |  |
  |  order.line_items | Shopify objects/order | yes, filtered | seems very applicable for USO/WHO | product id, variant id, price, total_discount |  |
  |  order.line_items_subtotal_price | Shopify objects/order | yes | seems very applicable for USO/WHO |  |  |
  |  order.location | Shopify objects/order | yes | POS-specific reporting/logic |  |  |
  |  order.name | Shopify objects/order | no | not sure if we use this anywhere |  |  |
  |  order.note | Shopify objects/order | no | inconsistent data, not useful |  |  |
  |  order.order_number | Shopify objects/order | no | not sure about this one, thought it was effectively an order_id, but the docs say "Returns the integer representation of the order name." which may not be unique? |  |  |
  |  order.order_status_url | Shopify objects/order | no | not needed for our products |  |  |
  |  order.phone | Shopify objects/order | no | privacy |  |  |
  |  order.shipping_address | Shopify objects/order | no | privacy |  |  |
  |  order.shipping_methods | Shopify objects/order | no | not needed for our products (maybe SSB though?) |  |  |
  |  order.shipping_price | Shopify objects/order | yes | Expecting to want to isolate shipping for sales reporting purposes |  |  |
  |  order.subtotal_price | Shopify objects/order | yes | Expecting to want to isolate shipping, taxes, etc for sales reporting purposes |  |  |
  |  order.tags | Shopify objects/order | yes | Offers with discounts contain the "SpecialOffers" tag |  |  |
  |  order.tax_lines | Shopify objects/order | yes | Expecting to want to isolate taxes for sales reporting purposes (do we need line-item or just total as represented by order.tax_price ?) |  |  |
  |  order.tax_price | Shopify objects/order | yes | Expecting to want to isolate taxes for sales reporting purposes |  |  |
  |  order.total_discounts | Shopify objects/order | yes | seems very applicable for USO/WHO |  |  |
  |  order.total_net_amount | Shopify objects/order | yes | seems very applicable for USO/WHO |  |  |
  |  order.total_price | Shopify objects/order | yes | seems very applicable for USO/WHO |  |  |
  |  order.total_refunded_amount | Shopify objects/order | yes | Updating sales reporting on returns |  |  |
  |  order.transactions | Shopify objects/order | no | I don't think we need any of this that we don't effectively get from order financial status |  |  |
  |  order.shipping_lines | webhook doc, segment sample | no | not needed |  |  |
  |  order.closed_at | webhook doc | no |  |  |  |
  |  order.updated_at | webhook doc | no | possible consideration for editable orders? for simplicity sake though I think we should keep the order stats associated with the created_at |  |  |
  |  order.token | webhook doc | no |  |  |  |
  |  order.gateway | webhook doc | no |  |  |  |
  |  order.test | webhook doc | no | maybe yes? should probably exclude sales data where test is true. |  |  |
  |  order.weight | webhook doc | no |  |  |  |
  |  order.total_tax | webhook doc | no |  |  |  |
  |  order.taxes_included | webhook doc, segment sample | no |  |  |  |
  |  order.currency | webhook doc, segment sample | yes | is this legacy and now included as sub-properties of other properties? |  |  |
  |  order.confirmed | webhook doc, Segment sample | no |  |  |  |
  |  order.total_line_items_price | webhook doc, segment sample | yes | how is this different than other price values? |  |  |
  |  order.total_line_items_price_set |  |  | same as .total_line_items_price but with presentment and shop amounts and currency |  |  |
  |  order.buyer_accepts_marketing | webhook doc | no |  |  |  |
  |  order.referring_site | webhook doc,s | no |  |  |  |
  |  order.landing_site | webhook doc | no |  |  |  |
  |  order.landing_site_ref | webhook doc | no |  |  |  |
  |  order.total_price_usd | webhook doc | yes | this would help us by including a standard value representation of an order when neither presentment or shop currencies are in USD |  |  |
  |  order.checkout_id | Segment sample | no |  |  |  |
  |  order.checkout_token | webhook doc, Segment sample | no |  |  |  |
  |  order.reference | webhook doc, Segment sample | no |  |  |  |
  |  order.user_id | webhook doc | no |  |  |  |
  |  order.location_id | webhook doc, Segment sample | no |  |  |  |
  |  order.source_identifier | webhook doc, segment sample | no |  |  |  |
  |  order.source_url | webhook doc, segment sample | no |  |  |  |
  |  order.processed_at | webhook doc | no |  |  |  |
  |  order.app_id | Segment sample | no |  |  |  |
  |  order.browser_ip | Segment sample | no |  |  |  |
  |  order.cart_token | webhook doc, Segment sample | no |  |  |  |
  |  order.checkout_id | Segment sample | no |  |  |  |
  |  order.client_details | Segment sample | no | device details (ip, UA, browser dims) |  |  |
  |  order.customer_locale | Segment sample | no | ex. "en". Could be used to help determine the opportunity for internationalization? |  |  |
  |  order.device_id | Segment sample | no |  |  |  |
  |  order.fullfillments | Segment sample | no | maybe useful later for editable orders |  |  |
  |  order.id | Segment sample | yes |  |  |  |
  |  order.note_attributes | segment sample | no |  |  |  |
  |  order.number | segment sample | no | same as order number, less the 1000 starting point |  |  |
  |  order.payment_gateway_names | segment sample | no | possible means to diagnose issues re 3rd-party checkouts? |  |  |
  |  order.presentment_currency | segment sample | yes | Could be used to help determine value of multi-currency initiatives (when paired with .currency) |  |  |
  |  order.processing_method | segment sample | no |  |  |  |
  |  order.refunds | segment sample | no | as above, not certain we'd ever get this populated on an order_created event |  |  |
  |  order.source_name | segment sample | no |  |  |  |
  |  order.total_discounts_set | segment sample |  | the same as .total_discounts, but includes presentment vs shop amounts and currency |  |  |
  |  order.total_price_set | segment sample |  | the same as .total_price, but includes presentment vs shop amounts and currency |  |  |
  |  order.total_shipping_price_set | segment sample | no | presentment and shop amounts and currencies for data represented in shipping_lines |  |  |
  |  order.total_tax_set | segment sample |  | the same as .total_tax_set, but includes presentment vs shop amounts and currency |  |  |
  |  order.total_tip_received | segment sample | no | didn't realize this was even a thing.... |  |  |
  |  order.total_weight | segment sample | no |  |  |  |
  """
  alias BanyanAPI.Anonymizers.ShopifyAddress

  @valid_order_fields [
    "cancelled",
    "cart_level_discount_applications",
    "created_at",
    "currency",
    "customer",
    "discount_applications",
    "discount_codes",
    "financial_status",
    "id",
    "line_items",
    "line_items_subtotal_price",
    "location",
    "presentment_currency",
    "shipping_address",
    "shipping_price",
    "subtotal_price",
    "tags",
    "tax_lines",
    "tax_price",
    "total_discounts",
    "total_line_items_price",
    "total_line_items_price_set",
    "total_net_amount",
    "total_price",
    "total_price_usd",
    "total_refunded_amount"
  ]

  @valid_line_item_fields [
    "pre_tax_price",
    "price",
    "product_id",
    "quantity",
    "sku",
    "total_discount",
    "variant_id"
  ]

  @spec clean(any()) :: map()
  def clean(order) when is_map(order) do
    order
    |> Map.put("customer", gen_customer(order))
    |> Map.put("line_items", order |> Map.get("line_items", []) |> Enum.map(&clean_line_item/1))
    |> Map.put("shipping_address", order |> Map.get("shipping_address") |> ShopifyAddress.clean())
    |> Map.take(@valid_order_fields)
  end

  def clean(_), do: %{}

  @spec order_fields() :: list(String.t())
  def order_fields, do: @valid_order_fields

  @spec line_item_fields() :: list(String.t())
  def line_item_fields, do: @valid_line_item_fields

  defp gen_customer(order), do: %{"id" => get_in(order, ["customer", "id"])}

  defp clean_line_item(item), do: Map.take(item, @valid_line_item_fields)
end

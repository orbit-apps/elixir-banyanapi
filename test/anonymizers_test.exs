defmodule BanyanAPI.AnonymizersTest do
  use ExUnit.Case

  alias BanyanAPI.Anonymizers.ShopifyAddress
  alias BanyanAPI.Anonymizers.ShopifyOrder

  @address %{
    "first_name" => "name",
    "last_name" => "name",
    "name" => "name",
    "phone" => "phone",
    "address1" => "line 1",
    "address2" => "line 2",
    "kept_field" => "1"
  }

  @customer_id 10

  @customer %{
    "id" => @customer_id,
    "first_name" => "name",
    "last_name" => "name",
    "email" => "email",
    "phone" => "phone",
    "kept_field" => "1",
    "default_address" => @address,
    "addresses" => [@address]
  }

  @order %{
    "email" => "email",
    "contact_email" => "contact_email",
    "kept_field" => "1",
    "customer" => @customer,
    "billing_address" => @address,
    "shipping_address" => @address,
    "fulfillments" => [%{"id" => 1}, %{"id" => 2}]
  }

  describe "clean_address" do
    test "cleans all fields" do
      cleaned_address = ShopifyAddress.clean(@address)

      address_keys = Map.keys(@address) -- ShopifyAddress.address_fields()

      Enum.each(address_keys, fn field ->
        assert not Map.has_key?(cleaned_address, field)
      end)
    end
  end

  describe "ShopifyOrder.clean" do
    test "cleans all fields" do
      cleaned_order = ShopifyOrder.clean(@order)

      order_keys = Map.keys(@order) -- ShopifyOrder.order_fields()

      Enum.each(order_keys, fn field ->
        assert not Map.has_key?(cleaned_order, field)
      end)
    end

    test "customer only consists of id" do
      cleaned_order = ShopifyOrder.clean(@order)

      assert Map.get(cleaned_order, "customer") == %{"id" => @customer_id}
    end
  end
end

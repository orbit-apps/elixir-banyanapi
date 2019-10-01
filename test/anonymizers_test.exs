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

  @cleaned_address_fields [
    "first_name",
    "last_name",
    "name",
    "phone",
    "address1",
    "address2"
  ]

  @cleaned_order_fields ["email", "contact_email", "fulfillments"]

  def assert_clean_address(address) do
    Enum.each(@cleaned_address_fields, fn field ->
      assert not Map.has_key?(address, field)
    end)

    assert Map.has_key?(address, "kept_field")
  end

  describe "clean_address" do
    test "cleans all fields" do
      cleaned_address = ShopifyAddress.clean(@address)

      assert_clean_address(cleaned_address)
    end
  end

  describe "ShopifyOrder.clean" do
    test "cleans all fields" do
      cleaned_order = ShopifyOrder.clean(@order)

      Enum.each(@cleaned_order_fields, fn field ->
        assert not Map.has_key?(cleaned_order, field)
      end)

      cleaned_order
      |> Map.get("billing_address")
      |> assert_clean_address()

      cleaned_order
      |> Map.get("shipping_address")
      |> assert_clean_address()

      assert Map.has_key?(cleaned_order, "kept_field")
    end

    test "customer only consists of id" do
      cleaned_order = ShopifyOrder.clean(@order)

      assert Map.get(cleaned_order, "customer") == %{"id" => @customer_id}
    end
  end
end

class AreaResponse {
  final int id;
  final String areaName;
  final String postCode;
  final List<ShippingChargeResponse> shippingCharge;

  AreaResponse({
    required this.id,
    required this.areaName,
    required this.postCode,
    required this.shippingCharge,
  });

  factory AreaResponse.fromJson(Map<String, dynamic> json) {
    return AreaResponse(
      id: json['id'],
      areaName: json['area_name'],
      postCode: json['post_code'],
      shippingCharge: List<ShippingChargeResponse>.from(
        json['shipping_charge'].map((x) => ShippingChargeResponse.fromJson(x)),
      ),
    );
  }
}

class ShippingChargeResponse {
  final int id;
  final dynamic areaId;
  final String orderFrom;
  final String orderTo;
  final String shippingCharge;
  final String showShippingCharge;
  final String deliveryCharge;
  final String showDeliveryCharge;

  ShippingChargeResponse({
    required this.id,
    required this.areaId,
    required this.orderFrom,
    required this.orderTo,
    required this.shippingCharge,
    required this.showShippingCharge,
    required this.deliveryCharge,
    required this.showDeliveryCharge,
  });

  factory ShippingChargeResponse.fromJson(Map<String, dynamic> json) {
    return ShippingChargeResponse(
      id: json['id'],
      areaId: json['area_id'],
      orderFrom: json['order_from'],
      orderTo: json['order_to'] ?? '',
      shippingCharge: json['shipping_charge'],
      showShippingCharge: json['show_shipping_charge'],
      deliveryCharge: json['delivery_charge'],
      showDeliveryCharge: json['show_delivery_charge'],
    );
  }
}

class AddressResponse {
  final int id;
  final String addressName;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String country;
  final String city;
  final String zip;
  final String address;
  final dynamic areaId;
  // final AreaResponse area;

  AddressResponse({
    required this.id,
    required this.addressName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.country,
    required this.city,
    required this.zip,
    required this.address,
    required this.areaId,
    // required this.area,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      id: json['id'],
      addressName: json['address_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      country: json['country'],
      city: json['city'],
      zip: json['zip'],
      address: json['address'],
      areaId: json['area_id'],
      // area: AreaResponse.fromJson(json['area']),
    );
  }
}

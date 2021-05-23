// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// ClassExtrasGenerator
// **************************************************************************

extension $Order on Order {
  String details() => '[Order] id=$id, name=$name, price=$price';
  bool compare(Object other) =>
      other is Order &&
      id == other.id &&
      name == other.name &&
      price == other.price;
  int calculateHash() => id.hashCode + name.hashCode + price.hashCode;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    json['id'] as int?,
    json['name'] as String?,
    json['price'] as String?,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
    };

// **************************************************************************
// SerializeGenerator
// **************************************************************************

extension $OrderSerializer on Order {
  static Order fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

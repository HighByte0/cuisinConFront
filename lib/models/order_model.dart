import 'dart:ffi';

import 'package:food_delivery_flutter/models/address_model.dart';
import 'package:intl/intl.dart';

class OrderModel {
  late int id;
  late int userId;
  double? orderAmount;
  String? orderStatus;
  String? paymentStatus;
  double? totalTaxAmount;
  String? orderNote;
  String? createdAt;
  String? updatedAt;
  double? deliveryCharge;
  String? scheduleAt;
  String? otp;
  String? pending;
  String? accepted;
  String? confirmed;
  String? processing;
  String? handover;
  String? pickedUp;
  String? delivered;
  String? canceled;
  String? scheduled;
  String? failed;
  int? detailsCount;
  AddressModel? deliveryAddress;  // Updated to AddressModel

  OrderModel({
    required this.id,
    required this.userId,
    this.orderAmount,
    this.orderStatus,
    this.paymentStatus,
    this.totalTaxAmount,
    this.orderNote,
    this.createdAt,
    this.updatedAt,
    this.deliveryCharge,
    this.scheduleAt,
    this.otp,
    this.pending,
    this.accepted,
    this.confirmed,
    this.processing,
    this.handover,
    this.pickedUp,
    this.delivered,
    this.canceled,
    this.scheduled,
    this.failed,
    this.detailsCount,
    this.deliveryAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      orderAmount: json['order_amount']?.toDouble(),
      orderStatus: json['order_status'],
      paymentStatus: json['payment_status'] ?? "pending",
      totalTaxAmount: json['total_tax_amount']?.toDouble(),
      orderNote: json['order_note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deliveryCharge: json['delivery_charge']?.toDouble(),
      scheduleAt: json['schedule_at'],
      otp: json['otp'],
      pending: json['pending'],
      accepted: json['accepted'],
      confirmed: json['confirmed'],
      processing: json['processing'],
      handover: json['handover'],
      pickedUp: json['picked_up'],
      delivered: json['delivered'],
      canceled: json['canceled'],
      scheduled: json['scheduled'].toString(),
      failed: json['failed'],
      detailsCount: json['details_count'],
        deliveryAddress: (json['delivery_address'] != null && json['delivery_address'] is Map<String, dynamic>)
        ? AddressModel.fromJson(json['delivery_address'])
        : null,
    );
  }
// 1:56:11 time i knew me in future will forget >>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_amount': orderAmount,
      'order_status': orderStatus,
      'payment_status': paymentStatus,
      'total_tax_amount': totalTaxAmount,
      'order_note': orderNote,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'delivery_charge': deliveryCharge,
      'schedule_at': scheduleAt,
      'otp': otp,
      'pending': pending,
      'accepted': accepted,
      'confirmed': confirmed,
      'processing': processing,
      'handover': handover,
      'picked_up': pickedUp,
      'delivered': delivered,
      'canceled': canceled,
      'scheduled': scheduled,
      'failed': failed,
      'details_count': detailsCount,
      'delivery_address': deliveryAddress?.toJson(),
    };
  }
}

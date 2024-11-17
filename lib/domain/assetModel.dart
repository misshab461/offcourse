import 'package:cloud_firestore/cloud_firestore.dart';

class Assetmodel {
  String? id;
  String? name;
  String? category;
  String? serialNumber;
  String? status;
  String? purchaseDate;

  Assetmodel({
    this.id,
    required this.name,
    required this.category,
    required this.purchaseDate,
    required this.serialNumber,
    this.status,
  });

  factory Assetmodel.fromfirestore(DocumentSnapshot data) {
    return Assetmodel(
      name: data['username'],
      serialNumber: data['serialNumber'],
      category: data['category'],
      purchaseDate: data['purchaseDate'],
      id: data['id'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toFirestrore() {
    return {
      'name': name,
      'status': status,
      'serialNumber': serialNumber,
      'category': category,
      'purchaseDate': purchaseDate,
    };
  }
}

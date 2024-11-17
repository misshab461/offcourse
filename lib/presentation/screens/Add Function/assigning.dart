import 'package:app/controller/allController.dart';
import 'package:app/presentation/screens/Add%20Function/addasset.dart';
import 'package:app/presentation/widgets/constance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

Future<void> assignAssetToStaff(context) async {
  ValueNotifier<String?> assetNotifier = ValueNotifier(null);
  ValueNotifier<String?> staffNotifier = ValueNotifier(null);
  ValueNotifier<String?> assetid = ValueNotifier(null);
  ValueNotifier<String?> staffid = ValueNotifier(null);
  final storeAsset = FirebaseFirestore.instance.collection('Asset');
  final storeStaff = FirebaseFirestore.instance.collection('Staff');

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        height: 350,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.teal.shade600),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal.shade50),
                child: const Center(
                  child: Text(
                    'Select Staff And Asset To Assign',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              h20,
              h20,
              StreamBuilder<QuerySnapshot>(
                stream: storeStaff.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data?.docs == null) {
                    return Text('No Values');
                  }

                  return ValueListenableBuilder(
                    valueListenable: staffNotifier,
                    builder: (context, value, child) {
                      return Container(
                        padding: const EdgeInsets.all(15),
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.teal.withOpacity(.1),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: Colors.teal.shade50,
                          isDense: true,
                          autofocus: true,
                          underline: const SizedBox(),
                          hint: const Text('Select Staff'),
                          value: value,
                          onChanged: (newValue) {
                            staffNotifier.value = newValue;
                            staffid.value = snapshot.data?.docs.firstWhere(
                                (doc) => doc['name'] == newValue)['id'];
                          },
                          items: snapshot.data?.docs.map((doc) {
                            bool isAssigned = doc['assigned'] ?? false;

                            return DropdownMenuItem<String>(
                              enabled: !isAssigned,
                              value: doc['name'] ?? 'no values',
                              child: Text(doc['name'] ?? 'no values'),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
              // Dropdown to select asset
              h20,
              // Dropdown to select staff
              ValueListenableBuilder(
                valueListenable: assetNotifier,
                builder: (context, value, child) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: storeAsset.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data?.docs == null) {
                        return const Text('No Values');
                      }
                      return Container(
                        padding: const EdgeInsets.all(15),
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.teal.withOpacity(.1),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.teal.shade50,
                          isExpanded: true,
                          isDense: true,
                          autofocus: true,
                          underline: const SizedBox(),
                          hint: const Text('Select Asset'),
                          value: value,
                          onChanged: (newValue) {
                            assetNotifier.value = newValue;
                            assetid.value = snapshot.data?.docs.firstWhere(
                                (doc) => doc['name'] == newValue)['id'];
                          },
                          items: snapshot.data?.docs.map((doc) {
                            bool isAssigned = doc['assigned'] ?? false;
                            return DropdownMenuItem<String>(
                              enabled: !isAssigned,
                              value: doc['name'] ?? 'no values',
                              child: Text(doc['name'] ?? 'no values'),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
              h20,

              // Text field for additional details
              Consumer<AuthNotifier>(
                builder: (context, provider, _) {
                  return SlideAction(
                    key: globalKey,
                    sliderButtonIconSize: 15,
                    height: 60,
                    elevation: 5,
                    textStyle: const TextStyle(fontSize: 14),
                    innerColor: Colors.teal.shade200,
                    outerColor: Colors.teal.shade50,
                    text: 'Swipe To Assign',
                    onSubmit: () async {
                      if (assetNotifier.value != null &&
                          staffNotifier.value != null) {
                        await provider
                            .assign(
                          asset: assetid.value,
                          staff: staffid.value,
                          A: assetNotifier.value,
                          S: staffNotifier.value,
                        )
                            .then(
                          (_) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: 'Asset assigned successfully!');
                          },
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please select both asset and staff member.');
                      }

                      return null;
                    },
                    borderRadius: 12,
                  );
                },
              ),
              h20,
            ],
          ),
        ),
      );
    },
  );
}

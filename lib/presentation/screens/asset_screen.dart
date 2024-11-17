import 'dart:developer';

import 'package:app/controller/allController.dart';
import 'package:app/domain/assetModel.dart';
import 'package:app/presentation/widgets/constance.dart';
import 'package:app/presentation/widgets/textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AssetScreen extends StatelessWidget {
  AssetScreen({super.key});
  final store = FirebaseFirestore.instance.collection('Asset');
  final assign = FirebaseFirestore.instance.collection('AssetAssign');

  final assets = [
    'Laptop',
    'Keyboard',
    'Printer',
    'Cable',
    'Wifi box',
    'Charger',
    'Camera',
    'Headphone'
  ];

  final nameCr = TextEditingController();

  final serialNumber = TextEditingController();
  ValueNotifier<String?> dropdown = ValueNotifier(null);
  ValueNotifier<String?> datepick = ValueNotifier(null);

  final Map<String, String> categoryImages = {
    'Laptop':
        'https://images.pexels.com/photos/205421/pexels-photo-205421.jpeg?cs=srgb&dl=pexels-craigmdennis-205421.jpg&fm=jpg',
    'Keyboard':
        'https://media.wired.com/photos/6621af2c255c13bb362f5337/master/w_960,c_limit/logitech-pro-x-tkl-keyboard-Reviewer-Photo-SOURCE-Eric-Ravenscraft.jpg',
    'Printer':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3_Ut3HUslYHQ_2q1Sc_QVkgCYWteqpj9-Qg&s',
    'Cable': 'https://m.media-amazon.com/images/I/61TTXSYTLgL.jpg',
    'Wifi box':
        'https://www.efeel.info/mini/w-960-720/data/product/c2506/wifi-box-endoskopy2.jpg',
    'Charger':
        'https://www.portronics.com/cdn/shop/files/Artboard1_5f868df7-e28d-4e43-a42d-62be1fdb81b7.jpg?v=1722426514',
    'Camera':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXEc_6Wy-rRgk9txQcjoLOR7EfuSGS72obXEsUenLnxSDM71z7u8mh0tl0RSA4PAEqKBw&usqp=CAU',
    'Headphone':
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQTQ3?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1687660671363',
  };
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Company Assets'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      body: StreamBuilder(
        stream: store.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred.'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('asset/oops.avif'),
                const Text(
                  'There Is No Added Assets Here\nPlease Add Assets',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                )
              ],
            );
          }

          final result = snapshot.data?.docs;
          return ListView.separated(
            itemCount: result?.length ?? 0,
            itemBuilder: (context, index) {
              final datas = result?[index];
              final category = datas?['category'];
              final imageUrl = categoryImages[category] ??
                  'https://cdn.pixabay.com/photo/2021/09/20/19/10/error-6641731_1280.png';

              return Slidable(
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.teal.shade50,
                      onPressed: (context) {
                        datepick.value = datas?['purchaseDate'];
                        dropdown.value = datas?['category'];
                        updateAsset(context, mq, datas);
                      },
                      icon: Icons.edit,
                    ),
                    SlidableAction(
                      backgroundColor: Colors.teal.shade50,
                      onPressed: (context) async {
                        await store.doc(datas!.id).delete();
                      },
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    assetPress(context, datas, mq);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.teal,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          height: 110,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                return debugPrint(
                                    'Image load failed: $exception');
                              },
                            ),
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Item : ${datas?['name'] ?? ''}',
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'Category : ${datas?['category'] ?? ''}',
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'Status : ${datas?['status'] ?? ''}',
                              style: TextStyle(
                                color: datas?['assigned']
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }

  PersistentBottomSheetController updateAsset(BuildContext context, Size mq,
      QueryDocumentSnapshot<Map<String, dynamic>>? datas) {
    return showBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: mq.height * .4,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        TextForm(
                          controller: nameCr..text = datas?['name'],
                          hint: 'Asset Name',
                        ),
                        h10,
                        TextForm(
                          controller: serialNumber
                            ..text = datas?['serialNumber'],
                          hint: 'Serial Number',
                          keytype: TextInputType.emailAddress,
                        ),
                        h10,
                        Container(
                          padding: const EdgeInsets.all(15),
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.teal.withOpacity(.1),
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: dropdown,
                            builder: (context, value, child) {
                              return DropdownButton<String?>(
                                isExpanded: true,
                                isDense: true,
                                autofocus: true,
                                underline: const SizedBox(),
                                value: value == '' ? null : value,
                                hint: const Text('select one asset'),
                                items: assets.map<DropdownMenuItem<String?>>(
                                  (e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    );
                                  },
                                ).toList(),
                                onChanged: (value) {
                                  dropdown.value = value!;
                                },
                              );
                            },
                          ),
                        ),
                        h10,
                        ValueListenableBuilder(
                          valueListenable: datepick,
                          builder: (context, value, child) {
                            log(datepick.value.toString());
                            return Container(
                              padding: const EdgeInsets.all(15),
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.teal.withOpacity(.1),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2024),
                                      lastDate: DateTime.now());
                                  print(date.toString());
                                  final finaldate =
                                      DateFormat.yMMMMd('en_US').format(date!);
                                  datepick.value = finaldate;
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      datepick.value == null
                                          ? '${datas?['purchaseDate']}'
                                          : '${datepick.value}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.arrow_downward_rounded)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        h10,
                        Consumer<AuthNotifier>(
                          builder: (context, provider, child) {
                            return provider.loading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: () async {
                                      final asset = Assetmodel(
                                          name: nameCr.text.trim(),
                                          category: dropdown.value,
                                          purchaseDate: datepick.value,
                                          serialNumber:
                                              serialNumber.text.trim());

                                      await provider
                                          .updateAsset(asset, datas?['id'])
                                          .then(
                                        (_) {
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                              msg: 'Asset Update Successfully');
                                        },
                                      );
                                    },
                                    child: const Text('Update'));
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> assetPress(BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>>? datas, Size mq) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 500,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CachedNetworkImage(
                    height: 150,
                    width: double.infinity,
                    imageUrl:
                        "https://www.ewaste1.com/wp-content/uploads/2021/04/Guaranteed-CAM.jpg",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  h20,
                  Text(
                    'Item :   ${datas?['category']}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Serial No : ${datas?['serialNumber']}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Purchase Date :   ${datas?['purchaseDate']}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  h10,
                  SizedBox(
                    height: mq.height * .25,
                    width: double.infinity,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('AssetAssign')
                          .doc(datas?['id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final result = snapshot.data;

                        return Text(
                          datas?['assigned'] == true
                              ? 'This Product Currently Assigned To:\n${result?['staffName'] ?? ''}'
                              : 'This Product Is Available',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

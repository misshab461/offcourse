import 'dart:developer';

import 'package:app/controller/allController.dart';
import 'package:app/presentation/widgets/constance.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum Condition { good, damaged, needsRepair }

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final company = [
    'https://media.istockphoto.com/id/184962061/photo/business-towers.jpg?s=612x612&w=0&k=20&c=gLQLQ9lnfW6OnJVe39r516vbZYupOoEPl7P_22Un6EM=',
    'https://media.graphassets.com/resize=fit:crop,width:1280,height:660/4CumAO48R8GInLQCwWbj',
    'https://bsmedia.business-standard.com/_media/bs/img/article/2019-06/05/full/1559674671-2023.jpg',
    'https://images.javatpoint.com/difference/images/difference-between-firm-and-company.png',
  ];
  final commentCr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = FirebaseFirestore.instance.collection('AssetAssign');
    final mq = MediaQuery.of(context).size;

    ValueNotifier<bool> isExpand = ValueNotifier(false);
    ValueNotifier<String?> datepick = ValueNotifier(null);
    ValueNotifier<Condition> isSelected =
        ValueNotifier<Condition>(Condition.good);

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('Company Dashboard'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            height: mq.height * .05,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.teal,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Consumer<AuthNotifier>(
              builder: (context, provider, _) {
                final user = provider.currentUser;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hi ${user?.displayName ?? 'User'}',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(user?.photoURL ??
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png'),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: mq.height * .2,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: company.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: mq.width * .7,
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: company[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return w10;
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.teal,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: StreamBuilder(
                stream: store.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('ERROR OCCURED'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Image.asset('asset/oops.avif'),
                          const Text(
                            'There Is No Assigned Items Here',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      final result = snapshot.data?.docs[index];
                      final date = result?['assignedDate'].toString();
                      final time = date!.split(' ');

                      return InkWell(
                        onTap: () {
                          returnLogic(context, mq, isExpand, isSelected,
                              datepick, result, store);
                        },
                        splashColor: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: mq.height * .12,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                        image: NetworkImage(
                                            'https://www.myndsolution.com/images/fixedM-bg-thumb.jpg'),
                                        fit: BoxFit.cover),
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 130,
                                  child: Text(
                                    '${result?['assetName'] ?? ''}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Image.asset(
                                  'asset/arrow.png',
                                  height: 30,
                                ),
                                const Text('Assigned On'),
                                Text(time[0] + time[1] + time[2],
                                    overflow: TextOverflow.clip),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: mq.height * .12,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                        image: NetworkImage(
                                            'https://thumbs.dreamstime.com/b/default-internet-avatar-old-photo-frame-style-30001144.jpg'),
                                        fit: BoxFit.cover),
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 130,
                                  child: Text(
                                    '${result?['staffName'] ?? ''}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  PersistentBottomSheetController returnLogic(
      BuildContext context,
      Size mq,
      ValueNotifier<bool> isExpand,
      ValueNotifier<Condition> isSelected,
      ValueNotifier<String?> datepick,
      QueryDocumentSnapshot<Map<String, dynamic>>? result,
      CollectionReference<Map<String, dynamic>> store) {
    return showBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: mq.height * .4,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                valueListenable: isExpand,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          isExpand.value = !value;
                        },
                        trailing: Icon(isExpand.value
                            ? Icons.arrow_upward
                            : Icons.arrow_downward),
                        leading: const Icon(Icons.handshake),
                        title: Text('Return To Company'),
                      ),
                      h10,
                      AnimatedContainer(
                        onEnd: () {
                          commentCr.clear();
                        },
                        decoration: BoxDecoration(
                          color: isExpand.value
                              ? Colors.grey.withOpacity(.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        duration: const Duration(milliseconds: 500),
                        height: isExpand.value ? mq.height * .3 : 0,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                h10,
                                const Text(
                                  'Select Asset Condition',
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                h10,
                                ValueListenableBuilder(
                                  valueListenable: isSelected,
                                  builder: (context, value, child) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Radio<Condition>(
                                          value: Condition.good,
                                          groupValue: isSelected.value,
                                          onChanged: (value) {
                                            if (value != null) {
                                              isSelected.value = value;
                                            }
                                          },
                                        ),
                                        const Text('Good'),
                                        Radio<Condition>(
                                          value: Condition.damaged,
                                          groupValue: isSelected.value,
                                          onChanged: (value) {
                                            if (value != null) {
                                              isSelected.value = value;
                                            }
                                          },
                                        ),
                                        const Text('Damaged'),
                                        Radio<Condition>(
                                          value: Condition.needsRepair,
                                          groupValue: isSelected.value,
                                          onChanged: (value) {
                                            if (value != null) {
                                              isSelected.value = value;
                                            }
                                          },
                                        ),
                                        const Text('Needs Repair'),
                                      ],
                                    );
                                  },
                                ),
                                h10,
                                TextFormField(
                                  controller: commentCr,
                                  decoration: const InputDecoration(
                                    hintMaxLines: 3,
                                    hintText: 'Write Your Feedback',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.teal),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                        bottom: Radius.circular(10),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.teal),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                        bottom: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                h20,
                                Consumer<AuthNotifier>(
                                  builder: (context, provider, _) {
                                    return provider.loading
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : InkWell(
                                            onTap: () async {
                                              if (isSelected
                                                      .value.name.isNotEmpty ||
                                                  commentCr.text.isNotEmpty) {
                                                final rs = isSelected.value
                                                    .toString()
                                                    .split('.');

                                                log(rs[1]);
                                                await provider
                                                    .returnAsset(
                                                  staff:
                                                      result?['staffId'] ?? '',
                                                  condition: rs[1],
                                                  date: datepick.value,
                                                  feedback: commentCr.text,
                                                  asset:
                                                      result?['assetId'] ?? '',
                                                  staffId:
                                                      result?['staffId'] ?? '',
                                                )
                                                    .then(
                                                  (_) {
                                                    store
                                                        .doc(result?.id)
                                                        .delete();

                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Return Successfully');
                                                    isExpand.value = false;
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: 'Error');
                                              }
                                            },
                                            child: Container(
                                              height: 45,
                                              width: mq.width * .4,
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.teal.withOpacity(.8),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Return',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

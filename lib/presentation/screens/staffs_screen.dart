import 'dart:developer';

import 'package:app/controller/allController.dart';
import 'package:app/domain/userModel.dart';
import 'package:app/presentation/login/signin.dart';
import 'package:app/presentation/widgets/constance.dart';
import 'package:app/presentation/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class StaffsScreen extends StatefulWidget {
  StaffsScreen({super.key});

  @override
  State<StaffsScreen> createState() => _StaffsScreenState();
}

final namecr = TextEditingController();
final email = TextEditingController();
final mobile = TextEditingController();
final department = TextEditingController();

class _StaffsScreenState extends State<StaffsScreen> {
  final store = FirebaseFirestore.instance.collection('Staff');

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Staffs'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthNotifier().signout();
              Navigator.pushNamedAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                LoginScreen.loginRt,
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          )
        ],
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
                  'There Is No Added Staffs Here\nPlease Add Staffs',
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: result?.length ?? 0,
              itemBuilder: (context, index) {
                final datas = result?[index];

                return Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.teal.shade50,
                        onPressed: (context) {
                          updateStaff(context, mq, datas);
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
                  child: ListTile(
                    trailing: const Icon(CupertinoIcons.arrow_left),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 500,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage('asset/avathar.png'),
                                  ),
                                  h20,
                                  Text(
                                    'Name : ${datas?['name']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Email : ${datas?['email']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Phone Number : ${datas?['mobile']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Joined At : ${datas?['joinDate']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  h10,
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('asset/avathar.png'),
                    ),
                    title: Text(
                      datas?['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      'Department : ${datas?['department']}',
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          );
        },
      ),
    );
  }

  PersistentBottomSheetController updateStaff(BuildContext context, Size mq,
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
            child: Column(
              children: [
                TextForm(
                    hint: '',
                    controller: namecr..text = '${datas?['name']}',
                    label: 'name'),
                h10,
                TextForm(
                    hint: '',
                    controller: email..text = '${datas?['email']}',
                    label: 'email'),
                h10,
                TextForm(
                    hint: '',
                    controller: mobile..text = '${datas?['mobile']}',
                    label: 'mobile'),
                h10,
                TextForm(
                    hint: '',
                    controller: department..text = '${datas?['department']}',
                    label: 'department'),
                h10,
                Consumer<AuthNotifier>(builder: (context, provider, _) {
                  return provider.loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            final user = UserModel(
                              name: namecr.text.trim(),
                              email: email.text.trim(),
                              number: mobile.text.trim(),
                              department: department.text.trim(),
                            );
                            log('from staff ${datas?['id']}');
                            await provider.update(user, '${datas?['id']}').then(
                              (_) {
                                Fluttertoast.showToast(
                                    msg: 'Update Successfully');
                                Navigator.pop(context);
                              },
                            );
                          },
                          child: const Text('Update'));
                })
              ],
            ),
          ),
        );
      },
    );
  }
}

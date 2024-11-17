import 'package:app/controller/allController.dart';
import 'package:app/domain/userModel.dart';
import 'package:app/presentation/widgets/constance.dart';
import 'package:app/presentation/widgets/textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  static const registerRt = 'register';

  final globalKey = GlobalKey<FormState>();
  final nameCr = TextEditingController();
  final emailCr = TextEditingController();
  final mobileCr = TextEditingController();
  final department = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: globalKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  h10,
                  CachedNetworkImage(
                    height: 200,
                    width: double.infinity,
                    imageUrl:
                        "https://www.commlabindia.com/hubfs/blogs/learning-development-strategies-staff-augmentation.jpg",
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  h20,
                  TextForm(
                    controller: nameCr,
                    hint: 'Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter your name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  h10,
                  TextForm(
                    controller: emailCr,
                    hint: 'email',
                    keytype: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter your email';
                      } else if (value.endsWith('@gmail.com') == false) {
                        return 'enter valid email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  h10,
                  TextForm(
                    controller: mobileCr,
                    hint: 'mobile number',
                    keytype: TextInputType.number,
                    maxLength: 10,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter your number';
                      } else if (value.length != 10) {
                        return 'please enter valid number';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextForm(
                    controller: department,
                    hint: 'Department',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter your Department';
                      } else {
                        return null;
                      }
                    },
                  ),
                  h10,
                  h10,
                  h20,
                  Consumer<AuthNotifier>(builder: (context, data, _) {
                    return data.loading == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.teal.shade900,
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              if (globalKey.currentState!.validate()) {
                                try {
                                  final model = UserModel(
                                    name: nameCr.text.trim(),
                                    email: emailCr.text.trim(),
                                    number: mobileCr.text.trim(),
                                    department: department.text.trim(),
                                  );
                                  await data.addStaff(user: model);
                                  Navigator.pop(context);
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Center(child: Text(e.toString())),
                                      behavior: SnackBarBehavior.floating,
                                      padding: const EdgeInsets.all(10),
                                      backgroundColor: Colors.teal.shade900,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              height: 48,
                              width: mq.width,
                              decoration: BoxDecoration(
                                color: Colors.teal.shade700,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

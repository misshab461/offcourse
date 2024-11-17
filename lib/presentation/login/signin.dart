import 'package:app/controller/allController.dart';
import 'package:app/presentation/main_page.dart';
import 'package:app/presentation/widgets/constance.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const loginRt = 'login';

  final email = TextEditingController();
  final passCr = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            height: mq.height * .6,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('asset/company.avif'),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                width: 1,
                color: Colors.teal,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          h10,
          Text(
            "Let's Login Your Account",
            style: TextStyle(
              color: Colors.teal.shade600,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          h20,
          Consumer<AuthNotifier>(
            builder: (context, data, _) {
              return data.loading
                  ? const Center(child: CircularProgressIndicator())
                  : InkWell(
                      onTap: () async {
                        final login = await data.googlesignin();
                        if (login!.email!.isNotEmpty) {
                          await Fluttertoast.showToast(
                            msg: 'you are logged in with ${login.email}',
                          ).then(
                            (value) {
                              Navigator.pushReplacementNamed(
                                  context, MainPage.mainrt);
                            },
                          );
                        } else {
                          return;
                        }
                      },
                      focusColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 70,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          color: Colors.grey.withOpacity(.1),
                        ),
                        child: const Row(
                          children: [
                            Image(
                              image: AssetImage('asset/google-95-512.png'),
                              height: 50,
                            ),
                            w10,
                            Text(
                              'Login with Google',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}

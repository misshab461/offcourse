import 'package:app/controller/allController.dart';
import 'package:app/controller/bottom.dart';
import 'package:app/firebase_options.dart';
import 'package:app/presentation/screens/Add%20Function/addasset.dart';
import 'package:app/presentation/login/signin.dart';
import 'package:app/presentation/screens/Add%20Function/addstaff.dart';
import 'package:app/presentation/login/splash_Screen.dart';
import 'package:app/presentation/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNotifier>(
          create: (context) => BottomNotifier(),
        ),
        ChangeNotifierProvider<AuthNotifier>(
          create: (context) => AuthNotifier(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'firebase',
        routes: {
          LoginScreen.loginRt: (context) => LoginScreen(),
          RegisterScreen.registerRt: (context) => RegisterScreen(),
          MainPage.mainrt: (context) => MainPage(),
          AddassetScreen.assetrt: (context) => AddassetScreen(),
        },
        theme: ThemeData(
          primaryColor: Colors.teal.shade50,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

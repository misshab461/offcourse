import 'package:app/controller/bottom.dart';
import 'package:app/presentation/screens/Add%20Function/addasset.dart';
import 'package:app/presentation/screens/Add%20Function/addstaff.dart';
import 'package:app/presentation/screens/Add%20Function/assigning.dart';
import 'package:app/presentation/screens/asset_screen.dart';
import 'package:app/presentation/screens/home.dart';
import 'package:app/presentation/screens/staffs_screen.dart';
import 'package:app/presentation/widgets/bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  static const mainrt = 'mainrt';
  MainPage({super.key});
  final screens = [
    HomeScreen(),
    AssetScreen(),
    StaffsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BottomNotifier>();
    return Scaffold(
      bottomNavigationBar: MyBottomNav(),
      body: Consumer<BottomNotifier>(
        builder: (context, data, _) {
          return screens[data.counter];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (provider.index == 0) {
            assignAssetToStaff(context);
          } else if (provider.index == 1) {
            Navigator.pushNamed(context, AddassetScreen.assetrt);
          } else if (provider.index == 2) {
            Navigator.pushNamed(context, RegisterScreen.registerRt);
          } else {
            return;
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

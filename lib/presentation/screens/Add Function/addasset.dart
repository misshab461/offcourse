import 'package:app/controller/allController.dart';
import 'package:app/domain/assetModel.dart';
import 'package:app/presentation/widgets/constance.dart';
import 'package:app/presentation/widgets/textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddassetScreen extends StatefulWidget {
  AddassetScreen({super.key});
  static const assetrt = 'asset';

  @override
  State<AddassetScreen> createState() => _AddassetScreenState();
}

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

final globalKey = GlobalKey<FormState>();

final nameCr = TextEditingController();

final serialNumber = TextEditingController();

String? status;

ValueNotifier<XFile> imageNotifier = ValueNotifier(XFile(''));
ValueNotifier<String?> dropdown = ValueNotifier(null);
ValueNotifier<String?> datepick = ValueNotifier(null);

class _AddassetScreenState extends State<AddassetScreen> {
  @override
  @override
  void dispose() {
    imageNotifier.value = XFile('');
    dropdown.value = null;
    datepick.value = null;
    nameCr.clear();
    serialNumber.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: globalKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CachedNetworkImage(
                    height: 200,
                    width: double.infinity,
                    imageUrl:
                        "https://www.uniwide.co.uk/wp-content/uploads/2024/10/company-name-check.jpg",
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  h20,

                  h20,
                  TextForm(
                    controller: nameCr,
                    hint: 'Asset Name',
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
                    controller: serialNumber,
                    hint: 'Serial Number',
                    keytype: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter your email';
                      } else {
                        return null;
                      }
                    },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                datepick.value == null
                                    ? 'Select Purchase Date'
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
                  h20,
                  Consumer<AuthNotifier>(
                    builder: (context, data, _) {
                      return data.loading == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.teal.shade900,
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (dropdown.value == null ||
                                    datepick.value == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Center(
                                          child: Text('Fill All Fields')),
                                      behavior: SnackBarBehavior.floating,
                                      padding: const EdgeInsets.all(10),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: Colors.teal.shade900,
                                    ),
                                  );
                                } else {
                                  if (imageNotifier.value.path.isNotEmpty ||
                                      globalKey.currentState!.validate()) {
                                    try {
                                      final model = Assetmodel(
                                        name: nameCr.text.trim(),
                                        category: dropdown.value,
                                        purchaseDate: datepick.value,
                                        serialNumber: serialNumber.text.trim(),
                                        status: 'Available',
                                      );
                                      await data.addAsset(
                                        asset: model,
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Center(child: Text(e.toString())),
                                          behavior: SnackBarBehavior.floating,
                                          padding: const EdgeInsets.all(10),
                                          backgroundColor: Colors.teal.shade900,
                                        ),
                                      );
                                    }
                                  } else {}
                                }
                              },
                              child: Container(
                                height: 48,
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
                    },
                  ),
                  // SizedBox(height: mq.height - 200)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

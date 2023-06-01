import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/Controllers/auth_controller.dart/auth_controller.dart';
import 'package:influencer/admin_module/profile/profile_controller.dart';

final proController = Get.find<ProfileController>();
final proFileController = Get.find<ProfileController>();

Future<void> dialogboxOptimize1({
  context,
  canOnpress,
  var okOnpress,
}) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var selectedRadio = 0;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          title: const Text('AUTO'),
                          value: "AUTO",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            log('log message consloe :::${value}');
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('BENESSERE'),
                          value: "BENESSERE",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                              log('log priniting from widget Bussineess ${proFileController.opzione1}');
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('CIBO'),
                          value: "CIBO",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('FASHION'),
                          value: "FASHION",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('FOTOGRAFIA'),
                          value: "FOTOGRAFIA",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('LINGERIE'),
                          value: "LINGERIE",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('MAKEUP E TRUCCHI'),
                          value: "MAKEUP E TRUCCHI",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('PARCHI TEMATICI'),
                          value: "PARCHI TEMATICI",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('RECENSIONI DI PRODOTTI'),
                          value: 'RECENSIONI DI PRODOTTI',
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('SPORT'),
                          value: "SPORT",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('VIAGGI'),
                          value: "VIAGGI",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('VINO'),
                          value: "VINO",
                          groupValue: proFileController.opzione1,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione1 = value.toString();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: canOnpress,
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: okOnpress, child: const Text('Ok')),
                          ],
                        )
                      ]),
                ),
              );
            },
          ),
        );
      });
  // ---end of optimise 2---
}

Future<void> dialogboxOptimize2({
  context,
  canOnpress,
  var okOnpress,
}) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var selectedRadio = 0;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          title: Text('AUTO'),
                          value: "AUTO",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('BENESSERE'),
                          value: "BENESSERE",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('CIBO'),
                          value: "CIBO",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('FASHION'),
                          value: "FASHION",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('FOTOGRAFIA'),
                          value: "FOTOGRAFIA",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('LINGERIE'),
                          value: "LINGERIE",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('MAKEUP E TRUCCHI'),
                          value: "MAKEUP E TRUCCHI",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('PARCHI TEMATICI'),
                          value: "PARCHI TEMATICI",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('RECENSIONI DI PRODOTTI'),
                          value: 'RECENSIONI DI PRODOTTI',
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('SPORT'),
                          value: "SPORT",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('VIAGGI'),
                          value: "VIAGGI",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('VINO'),
                          value: "VINO",
                          groupValue: proFileController.opzione2,
                          onChanged: (value) {
                            setState(() {
                              proFileController.opzione2 = value.toString();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: canOnpress,
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: okOnpress, child: const Text('Ok')),
                          ],
                        ),
                      ]),
                ),
              );
            },
          ),
        );
      });
  // ---end of optimise 2---
}

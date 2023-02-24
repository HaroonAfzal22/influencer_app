import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:influencer/Controllers/auth_controller.dart/auth_controller.dart';
import 'package:influencer/util/LoadingWidget.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/editText.dart';

RegExp phoneValidator = RegExp(r'[0-9]{11}');

class InfluencerForm extends StatefulWidget {
  const InfluencerForm({Key? key}) : super(key: key);
  @override
  State<InfluencerForm> createState() => _InfluencerFormState();
}

class _InfluencerFormState extends State<InfluencerForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _value2 = 0;

  List<String> items = <String>[
    'AUTO',
    'BENESSERE',
    'CIBO',
    'FASHION',
    'FOTOGRAFIA',
    'LINGERIE',
    'MAKEUP E TRUCCHI',
    'PARCHI TEMATICI',
    'RECENSIONI DI PRODOTTI',
    'SPORT',
    'VIAGGI',
    'VINO'
  ];
  String? dropdownValue;
  String? dropdownValue2;
  bool checkvalue = false;
  bool instagram = false;
  bool tiktok = false;
  bool isdisable = true;

  int? selectedRadio;

  @override
  void initState() {
    super.initState();
    dropdownValue;
  }

  List categoryItemlist = [];
  String? dropdownValue3;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back)),
                elevation: 0,
                title: Image.asset(
                  "assets/logo_img.png",
                  height: height * .08,
                  width: width * .35,
                )),
            body: Form(
              key: _formKey,
              child: GetBuilder<AuthController>(
                init: AuthController(),
                builder: (controller) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.h, vertical: 13.w),
                    child: ListView(
                      // physics: NeverScrollableScrollPhysics(),

                      children: [
                        txtname('NOME*'),
                        space(),
                        EditText(
                          controller: controller.nameController,
                          formvalidate: (value) {
                            if (value.isNotEmpty && value.length > 2) {
                              return null;
                            } else if (value.length < 3 && value.isNotEmpty) {
                              return 'Please Enter at least 3 characters';
                            } else {
                              return 'Please Enter Your Name';
                            }
                          },
                        ),
                        space(),
                        txtname('COGNOME*'),
                        space(),
                        EditText(
                          controller: controller.surNameController,
                          formvalidate: (value) {
                            if (value.isNotEmpty && value.length > 2) {
                              return null;
                            } else if (value.length < 3 && value.isNotEmpty) {
                              return 'Please Enter at least 3 characters';
                            } else {
                              return 'Please Enter Your Last Name';
                            }
                          },
                        ),
                        space(),
                        //E-MAIL*
                        txtname('E-MAIL*'),
                        space(),
                        EditText(
                          controller: controller.emailController,
                          formvalidate: (value) {
                            if (!value!.contains('@') && value.isNotEmpty) {
                              return 'Email is not Valid';
                            } else if (value.isEmpty) {
                              return 'Please Enter an Email';
                            }
                            return null;
                          },
                        ),
                        space(),
                        //DI COSA TI OCCUPI? (1° OPZIONE)
                        txtname("DI COSA TI OCCUPI? (1° OPZIONE)"),
                        space(),
                        Container(
                          height: height * .05,
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 0, 10, 10),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              value: dropdownValue,
                              selectedItemBuilder: (BuildContext context) {
                                //<-- SEE HERE
                                return <String>[
                                  'AUTO',
                                  'BENESSERE',
                                  'CIBO',
                                  'FASHION',
                                  'FOTOGRAFIA',
                                  'LINGERIE',
                                  'MAKEUP E TRUCCHI',
                                  'PARCHI TEMATICI',
                                  'RECENSIONI DI PRODOTTI',
                                  'SPORT',
                                  'VIAGGI',
                                  'VINO'
                                ].map((String value) {
                                  return Text(
                                    dropdownValue.toString(),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  );
                                }).toList();
                              },
                              isExpanded: true,
                              elevation: 16,
                              // style: const TextStyle(color: BColor.color_white),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                // if(value!=dropdownValue2){
                                //   setState(() {
                                //     dropdownValue2=value!;
                                //   });
                                // }
                              },
                              items: items.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: RadioListTile(
                                    value: value,
                                    groupValue: dropdownValue,
                                    title: Text(
                                      value,
                                      style: const TextStyle(
                                          color: IColor.colorblack),
                                    ),
                                    // subtitle: Text("Radio 1 Subtitle"),
                                    onChanged: (value) {
                                      if (value != dropdownValue2) {
                                        setState(() {
                                          dropdownValue = value.toString();
                                          Get.back();
                                        });
                                      }
                                    },
                                    activeColor: Colors.blue,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    selected: true,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        space(),

                        //DI COSA TI OCCUPI? (2° OPZIONE)
                        txtname("DI COSA TI OCCUPI? (2° OPZIONE)"),
                        space(),
                        Container(
                          height: height * .05,
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 0, 10, 10),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              value: dropdownValue2,
                              selectedItemBuilder: (BuildContext context) {
                                //<-- SEE HERE
                                return <String>[
                                  'AUTO',
                                  'BENESSERE',
                                  'CIBO',
                                  'FASHION',
                                  'FOTOGRAFIA',
                                  'LINGERIE',
                                  'MAKEUP E TRUCCHI',
                                  'PARCHI TEMATICI',
                                  'RECENSIONI DI PRODOTTI',
                                  'SPORT',
                                  'VIAGGI',
                                  'VINO'
                                ].map((String value) {
                                  return Text(
                                    dropdownValue2.toString(),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  );
                                }).toList();
                              },
                              isExpanded: true,
                              elevation: 16,
                              // style: const TextStyle(color: BColor.color_white),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                // if (value != dropdownValue) {
                                //   setState(() {
                                //     dropdownValue2 =value ;
                                //   });
                                // }
                              },
                              items: items.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: RadioListTile(
                                    value: value,
                                    groupValue: dropdownValue2,
                                    title: Text(value,
                                        style: const TextStyle(
                                            color: IColor.colorblack)),
                                    // subtitle: Text("Radio 1 Subtitle"),
                                    onChanged: (value) {
                                      print("Radio Tile pressed $value");
                                      if (value != dropdownValue) {
                                        setState(() {
                                          dropdownValue2 = value.toString();
                                          Get.back();
                                        });
                                      }
                                    },
                                    activeColor: Colors.blue,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    selected: true,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        space(),

                        //PROVINCIA DI RESIDENCE*
                        txtname("PROVINCIA DI RESIDENCE*"),
                        space(),
                        SizedBox(
                          height: height * .05,
                          width: double.infinity,
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 0, 10, 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            //dropdownColor: const Color(0xffF38222),
                            isExpanded: true,
                            items: categoryItemlist.map((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: Text(
                                  item['maincat'].toString(),
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xffF38222)),
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                dropdownValue3 = newVal.toString();
                              });
                            },
                            value: dropdownValue3,
                          ),
                        ),
                        space(),

                        //NUMERO DI TELEFONO*
                        txtname("NUMERO DI TELEFONO*"),
                        space(),
                        EditText(
                          // type: TextInputType.number
                          controller: controller.phoneController,
                          formvalidate: (value) {
                            if (phoneValidator.hasMatch(value)) {
                              return null;
                            } else if (value.length < 10) {
                              return 'Please Enter 11 digits of mobile number';
                            } else {
                              return 'Please Enter Phone Number';
                            }
                          },
                        ),
                        space(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Column(
                                children: [
                                  Container(
                                    height: height * .04,
                                    width: width * .4,
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          Color(0xffF392E3),
                                          Color(0xffDA96E6),
                                          Color(0xffC199E9),
                                          Color(0xff8DA1F0),
                                          Color(0xff63A8F6),
                                          Color(0xff3EADFC),
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                        child: Text(
                                      "CONNETTI INSTAGRAM",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    )),
                                  ),
                                  space()
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  instagram = !instagram;
                                });
                              },
                            ),
                            InkWell(
                              child: Column(
                                children: [
                                  Container(
                                    height: height * .04,
                                    width: width * .3,
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          Color(0xffF392E3),
                                          Color(0xffDA96E6),
                                          Color(0xffC199E9),
                                          Color(0xff8DA1F0),
                                          Color(0xff63A8F6),
                                          Color(0xff3EADFC),
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                        child: Text(
                                      "CONNETI TIKTOK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    )),
                                  ),
                                  space()
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  tiktok = !tiktok;
                                });
                              },
                            )
                          ],
                        ),
                        Visibility(
                            visible: instagram,
                            child: Column(
                              children: [
                                EditText(
                                  hint:
                                      "Inserisci il nome utente del tuo Instagram",
                                ),
                                space()
                              ],
                            )),
                        Visibility(
                            visible: tiktok,
                            child: Column(
                              children: [
                                EditText(
                                  hint:
                                      "Inserisci il nome utente del tuo tiktok",
                                ),
                                space()
                              ],
                            )),

                        //PASSWORD (MASSIMO 8 CARATTERI)*
                        txtname("PASSWORD (MASSIMO 8 CARATTERI)*"),
                        space(),
                        EditText(
                          controller: controller.passwordController,
                          formvalidate: (value) {
                            if (value.isNotEmpty && value.length > 7) {
                              return null;
                            } else if (value.length < 8 && value.isNotEmpty) {
                              return 'Please Enter at least 8 characters';
                            } else {
                              return 'Please Enter Your password';
                            }
                          },
                        ),
                        space(),

                        //CONFERMA PASSWORD*
                        txtname("CONFERMA PASSWORD*"),
                        space(),
                        EditText(
                          controller: controller.confirmController,
                          formvalidate: (value) {
                            if (value.isNotEmpty && value.length > 7) {
                              return null;
                            } else if (value.length < 8 && value.isNotEmpty) {
                              return 'Please Enter at least 8 characters';
                            } else {
                              return 'Please Enter Your password';
                            }
                          },
                        ),
                        space(),

                        //CODICE INVITO/REFERRAL (OPZIONALE)*
                        txtname("CODICE INVITO/REFERRAL (OPZIONALE)*"),
                        space(),
                        EditText(),
                        space(),

                        //PRIVACY POLICY
                        txtname("PRIVACY POLICY"),
                        Row(
                          children: [
                            Checkbox(
                              value: checkvalue,
                              activeColor: const Color(0xff10C49F),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  checkvalue = newValue!;
                                });
                              },
                            ),
                            const Text("PRIVACY POLICY")
                          ],
                        ),
                        controller.isLoading == true
                            ? const LoaderWidget()
                            : Center(
                                child: InkWell(
                                  child: Container(
                                    height: height * .06,
                                    width: width * .4,
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          Color(0xffF392E3),
                                          Color(0xffDA96E6),
                                          Color(0xffC199E9),
                                          Color(0xff8DA1F0),
                                          Color(0xff63A8F6),
                                          Color(0xff3EADFC),
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                        child: Text(
                                      "ISCRIVITI",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                  ),
                                  onTap: () {
                                    final compare = controller
                                        .passwordController.text
                                        .compareTo(
                                            controller.confirmController.text);

                                    if (_formKey.currentState!.validate()) {
                                      if (checkvalue == true) {
                                        controller.createUser();
                                      } else {
                                        Get.snackbar('Error',
                                            'Please accept the privacey Policy',
                                            snackPosition: SnackPosition.BOTTOM,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20));
                                      }
                                    } else if (compare != 0) {
                                      Get.snackbar(
                                          'Error', 'Your password not matched',
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 20));
                                    }
                                  },
                                ),
                              )
                      ],
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }

  txtname(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.black, fontFamily: 'Montserrat', fontSize: 12),
    );
  }

  space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .01,
    );
  }
}

class GroupModel {
  String text;
  int index;
  bool selected;

  GroupModel({required this.text, required this.index, required this.selected});
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pushnotifications/Controller.dart';
import 'package:pushnotifications/Data.dart';
import 'package:pushnotifications/Widgets/TextFieldWidget.dart';
import 'package:pushnotifications/Widgets/DrawerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  MyPushNotification myPushNotification = MyPushNotification();
  TextEditingController userController = TextEditingController();
  TextEditingController titleController =
      TextEditingController(text: currentUsers);
  TextEditingController msgController = TextEditingController();

  var value;
  String? selectedValue;

  void setUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUsers = prefs.getString('currentUser').toString();
  }

  Future<void> getData() async {
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('UserTokens').get();
      final List<DocumentSnapshot> documents = result.docs.toList();

      documents.forEach((data) {
        // print('user Data:: ${data.id}');
        for (var i = 0; i < documents.length; i++) {
          value = data.id;
        }
      });
      userData.add(value);
      print(userData);
    } catch (e) {
      print('Error fetching data: $e');
    }
    print('unique:: $uniqueList');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUser();
    myPushNotification.requestPermission();
    myPushNotification.getToken();
    myPushNotification.listenFCM();
    myPushNotification.loadFCM();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyPushNotification>(
      builder: (context, value, child) => SafeArea(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text(
                'Push Notification App',
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('currentUser');
                    },
                    icon: const Icon(Icons.logout))
              ],
            ),
            drawer: const Users(),
            body: Container(
              height: MediaQuery.of(context).size.height * 1.00,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'assets/lottie/msg.json',
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      'Send Notification',
                      style: GoogleFonts.dmSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("UserTokens")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Some error occured ${snapshot.error}"),
                          );
                        }
                        List<DropdownMenuItem> programItems = [];
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          final selectProgram =
                              snapshot.data?.docs.reversed.toList();
                          if (selectProgram != null) {
                            for (var program in selectProgram) {
                              programItems.add(
                                DropdownMenuItem(
                                  value: program.id,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.person_2_outlined,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          program.id,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton(
                                underline: const SizedBox(),
                                dropdownColor: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                iconEnabledColor: Colors.white,
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    const Icon(
                                      Icons.person_2_outlined,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Select User",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                value: selectedValue,
                                items: programItems,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    // TextFieldWidget(
                    //   hintText: 'Write Receviver Name...',
                    //   controller: userController,
                    //   iconData: const Icon(
                    //     Icons.message_outlined,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    Visibility(
                      visible: false,
                      child: TextFieldWidget(
                        hintText: 'Write Notification Title...',
                        controller: titleController,
                        iconData: const Icon(
                          Icons.message_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                      hintText: 'Write your message...',
                      controller: msgController,
                      iconData: const Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: InkWell(
                        onTap: () {
                          value.sendData(
                              selectedValue, currentUsers, msgController.text);
                          userController.clear();
                          titleController.clear();
                          msgController.clear();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 6.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                    0.05,
                                    0.05,
                                  ),
                                )
                              ]),
                          child: Text(
                            'Send Message',
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () async {
                        value.deleteUserAccount(context);
                      },
                      child: value.isLoading2 ?
                      Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: Colors.white,),
                          const SizedBox(width: 10,),
                          Text('Loading...',style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),)
                        ],
                      ),)
                       :  Text(
                        'Delete Account',
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          letterSpacing: 0.5,
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

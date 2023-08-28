import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pushnotifications/Data.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade900,
      elevation: 0,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('UserTokens').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade800,
              ),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No data available.');
          }
          List<String> documentIds =
              snapshot.data!.docs.map((doc) => doc.id).toList();

          return ListView.builder(
            itemCount: documentIds.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      selectUser = documentIds[index];
                    });
                    print(selectUser);
                  },
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}. ',
                          style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade800,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          '${documentIds[index]}.',
                          style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

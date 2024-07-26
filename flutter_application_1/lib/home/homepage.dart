import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/query/editnotes.dart';
import 'package:flutter_application_1/query/viewnotes.dart';
import 'package:quiver/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? userinfo = FirebaseAuth.instance.currentUser;
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

  getUser() {
    User? userinfo = FirebaseAuth.instance.currentUser;
    print(userinfo!.email);
  }

  var fbm = FirebaseMessaging.instance;

  initalMessage() async {
    var message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      Navigator.of(context).pushNamed("addnotes");
    }
  }

  requestPermssion() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    requestPermssion();
    initalMessage();
    fbm.getToken().then((token) {
      print(token);
    });

    FirebaseMessaging.onMessage.listen((event) {
      //  AwesomeDialog(context: context , title: "title" , body: Text("${event.notification.body}"))..show() ;

      Navigator.of(context).pushNamed("addnotes");
    });

    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 208, 51),
        title: const Text("home page"),
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("login");
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("addnotes");
          }),
      body: Container(
        child: FutureBuilder(
            future: notesref.where("userid", isEqualTo: userinfo!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          onDismissed: (direction) async {
                            await notesref
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                            await FirebaseStorage.instance
                                .refFromURL(
                                    snapshot.data!.docs[index]['imageurl'])
                                .delete()
                                .then((value) {
                              print("deleated");
                            });
                          },
                          key: UniqueKey(),
                          child: ListNotes(
                              notes: snapshot.data!.docs[index],
                              docid: snapshot.data!.docs[index].id));

                      // Text(
                      //     "${snapshot.data!.docs[index].data()!['title']}");
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  ListNotes({this.notes, this.docid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ViewNote(
              note: notes,
            );
          },
        ));
      },
      child: Card(
          child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.network(
              "${notes['imageurl']}",
              fit: BoxFit.fill,
              height: 70,
            ),
          ),
          Expanded(
            flex: 3,
            child: ListTile(
              title: Text("${notes['title']}"),
              subtitle: Text(
                "${notes['note']}",
                style: const TextStyle(fontSize: 14),
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return EditNotes(
                      docid: docid,
                      note: notes,
                    );
                  }));
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Container();
// }
// ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, i) {
//           return Dismissible(
//               key: Key("$i"),
//               child: ListNotes(
//                 n: notes[i],
//               ));
//         },
//       ),

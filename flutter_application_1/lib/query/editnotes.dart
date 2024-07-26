import 'dart:math';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/component/alert.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';

class EditNotes extends StatefulWidget {
  final docid;
  final note;
  const EditNotes({super.key, this.docid, this.note});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  User? userinfo = FirebaseAuth.instance.currentUser;
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");
  Reference? ref;
  String? title, note, imageurl;
  File? file;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  EditNotes(context) async {
    var formdata = formkey.currentState;
    if (file == null) {
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();
        await notesref.doc(widget.docid).update({
          "title": title!,
          "note": note!,
        }).then((value) {
          Navigator.of(context).pushNamed("HomePage");
        }).catchError((e) {
          print("$e");
        });
      }
    } else {
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();
        await ref!.putFile(file!);
        imageurl = await ref!.getDownloadURL();
        await notesref.doc(widget.docid).update({
          "title": title!,
          "note": note!,
          "imageurl": imageurl!,
        }).then((value) {
          Navigator.of(context).pushNamed("HomePage");
        }).catchError((e) {
          print("$e");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit  Note")),
      body: Container(
        child: Column(
          children: [
            Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.note['title'],
                      onSaved: (val) {
                        title = val;
                      },
                      validator: (value) {
                        if (value!.length > 30) {
                          return "title can't too be larger than 30";
                        }
                        if (value.length < 2) {
                          return "title can't too be less than 2 letter";
                        }
                        return null;
                      },
                      maxLength: 30,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "insert title of notes",
                        prefixIcon: const Icon(Icons.note),
                      ),
                    ),
                    TextFormField(
                      initialValue: widget.note['note'],
                      onSaved: (val) {
                        note = val;
                      },
                      validator: (value) {
                        if (value!.length > 255) {
                          return "note can't too be larger than 255";
                        }
                        if (value.length < 10) {
                          return "note can't too be less than 10letter";
                        }
                        return null;
                      },
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 200,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: " notes",
                        prefixIcon: const Icon(Icons.note),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (() {
                        showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                height: 180,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      " Edit Image",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    InkWell(
                                      onTap: (() async {
                                        var pick = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);
                                        if (pick != null) {
                                          file = File(pick.path);
                                          var rand = Random().nextInt(100000);
                                          var imagename =
                                              "$rand" + basename(pick.path);
                                          ref = FirebaseStorage.instance
                                              .ref("images")
                                              .child("$imagename");
                                          Navigator.of(context).pop();
                                        }
                                      }),
                                      child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.photo_album,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "From Gallery",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          )),
                                    ),
                                    InkWell(
                                      onTap: (() async {
                                        var pick = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (pick != null) {
                                          file = File(pick.path);
                                          var rand = Random().nextInt(100000);
                                          var imagename =
                                              "$rand" + basename(pick.path);
                                          ref = FirebaseStorage.instance
                                              .ref("images")
                                              .child("$imagename");
                                          Navigator.of(context).pop();
                                        }
                                      }),
                                      child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.camera,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "From Camera",
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }),
                      child: const Text(
                        "Edit Image For Note",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await EditNotes(context);
                      },
                      child: Text(
                        "Edit Note",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[600],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

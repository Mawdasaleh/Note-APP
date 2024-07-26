import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/component/alert.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  User? userinfo = FirebaseAuth.instance.currentUser;
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");
  Reference? ref;
  String? title, note, imageurl;
  File? file;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  addNotes(context) async {
    if (file == null) {
      return AwesomeDialog(
          context: context,
          title: "imortant",
          body: const Text("please choose image"),
          dialogType: DialogType.error)
        ..show();
    }

    var formdata = formkey.currentState;
    if (formdata!.validate()) {
      showLoading(context);
      formdata.save();
      await ref!.putFile(file!);
      imageurl = await ref!.getDownloadURL();
      await notesref.add({
        "title": title!,
        "note": note!,
        "imageurl": imageurl!,
        "userid": userinfo!.uid,
      }).then((value) {
        Navigator.of(context).pushNamed("HomePage");
      }).catchError((e) {
        print("$e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Note",
        ),
        backgroundColor: Color.fromARGB(255, 248, 209, 36),
      ),
      body: Container(
          child: Column(
        children: [
          Form(
              key: formkey,
              child: Column(children: [
                TextFormField(
                  validator: (value) {
                    if (value!.length > 30) {
                      return "title can't too be larger than 30";
                    }
                    if (value.length < 2) {
                      return "title can't too be less than 2 letter";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    title = val;
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
                  validator: (value) {
                    if (value!.length > 255) {
                      return "note can't too be larger than 255";
                    }
                    if (value.length < 10) {
                      return "note can't too be less than 10letter";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    note = val;
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
                  onPressed: () {
                    showBottomSheet(context);
                  },
                  child: Text(
                    "Add Image For Note",
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await addNotes(context);
                  },

                  // padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  child: Text(
                    "Add Note",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                  ),
                )
              ]))
        ],
      )),
    );
  }

  showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Please Choose Image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imagename = "$rand${basename(picked.path)}";
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");

                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.photo_outlined,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Gallery",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imagename = "$rand${basename(picked.path)}";
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.camera,
                            size: 30,
                          ),
                          SizedBox(width: 20),
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
  }
}


//                         showModalBottomSheet(
//                             context: context,
//                             builder: (ctx) {
//                               return Container(
//                                 padding: const EdgeInsets.all(20),
//                                 height: 180,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       "please chose Image",
//                                       style: TextStyle(fontSize: 20),
//                                     ),
//                                     InkWell(
//                                       onTap: (() async {
//                                         var pick = await ImagePicker()
//                                             .pickImage(
//                                                 source: ImageSource.camera);
//                                         if (pick != null) {
//                                           file = File(pick.path);
//                                           var rand = Random().nextInt(100000);
//                                           var imagename =
//                                               "$rand${basename(pick.path)}";
//                                           ref = FirebaseStorage.instance
//                                               .ref("images")
//                                               .child(imagename);
//                                           Navigator.of(context).pop();
//                                         }
//                                       }),
//                                       child: Container(
//                                           width: double.infinity,
//                                           padding: const EdgeInsets.all(10),
//                                           child: Row(
//                                             children: const [
//                                               Icon(
//                                                 Icons.photo_album,
//                                                 size: 30,
//                                               ),
//                                               SizedBox(
//                                                 width: 20,
//                                               ),
//                                               Text(
//                                                 "From Gallery",
//                                                 style: TextStyle(fontSize: 20),
//                                               ),
//                                             ],
//                                           )),
//                                     ),
//                                     InkWell(
//                                       onTap: (() async {
//                                         var pick = await ImagePicker()
//                                             .pickImage(
//                                                 source: ImageSource.gallery);
//                                         if (pick != null) {
//                                           file = File(pick.path);
//                                           var rand = Random().nextInt(100000);
//                                           var imagename =
//                                               "$rand${basename(pick.path)}";
//                                           ref = FirebaseStorage.instance
//                                               .ref("images")
//                                               .child("$imagename");
//                                           Navigator.of(context).pop();
//                                         }
//                                       }),
//                                       child: Container(
//                                           width: double.infinity,
//                                           padding: const EdgeInsets.all(10),
//                                           child: Row(
//                                             children: const [
//                                               Icon(
//                                                 Icons.camera,
//                                                 size: 30,
//                                               ),
//                                               SizedBox(
//                                                 width: 20,
//                                               ),
//                                               Text(
//                                                 "From Camera",
//                                                 style: TextStyle(fontSize: 20),
//                                               )
//                                             ],
//                                           )),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             });
//                       }),
//                       child: const Text(
//                         "Add Image For Note",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         await addNotes(context);
//                         // AwesomeDialog(
//                         //   context: context,
//                         //   dialogType: DialogType.success,
//                         //   animType: AnimType.bottomSlide,
//                         //   title: 'Dialog Title',
//                         //   desc: 'Dialog description here.............',
//                         //   btnCancelOnPress: () {},
//                         //   btnOkOnPress: () {},
//                         // ).show();
//                       },
//                       // padding:EdgeInsets.symmetric(horizontal: 100,vertical: 10),
//                       child: Text(
//                         "Add Note",
//                         style: Theme.of(context).textTheme.headline5,
//                       ),
//                     ),
//                   ],
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }

// shobootom() {
//   return showModalBottomSheet(
//     context: context,
//     builder: (ctx){
//         return Container(
//           padding: EdgeInsets.all(20),
//           height: 170,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "please chose Image",
//                 style: TextStyle(fontSize: 20),
//               ),
//               InkWell(
//                 onTap: (() {}),
//                 child: Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(10),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.photo_album,
//                           size: 30,
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                           "From Gallery",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       ],
//                     )),
//               ),
//               InkWell(
//                 onTap: (() {}),
//                 child: Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(10),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.camera,
//                           size: 30,
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         const Text(
//                           "From Camera",
//                           style: TextStyle(fontSize: 20),
//                         )
//                       ],
//                     )),
//               ),
//             ],
//           ),
//         );
//       });
// }

// // showMaterialModalBottomSheet({required JsObject context, required Container Function(dynamic context) builder}) {}

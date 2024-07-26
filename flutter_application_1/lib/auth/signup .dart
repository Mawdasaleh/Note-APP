import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/alert.dart';
// import 'package:flutter_application_1/component/alert.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  UserCredential? credential;
  String? myusername;
  String? mypassword;
  String? myemail;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  signup() async {
    var formData = formkey.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        showLoading(context);
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: myemail!, password: mypassword!);

        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: const Text("password is too week"))
              .show();
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body:
                      const Text("The account already exists for that email. "))
              .show();
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("not validate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Register Here",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "image/register.png",
                  height: 150,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Get Registered From Here",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Name",
                  style: TextStyle(fontSize: 12),
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            color: Colors.grey[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.length > 100) {
                              return "username can't too be larger than 100";
                            }
                            if (value.length < 2) {
                              return "username can't too be less than 2 letter";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            myusername = value;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Your Name',
                              contentPadding: EdgeInsets.all(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            color: Colors.grey[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.length > 100) {
                              return "email can't too be larger than 100";
                            }
                            if (value.length < 2) {
                              return "email can't too be less than 2 letter";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            myemail = value;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Your Email',
                              contentPadding: EdgeInsets.all(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Password",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            color: Colors.grey[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.length > 100) {
                              return "password can't too be larger than 100";
                            }
                            if (value.length < 4) {
                              return "password can't too be less than 4 letter";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            mypassword = value;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Your Password',
                              contentPadding: EdgeInsets.all(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        color: Theme.of(context).primaryColor,
                        height: 20,
                        minWidth: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          UserCredential response = await signup();
                          if (response != null) {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .add(
                                    {"username": myusername, "email": myemail});
                            Navigator.of(context)
                                .pushReplacementNamed("HomePage");
                          } else {
                            print("sign up fild");
                          }
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "already have an account ? ",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.grey),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.of(context).pushNamed("login");
                            },
                            child: Text(
                              "Sign In ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ListView(
//       children: [
//         const SizedBox(height: 80),
//         // ignore: prefer_const_constructors
//         Center(
//           // ignore: prefer_const_constructors
//           child: CircleAvatar(
//               backgroundImage: const AssetImage("image/logo2.png"), radius: 50),
//         ),

//         Container(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//               key: formkey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     validator: (value) {
//                       if (value!.length > 100) {
//                         return "username can't too be larger than 100";
//                       }
//                       if (value.length < 2) {
//                         return "username can't too be less than 2 letter";
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       myusername = value;
//                     },
//                     decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.person),
//                         hintText: "user name",
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(width: 1))),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   TextFormField(
//                     validator: (value) {
//                       if (value!.length > 100) {
//                         return "email can't too be larger than 100";
//                       }
//                       if (value.length < 2) {
//                         return "email can't too be less than 2 letter";
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       myemail = value;
//                     },
//                     decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.email),
//                         hintText: "Emaill",
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(width: 1))),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   TextFormField(
//                     validator: (value) {
//                       if (value!.length > 100) {
//                         return "password can't too be larger than 100";
//                       }
//                       if (value.length < 4) {
//                         return "password can't too be less than 4 letter";
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       mypassword = value;
//                     },
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.password),
//                         hintText: "password",
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(width: 1))),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(10),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Text("if you have account"),
//                         // const SizedBox(
//                         //   width: ,
//                         // ),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.of(context).pushNamed("login");
//                             },
//                             child: const Text(
//                               "Click Here",
//                               style: TextStyle(
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       UserCredential response = await signup();

//                       if (response != null) {
//                         await FirebaseFirestore.instance
//                             .collection("users")
//                             .add({"username": myusername, "email": myemail});
//                         Navigator.of(context).pushReplacementNamed("HomePage");
//                       } else {
//                         print("sign up fild");
//                       }
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(
//                           const Color.fromARGB(255, 243, 212, 36)),
//                       padding:
//                           MaterialStateProperty.all(const EdgeInsets.all(20)),
//                     ),
//                     child: Text("sign up",
//                         style: Theme.of(context).textTheme.headlineSmall),
//                   )
//                 ],
//               )),
//         )
//       ],
//     ));
//   }
// }

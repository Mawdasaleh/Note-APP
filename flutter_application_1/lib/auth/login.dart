import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/component/alert.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserCredential? credential;

  String? mypassword;
  String? myemail;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  signIn() async {
    var formData = formkey.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        showLoading(context);
        credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myemail!,
          password: mypassword!,
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: const Text("No user found for that email "))
              .show();
          Navigator.of(context).pop();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: const Text("Wrong password provided for that user."))
              .show();
          Navigator.of(context).pop();
        }
      }
    } else {
      print("Not Valid");
    }
  }
  // Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  // final GoogleSignInAuthentication? googleAuth =
  //     await googleUser?.authentication;

  // Create a new credential
  // final credential = GoogleAuthProvider.credential(
  //   accessToken: googleAuth?.accessToken,
  //   idToken: googleAuth?.idToken,
  // );

  // Once signed in, return the UserCredential
  // return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // late UserCredential userCredential;
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
                    height: 50,
                  ),
                  const Text(
                    "Login Here",
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
                    "Get Logged In From Here",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Email",
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
                            onSaved: (value) {
                              myemail = value;
                            },
                            validator: (value) {
                              if (value!.length > 100) {
                                return "email can't too be larger than 100";
                              }
                              if (value.length < 2) {
                                return "email can't too be less than 2 letter";
                              }
                              return null;
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
                            onSaved: (value) {
                              mypassword = value;
                            },
                            validator: (value) {
                              if (value!.length > 100) {
                                return "password can't too be larger than 100";
                              }
                              if (value.length < 2) {
                                return "password can't too be less than 2 letter";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Password',
                                contentPadding: EdgeInsets.all(10)),
                          ),
                        ),
                        // SizedBox(
                        //   height: 5.h,
                        // ),

                        const SizedBox(
                          height: 10,
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
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            UserCredential user = await signIn();
                            if (user != null) {
                              Navigator.of(context)
                                  .pushReplacementNamed("homepage");
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
                              "don't have an account ? ",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("signup");
                              },
                              child: Text(
                                "Sign Up ",
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
            )),
      ),
    );
  }
}























//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
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
//                     onSaved: (value) {
//                       myemail = value;
//                     },
//                     validator: (value) {
//                       if (value!.length > 100) {
//                         return "email can't too be larger than 100";
//                       }
//                       if (value.length < 2) {
//                         return "email can't too be less than 2 letter";
//                       }
//                       return null;
//                     },
//                     decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.person),
//                         hintText: "Email",
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(width: 1))),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   TextFormField(
//                     onSaved: (value) {
//                       mypassword = value;
//                     },
//                     validator: (value) {
//                       if (value!.length > 100) {
//                         return "password can't too be larger than 100";
//                       }
//                       if (value.length < 2) {
//                         return "password can't too be less than 2 letter";
//                       }
//                       return null;
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
//                       children: [
//                         const Text(
//                           "if you havan't account",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         const SizedBox(
//                           width: 2,
//                         ),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.of(context)
//                                   .pushReplacementNamed("signup");
//                             },
//                             child: const Text(
//                               "Click Here",
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       UserCredential user = await signIn();
//                       if (user != null) {
//                         Navigator.of(context).pushReplacementNamed("homepage");
//                       }
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(
//                           const Color.fromARGB(255, 243, 212, 33)),
//                       padding:
//                           MaterialStateProperty.all(const EdgeInsets.all(20)),
//                     ),
//                     child: Text("login",
//                         style: Theme.of(context).textTheme.headlineSmall),
//                   )
//                 ],
//               )),
//         )
//       ],
//     ));
//   }
// }









// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:snap_coding_2/widgets/text_field_input.dart';

// final FirebaseAuth _auth = FirebaseAuth.instance;

// class _RegisterEmailSection extends StatefulWidget {
//   _RegisterEmailSection({Key? key}) : super(key: key);

//   final String title = 'Registration';
//   // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   late bool _success;
//   late String _userEmail;

//   @override
//   State<_RegisterEmailSection> createState() => __RegisterEmailSectionState();
// }

// class __RegisterEmailSectionState extends State<_RegisterEmailSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Form(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [],
//         ),
//       ),
//     );
//   }
// }

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
//   final TextEditingController _emailController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future signInWithEmailandLink(userEmail) async {
//     var _userEmail = userEmail;
//     return await _auth
//         .sendSignInLinkToEmail(
//       email: _userEmail,
//       actionCodeSettings: ActionCodeSettings(
//         url: "https://flutterauth.page.link",
//         handleCodeInApp: true,
//         androidPackageName: "com.example.snap_coding_2",
//         androidMinimumVersion: "1",
//       ),
//     )
//         .then(
//       (value) {
//         print("email sent");
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     try {
//       FirebaseDynamicLinks.instance.onLink(
//           onSuccess: (PendingDynamicLinkData? dynamicLink) async {
//             final Uri? deeplink = dynamicLink?.link;
//             handleLink(deeplink!, _emailController.text);
//           },
//           onError: (OnLinkErrorException e) async {print(e.message);});
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 32,
//           ),
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Flexible(
//                 child: Container(),
//                 flex: 2,
//               ),
//               Image.asset(
//                 'SnapCoding.png',
//               ),
//               const SizedBox(
//                 height: 64,
//               ),
//               TextFieldInput(
//                 textEditingController: _emailController,
//                 hintText: 'Enter your email',
//                 textInputType: TextInputType.text,
//               ),
//               const SizedBox(
//                 height: 150,
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 alignment: Alignment.center,
//                 child: ElevatedButton(
//                   onPressed: () async {},
//                   child: const Text('Submit'),
//                 ),
//               ),
//               // FloatingActionButton(
//               //   child: Text('Sign in'),
//               //   onPressed: () async {
//               //     final User? user = await _auth.currentUser!;
//               //     if (user == null) {
//               //       ScaffoldMessenger.of(context).showSnackBar(
//               //         SnackBar(
//               //           content: Text("Login failed"),
//               //         ),
//               //       );
//               //     }
//               //     return;
//               //   },
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

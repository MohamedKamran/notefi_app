import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:notefi/src/auth/login.dart';
import 'package:notefi/src/secrets/secretsfile.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextEditingController emailCon = TextEditingController();
    final TextEditingController passwordCon = TextEditingController();

    void registerUser() async {
      if (emailCon.text.isNotEmpty && passwordCon.text.isNotEmpty) {
        var regBody = {"email": emailCon.text, "password": passwordCon.text};

        var response = await http.post(Uri.parse(registration),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status']) {
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        } else {
          if (kDebugMode) {
            print("SomeThing Went Wrong");
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors
                            .grey[800], // Darken input field background color
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: TextField(
                      controller: emailCon,
                      style: const TextStyle(
                          color: Colors.white), // Set text color to white
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "New Email",
                          hintStyle: TextStyle(
                              color: Colors.grey)), // Adjust hint text color
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors
                            .grey[800], // Darken input field background color
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: TextField(
                      controller: passwordCon,
                      style: const TextStyle(
                          color: Colors.white), // Set text color to white
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: Colors.grey)), // Adjust hint text color
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Column(
                children: [
                  MaterialButton(
                    onPressed: () {
                      registerUser();
                    },
                    elevation: 0,
                    padding: const EdgeInsets.all(22),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                    color: const Color.fromARGB(255, 128, 0, 255),
                    child: const Center(
                        child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 0,
                    padding: const EdgeInsets.all(22),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                    color: const Color.fromARGB(255, 38, 0, 76),
                    child: const Center(
                        child: Text(
                      "Return to Login",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

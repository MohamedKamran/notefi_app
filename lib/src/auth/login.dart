import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:notefi/src/features/home.dart';
import 'package:notefi/src/secrets/secretsfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:notefi/src/auth/signup.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    initSharedPref();
    super.initState();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    emailCon.dispose();
    passwordCon.dispose();
    super.dispose();
  }

  void loginUser() async {
    if (emailCon.text.isNotEmpty && passwordCon.text.isNotEmpty) {
      var reqBody = {"email": emailCon.text, "password": passwordCon.text};

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => HomePage(token: myToken)));
      } else {
        if (kDebugMode) {
          print('Something went wrong');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
                          hintText: "Email",
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
                      loginUser();
                    },
                    elevation: 0,
                    padding: const EdgeInsets.all(22),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                    color: const Color.fromARGB(255, 128, 0, 255),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SigninPage();
                      }));
                    },
                    elevation: 0,
                    padding: const EdgeInsets.all(22),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                    color: const Color.fromARGB(255, 38, 0, 76),
                    child: const Center(
                        child: Text(
                      "Don't have? Sign Up",
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

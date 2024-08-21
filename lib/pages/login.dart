import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jati_presensi/pages/main.dart';
import 'package:jati_presensi/pages/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String _email = '';
  String _password = '';
  bool isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 110, 0, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selamat Datang',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 38,
              ),
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                cursorErrorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !EmailValidator.validate(value)) {
                    return 'Invalid email address';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  prefixIconColor: Colors.white,
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                onChanged: (value) => setState(() {
                  if (_formKey.currentState!.validate()) {
                    _email = value.trim();
                  }
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                cursorErrorColor: Colors.white,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    // style: ButtonStyle(
                    //     overlayColor:
                    //         MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () => setState(() {
                      _obscureText = !_obscureText;
                    }),
                    icon: _obscureText
                        ? const Icon(Icons.visibility_outlined)
                        : const Icon(Icons.visibility_off_outlined),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  prefixIconColor: Colors.white,
                  suffixIconColor: Colors.white,
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(46),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                onChanged: (value) => setState(() {
                  _password = value.trim();
                }),
              ),
              // SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                        splashFactory: NoSplash.splashFactory),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const DaftarPage(),
                        ),
                      );
                    },
                    icon: Text(
                      'Daftar',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        isLoggingIn = true;
                      });
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  style: IconButton.styleFrom(
                      splashFactory: NoSplash.splashFactory),
                  icon: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      // border: Border.all(color: Color.fromRGBO(0, 35, 125, 1)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: isLoggingIn
                        ? const CircularProgressIndicator()
                        : Text(
                            'Masuk',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(255, 111, 0, 1),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

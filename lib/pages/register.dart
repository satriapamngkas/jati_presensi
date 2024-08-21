import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jati_presensi/pages/login.dart';
import 'package:jati_presensi/pages/main.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});
  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String _name = '';
  String _email = '';
  String _password = '';
  String _idNumber = '';

  void createNewUser() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

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
                  'Daftar',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                cursorErrorColor: Colors.white,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null) {
                    return 'Please insert a name';
                  } else
                    return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  prefixIconColor: Colors.white,
                  labelText: 'Name',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                  ),
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
                    _name = value.trim();
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
                  prefixIconColor: Colors.white,
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabled: true,
                  fillColor: Colors.white,
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun?',
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
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    icon: Text(
                      'Masuk',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              IconButton(
                onPressed: () async {
                  createNewUser();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                },
                style:
                    IconButton.styleFrom(splashFactory: NoSplash.splashFactory),
                icon: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      // border: Border.all(color: Color.fromRGBO(0, 35, 125, 1)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: Text(
                    'Daftar',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(255, 111, 0, 1),
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

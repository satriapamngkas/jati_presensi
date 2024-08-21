import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jati_presensi/firebase_data.dart';
import 'package:jati_presensi/firebase_options.dart';
import 'package:jati_presensi/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  auth = FirebaseAuth.instanceFor(app: app);

  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
      fireAuth = false;
    } else {
      print('User is signed in!');
      fireAuth = true;
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      locale: const Locale('id', 'ID'),
      title: 'Presensi Jati',
      theme: ThemeData(
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(255, 110, 0, 1),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

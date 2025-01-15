import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/controllers/Notifications.dart';
import 'package:volunteers_app/providers/opp_provider.dart';
import 'package:volunteers_app/providers/theme_provider.dart';
import 'package:volunteers_app/providers/wishlist_provider.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/services/theme_data.dart';
import 'package:volunteers_app/views/Drawer/Drawer.dart';
import 'package:volunteers_app/views/dashboard/upload_opp.dart';
import 'package:volunteers_app/views/inner_screens/application_form.dart';
import 'package:volunteers_app/views/inner_screens/wishlist.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteers_app/views/inner_screens/opp_details.dart';
import 'package:sqflite/sqflite.dart';
import 'package:volunteers_app/db_helper.dart';

import 'screens/AuthWrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  initializeFirebaseMessaging();

  // Initialize the database and load wishlist
  final wishlistProvider = WishlistProvider();
  await wishlistProvider.loadWishlistFromDB();

  runApp(MainApp(wishlistProvider: wishlistProvider));
}

class MainApp extends StatelessWidget {
  final WishlistProvider wishlistProvider;

  const MainApp({super.key, required this.wishlistProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OppProvider()),
        ChangeNotifierProvider(create: (_) => wishlistProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Volunteens',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const AuthWrapper(),
            routes: {
              OppDetails.routName: (context) => const OppDetails(),
              UploadOpp.routeName: (context) => const UploadOpp(),
              WishlistScreen.routName: (context) => const WishlistScreen(),
              ApplicationForm.routName: (context) => const ApplicationForm(),
              // Add more routes here
            },
          );
        },
      ),
    );
  }
}

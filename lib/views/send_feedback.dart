import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers_app/providers/theme_provider.dart';
import 'package:volunteers_app/views/dashboard/upload_opp.dart';
import 'package:volunteers_app/views/inner_screens/wishlist.dart'; // Import for UploadOpportunityScreen if it's the same

class SendFeedbackPage extends StatefulWidget {
  @override
  _SendFeedbackPageState createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  @override
  Widget build(BuildContext context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your feedback form widgets here (e.g., TextFields, TextFormFields)

            // Add a button with the navigation function
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, WishlistScreen.routName);
              },
              child: Text('Go to Wishlist'),
            ),

             SwitchListTile(
            title:
                Text(themeProvider.getIsDarkTheme ? "Dark mode" : "Light mode"),
            value: themeProvider.getIsDarkTheme,
            onChanged: (value) {
              themeProvider.setDarkTheme(themeValue: value);
            },
          ),
          ],
        ),
      ),
    );
  }
}
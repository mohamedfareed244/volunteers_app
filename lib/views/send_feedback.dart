import 'package:flutter/material.dart';
import 'package:volunteers_app/views/dashboard/edit_upload_opp_form.dart';


class SendFeedbackPage extends StatefulWidget {
  @override
  _SendFeedbackPageState createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Feedback"), 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your feedback form widgets here (e.g., TextFields, TextFormFields)

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditOrUploadProductScreen.routeName,
                );
              },
              child: Text("Go to Edit/Upload opp"),
            ),
          ],
        ),
      ),
    );
  }
}
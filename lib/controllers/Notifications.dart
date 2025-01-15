import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/auth.dart' as auth; 
import 'dart:convert';
import 'package:http/http.dart' as http;



class NotificationService {
 
  final String _fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/volunteer-bc0bb/messages:send';

  Future<void> sendNotification(String token, String title, String body) async {
    try {

      final AccessToken=await getAccessToken();

        final message = {
    "message": {
      "notification": {
        "title": title,
        "body": body
      },
      "token": token
    }
  };
      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully!');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

Future<String> getAccessToken() async {
 String serviceAccountFile = await rootBundle.loadString('assets/ApiKey/ServiceAccount.json');
  final serviceAccountJson = jsonDecode(serviceAccountFile);

  final clientEmail = serviceAccountJson['client_email'];
  final clientIdString = serviceAccountJson['client_id'];
  final privateKey = serviceAccountJson['private_key'];
  auth.ClientId googleClientId = auth.ClientId(clientIdString, '');

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  final client = await clientViaServiceAccount(
    ServiceAccountCredentials(clientEmail, googleClientId, privateKey),
    scopes,
  );

  return client.credentials.accessToken.data;
}

 
}








/// Top-level function to handle background/terminated messages
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background or terminated message received: ${message.messageId}');
  print('Notification title: ${message.notification?.title}');
  print('Notification body: ${message.notification?.body}');
  
}

void initializeFirebaseMessaging() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not granted permission');
    }

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground notification received: ${message.notification?.title}');
      print('Notification body: ${message.notification?.body}');
    });
  }

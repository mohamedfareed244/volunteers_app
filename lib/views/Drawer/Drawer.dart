
import 'package:flutter/material.dart';
import 'package:volunteers_app/views/privacy_policy.dart';
import 'package:volunteers_app/views/send_feedback.dart';
import 'package:volunteers_app/views/settings.dart';
import 'package:volunteers_app/views/chatPage.dart';

import '../profilePage.dart';
import '../homePage.dart';
import '../opportunitiesPage.dart';
import 'my_drawer_header.dart';
import '../notifications.dart';


class drawerr extends StatefulWidget {
  @override
  _drawerrState createState() => _drawerrState();
}

class _drawerrState extends State<drawerr> {
  var currentPage = DrawerSections.home;

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.home) {
      container = homePage();
    } else if (currentPage == DrawerSections.profile) {
      container = profilePage();
    } else if (currentPage == DrawerSections.opportunities) {
      container = opportunitiesPage();
    } else if (currentPage == DrawerSections.chat) {
      container = chatPage();
    } else if (currentPage == DrawerSections.settings) {
      container = SettingsPage();
    } else if (currentPage == DrawerSections.notifications) {
      container = NotificationsPage();
    } else if (currentPage == DrawerSections.privacy_policy) {
      container = PrivacyPolicyPage();
    } else if (currentPage == DrawerSections.send_feedback) {
      container = SendFeedbackPage();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title:Text("Volunteens", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: const Color.fromARGB(255, 0, 0, 0))),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Home", Icons.dashboard_outlined,
              currentPage == DrawerSections.home ? true : false),
          menuItem(2, "Profile", Icons.account_box_outlined,
              currentPage == DrawerSections.profile ? true : false),
          menuItem(3, "Events", Icons.event,
              currentPage == DrawerSections.opportunities ? true : false),
          menuItem(4, "chat", Icons.chat,
              currentPage == DrawerSections.chat ? true : false),
        
        
          Divider(),
          menuItem(5, "Settings", Icons.settings_outlined,
              currentPage == DrawerSections.settings ? true : false),
          menuItem(6, "Notifications", Icons.notifications_outlined,
              currentPage == DrawerSections.notifications ? true : false),
          Divider(),
          menuItem(7, "Privacy policy", Icons.privacy_tip_outlined,
              currentPage == DrawerSections.privacy_policy ? true : false),
          menuItem(8, "Send feedback", Icons.feedback_outlined,
              currentPage == DrawerSections.send_feedback ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ?  Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
            } else if (id == 2) {
              currentPage = DrawerSections.profile;
            } else if (id == 3) {
              currentPage = DrawerSections.opportunities;
            } else if (id == 4) {
              currentPage = DrawerSections.chat;
            } else if (id == 5) {
              currentPage = DrawerSections.settings;
            } else if (id == 6) {
              currentPage = DrawerSections.notifications;
            } else if (id == 7) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 8) {
              currentPage = DrawerSections.send_feedback;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
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

enum DrawerSections {
  home,
  profile,
  opportunities,
  chat,
  settings,
  notifications,
  privacy_policy,
  send_feedback,
}

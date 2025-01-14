import 'package:flutter/material.dart';
import 'package:volunteers_app/services/AuthService.dart';
import 'package:volunteers_app/views/WelcomeScreen.dart';
import 'package:volunteers_app/views/currentchats.dart';
import 'package:volunteers_app/views/dashboard/organization_dashboard.dart';
import 'package:volunteers_app/views/dashboard/edit_organization.dart';
import 'package:volunteers_app/views/dashboard/review_applications.dart';
import 'package:volunteers_app/views/dashboard/upload_opp.dart';
import 'package:volunteers_app/views/dashboard/user_mangment.dart';
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
  final String role; // Receive role from AuthWrapper

  const drawerr({super.key, required this.role});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<drawerr> {
  var currentPage;
  AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
    // Set the initial page based on the role
    if (widget.role == "user") {
      currentPage = DrawerSections.home; // Default to home for users
    } else if (widget.role == "organization") {
      currentPage = DrawerSections
          .organization_dashboard; // Default to dashboard for organizations
    }
  }

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.home) {
      container = homePage();
    } else if (currentPage == DrawerSections.profile) {
      container = Userprofile();
    } else if (currentPage == DrawerSections.opportunities) {
      container = opportunitiesPage();
    } else if (currentPage == DrawerSections.chat) {
      container = ChatsScreen();
    } else if (currentPage == DrawerSections.settings) {
      container = SettingsPage();
    } else if (currentPage == DrawerSections.notifications) {
      container = NotificationsPage();
    } else if (currentPage == DrawerSections.privacy_policy) {
      container = PrivacyPolicyPage();
    } else if (currentPage == DrawerSections.send_feedback) {
      container = SendFeedbackPage();
    } else if (currentPage == DrawerSections.organization_dashboard) {
      container = OrganizationDashboard(); // Organization Dashboard
    } else if (currentPage == DrawerSections.edit_org_profile) {
      container = Orgprofile(); // Edit Organization Profile
    } else if (currentPage == DrawerSections.review_volunteer) {
      container = ReviewApplications(); // Review Volunteer Page
    } else if (currentPage == DrawerSections.post_opportunity) {
      container = UploadOpp(); // Post Opportunity Page
    } else if (currentPage == DrawerSections.user_mangament) {
      container = UserPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.role == "user"
            ? Text("Volunteens",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 0, 0, 0)))
            : Text("Organization Panel"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          ),
        ],
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyHeaderDrawer(role:widget.role,),
              MyDrawerList(widget.role), // Pass role to MyDrawerList
            ],
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList(String role) {
    List<Widget> menuItems = [];

    // Role-specific menu items
    if (role == "user") {
      menuItems.addAll([
        menuItem(1, "Home", Icons.dashboard_outlined,
            currentPage == DrawerSections.home ? true : false),
        menuItem(2, "Profile", Icons.account_box_outlined,
            currentPage == DrawerSections.profile ? true : false),
        menuItem(3, "Events", Icons.event,
            currentPage == DrawerSections.opportunities ? true : false),
           
        Divider(),
        menuItem(8, "Settings", Icons.settings_outlined,
            currentPage == DrawerSections.settings ? true : false),
        menuItem(9, "Notifications", Icons.notifications_outlined,
            currentPage == DrawerSections.notifications ? true : false),
      ]);
    } else if (role == "organization") {
      menuItems.add(
        menuItem(
            4,
            "Dashboard",
            Icons.dashboard_outlined,
            currentPage == DrawerSections.organization_dashboard
                ? true
                : false),
      );
      // menuItems.add(
      //   menuItem(5, "Manage Opportunities", Icons.manage_accounts,
      //       currentPage == DrawerSections.opportunities ? true : false),
      // );
      menuItems.add(
        menuItem(6, "Edit Profile", Icons.edit,
            currentPage == DrawerSections.edit_org_profile ? true : false),
      );
      menuItems.add(
        menuItem(7, "Review Volunteers", Icons.group_outlined,
            currentPage == DrawerSections.review_volunteer ? true : false),
      );
      menuItems.add(
        menuItem(12, "Post Opportunity", Icons.post_add,
            currentPage == DrawerSections.post_opportunity ? true : false),
      );
      menuItems.add(menuItem(13, "User Management", Icons.manage_accounts,
          currentPage == DrawerSections.user_mangament ? true : false));
    }

    // Add common menu items at the end
    menuItems.addAll([
        menuItem(14, "Chats", Icons.message,
            currentPage == DrawerSections.chat ? true : false),
      Divider(),
      menuItem(10, "Privacy Policy", Icons.privacy_tip_outlined,
          currentPage == DrawerSections.privacy_policy ? true : false),
      menuItem(11, "Send Feedback", Icons.feedback_outlined,
          currentPage == DrawerSections.send_feedback ? true : false),
    ]);

    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(children: menuItems),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
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
              currentPage = DrawerSections.organization_dashboard;
            // } else if (id == 5) {
            //   currentPage = DrawerSections.opportunities;
            } else if (id == 6) {
              currentPage = DrawerSections.edit_org_profile;
            } else if (id == 7) {
              currentPage = DrawerSections.review_volunteer;
            } else if (id == 8) {
              currentPage = DrawerSections.settings;
            } else if (id == 9) {
              currentPage = DrawerSections.notifications;
            } else if (id == 10) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 11) {
              currentPage = DrawerSections.send_feedback;
            } else if (id == 12) {
              currentPage = DrawerSections.post_opportunity;
            } else if (id == 13) {
              currentPage = DrawerSections.user_mangament;
            }else if(id == 14){
              currentPage = DrawerSections.chat;
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
  organization_dashboard, // Organization Dashboard
  edit_org_profile, // Edit Organization Profile
  review_volunteer, // Review Volunteer
  post_opportunity, // post opportunity
  user_mangament
}

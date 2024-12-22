import 'package:flutter/material.dart';
import 'package:volunteers_app/views/dashboard/edit_organization.dart';
import 'package:volunteers_app/views/dashboard/organization_dashboard.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Center(
          child: 
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Orgprofile(),
                        ),
                      );
                    },
                    child: Text("Go to   Organization Profile"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrganizationDashboard(),
                        ),
                      );
                    },
                    child: Text("Go to   OrganizationDashboard "),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

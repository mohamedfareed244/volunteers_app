
import 'package:flutter/material.dart';

class OpportunityDetailsPage extends StatefulWidget {
  final String opportunityId;
  const OpportunityDetailsPage({super.key, required this.opportunityId});

  @override
  State<OpportunityDetailsPage> createState() => _OpportunityDetailsPageState();
}

class _OpportunityDetailsPageState extends State<OpportunityDetailsPage> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Opportunity ID: ${widget.opportunityId}'),
      ),
    );
  }
}
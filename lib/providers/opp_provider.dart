import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteers_app/models/opp_model.dart';

class OppProvider with ChangeNotifier {
  List<OppModel> get getOpp {
    return _opportunities;
  }

  OppModel? findByOppId(String oppId) {
    if (_opportunities.where((element) => element.OppId == oppId).isEmpty) {
      return null;
    }
    return _opportunities.firstWhere((element) => element.OppId == oppId);
  }

  List<OppModel> searchQuery({required String searchText}) {
    List<OppModel> searchList = _opportunities
        .where((element) =>
            element.OppTitle.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }

  List<OppModel> findByCategory({required String ctgName}) {
    List<OppModel> ctgList = _opportunities
        .where((element) => element.productCategory
            .toLowerCase()
            .contains(ctgName.toLowerCase()))
        .toList();
    return ctgList;
  }

  final oppDB = FirebaseFirestore.instance.collection("opportunitites");
  Future<List<OppModel>> fetchOppss() async {
    try {
      await oppDB.get().then((oppsSnapshot) {
        for (var element in oppsSnapshot.docs) {
          _opportunities.insert(0, OppModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return _opportunities;
    } catch (error) {
      rethrow;
    }
  }

  final List<OppModel> _opportunities = [];
}

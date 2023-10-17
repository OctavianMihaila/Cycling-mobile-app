import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _activitiesCollection = FirebaseFirestore.instance
      .collection('record_details');

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() => _instance;

  FirestoreService._internal();

  Future<void> addActivity(Map<String, dynamic> data) async {
    await _activitiesCollection.add(data);
  }

  Future<QuerySnapshot> getUserActivities(String userId) {
    return _activitiesCollection.where('userId', isEqualTo: userId).get();
  }
}

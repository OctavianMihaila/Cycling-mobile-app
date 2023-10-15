import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _activitiesCollection = FirebaseFirestore.instance.collection('record_details');

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() => _instance;

  FirestoreService._internal();

  Future<void> addActivity(String userId, Map<String, dynamic> data) async {
    data['userId'] = userId;
    await _activitiesCollection.add(data);
  }

  Future<QuerySnapshot> getUserActivities(String userId) {
    return _activitiesCollection.where('userId', isEqualTo: userId).get();
  }
}

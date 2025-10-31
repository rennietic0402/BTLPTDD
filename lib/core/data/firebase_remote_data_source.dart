import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRemoteDS<T> {
  final String collectionName;
  final T Function(DocumentSnapshot doc) fromFirestore;
  final Map<String, dynamic> Function(T item) toFirestore;
  final String? orderByField;
  final bool orderByDescending;

  FirebaseRemoteDS({
    required this.collectionName,
    required this.fromFirestore,
    required this.toFirestore,
    this.orderByField,
    this.orderByDescending = true,
  });

  CollectionReference get _collection =>
      FirebaseFirestore.instance.collection(collectionName);

  Future<List<T>> getAll() async {
    final Query query = (orderByField != null)
        ? _collection.orderBy(orderByField!, descending: orderByDescending)
        : _collection;
    final snapshot = await query.get();
    return snapshot.docs.map((e) => fromFirestore(e)).toList();
  }

  Future<T?> getById(String id) async {
    String docID = await getDocId(id);
    final doc = await _collection.doc(docID).get();
    if (!doc.exists) return null;
    return fromFirestore(doc);
  }

  Future<String> getDocId(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return doc.id;
    }
    final docuid = await _collection.where('uid', isEqualTo: id).limit(1).get();
    if (docuid.docs.isNotEmpty) {
      return docuid.docs.first.id;
    }
    return id;
  }

  Future<String> add(T item) async {
    final docRef = await _collection.add(toFirestore(item));
    return docRef.id;
  }

  Future<void> update(String id, T item) async {
    String docID = await getDocId(id);
    await _collection.doc(docID).update(toFirestore(item));
  }

  Future<void> delete(String id) async {
    String docID = await getDocId(id);
    await _collection.doc(docID).delete();
  }

  Stream<List<T>> watchAll() {
    final Stream<QuerySnapshot> stream = (orderByField != null)
        ? _collection
              .orderBy(orderByField!, descending: orderByDescending)
              .snapshots()
        : _collection.snapshots();
    return stream.map(
      (snapshot) => snapshot.docs.map((doc) => fromFirestore(doc)).toList(),
    );
  }

  String? getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}

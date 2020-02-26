import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/models/transaction.dart';

class DatabaseService {
  //final CollectionReference transactionCollection = Firestore.instance.collection('Trans');
  final CollectionReference userCollection = Firestore.instance.collection('Users');
  final String uid;

  DatabaseService({ this.uid });

  Future initializeUserProfile() async {
    return await userCollection.document(uid).setData({
      'FirstName': '',
      'LastName': '',
      'Age': 0,
    });
  }

  Future updateUserProfile(String firstName, String lastName, int age) async {
    return await userCollection.document(uid).setData({
      'FirstName': firstName,
      'LastName': lastName,
      'Age': age,
    });
  }

  List<UserTransaction> _userTransactionsFromSnapshot(QuerySnapshot snapshot) {
    var list = snapshot.documents.map((doc) {
      return UserTransaction(
        transID: doc.documentID,
        amount: doc.data['Amount'],
        company: doc.data['Company'],
        date: doc.data['Date'],
        mcc: doc.data['MCC'],
        region: doc.data['Region'],
      );
    }).toList();

    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  // TODO: filter by month, day, week
  Stream<List<UserTransaction>> get userTransactions {
    CollectionReference transactionCollection = userCollection.document(uid).collection('Trans');
    return transactionCollection.snapshots()
      .map(_userTransactionsFromSnapshot);
  }

  UserProfile _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserProfile(
      uid: uid,
      firstName: snapshot.data['FirstName'],
      lastName: snapshot.data['LastName'],
      age: snapshot.data['Age'],
    );
  }

  // Get user doc stream
  Stream<UserProfile> get userProfile {
    return userCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }
}
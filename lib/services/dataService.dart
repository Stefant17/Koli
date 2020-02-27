import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/models/transaction.dart';

class DatabaseService {
  //final CollectionReference transactionCollection = Firestore.instance.collection('Trans');
  final CollectionReference userCollection = Firestore.instance.collection('Users');
  final CollectionReference companyCollection = Firestore.instance.collection('Companies');
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


  Future createUserTransaction(UserTransaction trans) async {
    return await userCollection.document(uid).collection('Trans').document().setData({
      'Amount': trans.amount,
      'Company': trans.company,
      'Date': trans.date,
      'MCC': trans.mcc,
      'Region': trans.region,
    });
  }


  void editUserTransaction(UserTransaction editedTrans, String transID) async {
    return await userCollection.document(uid).collection('Trans').document(transID).updateData({
      'Amount': editedTrans.amount,
      'Company': editedTrans.company,
      'Date': editedTrans.date,
      'MCC': editedTrans.mcc,
      'Region': editedTrans.region,
    });
  }


  // Converts our date format to a format which can be handled by DateTime
  String convertToDateTimeFormat(String date) {
    List<String> splitDate = date.split("/");

    if(splitDate[1].length == 1) {
      splitDate[1] = '0' + splitDate[1];
    }

    if(splitDate[0].length == 1) {
      splitDate[0] = '0' + splitDate[0];
    }

    return splitDate[2] + '-' + splitDate[1] + '-' + splitDate[0] + ' 00:00:00.00';
  }


  List<UserTransaction> _userTransactionsFromSnapshot(QuerySnapshot snapshot) {
    List<UserTransaction> transList = snapshot.documents.map((doc) {
      return UserTransaction(
        transID: doc.documentID,
        amount: doc.data['Amount'],
        company: doc.data['Company'],
        date: doc.data['Date'],
        mcc: doc.data['MCC'],
        region: doc.data['Region'],
      );
    }).toList();

    transList.sort((a, b) {
      String aDate = convertToDateTimeFormat(a.date);
      String bDate = convertToDateTimeFormat(b.date);

      return DateTime.parse(bDate).compareTo(DateTime.parse(aDate));
    });
    return transList;
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

  List<Company> _companiesFromSnapshot(QuerySnapshot snapshot) {
    List<Company> companyList = snapshot.documents.map((doc) {
      return Company(
        companyID: doc.documentID,
        mccID: doc.data['MCC'],
        name: doc.data['Name'],
        region: doc.data['Region'],
      );
    }).toList();

    return companyList;
  }

  Stream<List<Company>> get companies {
    return companyCollection.snapshots()
      .map(_companiesFromSnapshot);
  }
}
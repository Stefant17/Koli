import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/category.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/models/transaction.dart';

class DatabaseService {
  //final CollectionReference transactionCollection = Firestore.instance.collection('Trans');
  final CollectionReference userCollection = Firestore.instance.collection('Users');
  final CollectionReference companyCollection = Firestore.instance.collection('Companies');
  final CollectionReference badgeCollection = Firestore.instance.collection('Badges');
  final CollectionReference categoryCollection = Firestore.instance.collection('Categories');
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


  Future<int> getCO2fromCompany(UserTransaction trans) async {
    var company = companyCollection.document(trans.companyID);
    var user = userCollection.document(uid);

    if(trans.category == 'Bensín') {
      var emissionPerLitre = 0.18;
      var avgKmPerLitre = 13;

      var carSize = '';
      var carFuel = '';
      var litrePrice = 0.0;

      await user.get().then((user) {
        carSize = user.data['CarSize'];
        carFuel = user.data['CarFuelType'];
      });

      await company.get().then((com) {
        if(carFuel == '95 Oktan') {
          litrePrice = com.data['PetrolPrice'];
        }

        else if(carFuel == 'Diesel') {
          litrePrice = com.data['DieselPrice'];
        }
      });


      double litres = trans.amount / litrePrice;
      return (litres * avgKmPerLitre * emissionPerLitre).toInt();
    }

    return 0;
  }


  Future createUserTransaction(UserTransaction trans) async {
    trans.co2 = await getCO2fromCompany(trans);

    return await userCollection.document(uid).collection('Trans').document().setData({
      'Amount': trans.amount,
      'Company': trans.company,
      'CompanyID': trans.companyID,
      'Date': trans.date,
      'MCC': trans.mcc,
      'Region': trans.region,
      'CategoryID': trans.categoryID,
      'Category': trans.category,
      'CO2': trans.co2,
    });
  }


  void editUserTransaction(UserTransaction editedTrans, String transID) async {
    editedTrans.co2 = await getCO2fromCompany(editedTrans);

    return await userCollection.document(uid).collection('Trans').document(transID).updateData({
      'Amount': editedTrans.amount,
      'Company': editedTrans.company,
      'CompanyID': editedTrans.companyID,
      'Date': editedTrans.date,
      'MCC': editedTrans.mcc,
      'Region': editedTrans.region,
      'Category': editedTrans.category,
      'CategoryID': editedTrans.categoryID,
      'CO2': editedTrans.co2,
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
        companyID: doc.data['CompanyID'],
        date: doc.data['Date'],
        mcc: doc.data['MCC'],
        region: doc.data['Region'],
        categoryID: doc.data['CategoryID'],
        category: doc.data['Category'],
        co2: doc.data['CO2'],
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
        co2: doc.data['Co2'],
      );
    }).toList();

    return companyList;
  }

  Stream<List<Company>> get companies {
    return companyCollection.snapshots()
      .map(_companiesFromSnapshot);
  }

  List<Category> _categoriesFromSnapshot(QuerySnapshot snapshot) {
    List<Category> categories = snapshot.documents.map((doc) {
      print('yo');
      return Category(
        catID: doc.documentID,
        name: doc.data['Name'],
      );
    }).toList();

    return categories;
  }

  Stream<List<Category>> get categories {
    return categoryCollection.snapshots()
      .map(_categoriesFromSnapshot);
  }


  int _co2FromSnapshot(QuerySnapshot snapshot) {

  }


  Stream<int> get co2valueForCurrentMonth {
    return userCollection.document(uid).collection('Trans').snapshots()
      .map(_co2FromSnapshot);
  }

  /*
  List<Badge> _badgesFromSnapshot(QuerySnapshot snapshot) {
    List<Badge> badges = snapshot.documents.map((doc) {
      doc.
      return Badge(

      );
    });
  }

  void checkForBadgesEarned() {
    Stream<List<Badge>> badges = badgeCollection.snapshots()
      .map(_badgesFromSnapshot);//userCollection.
  }
  */
}
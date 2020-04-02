import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/notification.dart';
import 'package:koli/models/userCard.dart';
import 'package:koli/models/category.dart';
import 'package:koli/models/co2_by_day.dart';
import 'package:koli/models/co2_by_month.dart';
import 'package:koli/models/co2_by_week.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/models/transaction.dart';
import 'package:http/http.dart' as http;


// Used only for statistic testing purposes
// Set to 0 when done with testing
const int monthOffset = 0;

class DatabaseService {
  //final CollectionReference transactionCollection = Firestore.instance.collection('Trans');
  final CollectionReference userCollection = Firestore.instance.collection('Users');
  final CollectionReference companyCollection = Firestore.instance.collection('Companies');
  final CollectionReference badgeCollection = Firestore.instance.collection('Badges');
  final CollectionReference categoryCollection = Firestore.instance.collection('Categories');
  final CollectionReference mccCollection = Firestore.instance.collection('MCC');
  final String uid;


  DatabaseService({ this.uid });

  Future initializeUserProfile() async {
    return await userCollection.document(uid).setData({
      'Username': '',
      'FirstName': '',
      'LastName': '',
      'Age': 0,
      'CarFuelType': "95 Oktan",
      'CarSize': 'Medium',
      'DaysActive': 1,
      'TreesPlanted': 0,
      'Meat': '',
      'Fish': '',
      'Fruit': '',
      'Dairy': '',
      'Grains': '',
    });
  }




  Future<String> getCompanyIdFromName(String companyName) async {
    String ID = '';
    var companies = await companyCollection.getDocuments();
    companies.documents.forEach((com) {
      if(com.data['Name'] == companyName) {
        ID = com.documentID;
      }
    });

    //TODO: if no id was found, create new store
    return ID;
  }


  Future<String> getMCCnameFromCode(String mcc) async {
    String ID = '';

    var companies = await mccCollection.getDocuments();
    companies.documents.forEach((m) {
      if(m.data['MCC'].toString() == mcc.toString()) {
        ID = m.documentID;
        return;
      }
    });

    return ID;
  }


  Future<Category> getDefaultCategoryFromCompany(String companyID) async {
    var company = companyCollection.document(companyID);
    String catID = await company.get().then((com) {
      return com.data['DefaultCategory'];
    });

    var category = categoryCollection.document(catID);
    String catName = await category.get().then((cat) {
      return cat.data['Name'];
    });

    return Category(
      catID: catID,
      name: catName,
    );
  }


  Future parseCardTransactions(var cardTransactions, int numberOfTrans) async {
    for(var i = numberOfTrans; i < cardTransactions.length; i++) {
      String compID = await getCompanyIdFromName(cardTransactions[i]['SOLUADILI']);
      String mcc = await getMCCnameFromCode(cardTransactions[i]['MCC']);

      Category cat = await getDefaultCategoryFromCompany(compID);
      var date = convertCardDateToAppFormat(cardTransactions[i]['FAERSLUDAGS']);

      UserTransaction newTrans = UserTransaction(
        amount: int.parse(cardTransactions[i]['FAERSLUUPPHAED']),
        company: cardTransactions[i]['SOLUADILI'],
        companyID: compID,
        category: cat.name,
        categoryID: cat.catID,
        date: date,
        mcc: mcc,
        region: cardTransactions[i]['INNLEND_ERLEND'],
      );

      createUserTransaction(newTrans);
    }
  }


  void updateCardTransCount(UserCard card, int newTransCount) {
    userCollection.document(uid).collection('Cards').document(card.cardID).setData({
      'CardNumber': card.cardNumber,
      'Expiry': card.expiry,
      'CVV': card.cvv,
      'TransCount': newTransCount,
    });
  }


  Future<List<UserCard>> getUserCards(CollectionReference cardsCollection) async {
    List<UserCard> userCards = [];

    QuerySnapshot cards = await cardsCollection.getDocuments();
    cards.documents.forEach((DocumentSnapshot snapshot) {
      UserCard newCard = UserCard(
        cardID: snapshot.documentID,
        cardNumber: snapshot.data['CardNumber'],
        cvv: snapshot.data['CVV'],
        expiry: snapshot.data['Expiry'],
        transCount: snapshot.data['TransCount']
      );

      userCards.add(newCard);
    });

    return userCards;
  }


  Future checkForNewCardTransactions() async {
    List<UserCard> cardList = await getUserCards(userCollection.document(uid)
        .collection('Cards'));

    for(var i = 0; i < cardList.length; i++) {
      String cardLines = await rootBundle.loadString(
          'assets/testing/card_transactions/${cardList[i].cardNumber}.json'
      );

      var decodedLines = json.decode(cardLines);
      int numberOfTrans = cardList[i].transCount;

      if(decodedLines.length > numberOfTrans) {
        updateCardTransCount(cardList[i], decodedLines.length);
        parseCardTransactions(decodedLines, numberOfTrans);
      }
    }
  }


  Future<bool> addCardToUser(String number, String expiry, String cvv) async {
    await userCollection.document(uid).collection('Cards').add({
      'CardNumber': number,
      'Expiry': expiry,
      'CVV': cvv,
      'TransCount': 0
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

    else if(trans.category == 'Fatnaður') {
      var category = categoryCollection.document(trans.categoryID);
      int total = 0;

      await category.get().then((cat) {
        total = (trans.amount * cat['co2_per_kr']).toInt();
      });

      return total.toInt();
    }

    /// stefan implementar
    else if(trans.category == 'Matvörur') {
      var user = userCollection.document(uid);
      var category = categoryCollection.document(trans.categoryID);
      int total = 0;
      int fish;
      int meat;
      int fruit;
      int dairy;
      int grain;
      int nuts;
      int vegetables;

      await user.get().then((user) {
        //print(user['FirstName']);
        fish = int.parse( user['Fish']);
        fruit = int.parse(user['Fruit']);
        meat = int.parse(user['Meat']);
        dairy = int.parse(user['Dairy']);
      });
      print(fish);
      print(fruit);
      print(meat);
      print(dairy);

      grain = ((fish + fruit + meat + dairy)/3 *2).round();
      nuts = ((fish + fruit + meat + dairy)/3).round();

      await category.get().then((cat) {
        //var fish = cat['co2_per_kr_fish'];
        meat = (trans.amount * meat * cat['co2_per_kr_meat']).round();
        fish = (trans.amount * fish * cat['co2_per_kr_fish']).round();
        fruit = (trans.amount * fruit * cat['co2_per_kr_fruit']).round();
        nuts = (trans.amount * nuts * cat['co2_per_kr_nuts']).round();
        dairy =  (trans.amount * dairy * cat['co2_per_kg_dairy']).round();
        grain = (trans.amount * grain * cat['co2_per_kr_grains']).round();




        total = meat + fish + fruit + nuts + dairy + grain;
        print(total);

      });
      print(total);

      return total;
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


  String convertCardDateToAppFormat(String date) {
    var newDate = date.toString().split(' ');
    var formattedDate = newDate[0].toString().split('.');

    return formattedDate[0].toString()[1] + '/'
        + formattedDate[1].toString()[1] + '/'
        + formattedDate[2].toString();
  }

  // Converts the app date format to a format which can be handled by DateTime
  String convertToDateTimeFormat(String date) {
    List<String> splitDate;

    if(date.contains('/')) {
      splitDate = date.split('/');
    }

    else if(date.contains('.')) {
      splitDate = date.split('.');
    }

    if(splitDate[1].length == 1) {
      splitDate[1] = '0' + splitDate[1];
    }

    if(splitDate[0].length == 1) {
      splitDate[0] = '0' + splitDate[0];
    }

    return splitDate[2] + '-' + splitDate[1] + '-' + splitDate[0] + ' 00:00:00.00';
  }


  String getYear(String date) {
    List<String> splitDate = date.split('/');
    return splitDate[2];
  }


  String getMonth(String date) {
    List<String> splitDate = date.split('/');
    return splitDate[1];
  }


  String getDay(String date) {
    List<String> splitDate = date.split('/');
    return splitDate[0];
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
      treesPlanted: snapshot.data['TreesPlanted'],
      daysActive: snapshot.data['DaysActive'],
      carSize: snapshot.data['CarSize'],
      carFuelType: snapshot.data['CarFuelType'],
      meat: snapshot.data['Meat'],
      fish: snapshot.data['Fish'],
      dairy: snapshot.data['Dairy'],
      fruit: snapshot.data['Fruit'],
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


  int _co2ForCurrentMonthFromSnapshot(QuerySnapshot snapshot) {
    DateTime currentDate = DateTime.now();
    int total = 0;

    snapshot.documents.map((doc) {
      if(getMonth(doc.data['Date']) == currentDate.month.toString()) {
        total += doc.data['CO2'];
      }
    }).toList();

    return total;
  }


  Stream<int> get co2valueForCurrentMonth {
    CollectionReference transactionCollection = userCollection.document(uid).collection('Trans');
    return transactionCollection.snapshots()
      .map(_co2ForCurrentMonthFromSnapshot);
  }


  CO2ByMonth _co2ByMonthFromSnapshot(QuerySnapshot snapshot) {
    DateTime currentDate = DateTime.now();
    int currentMonth = currentDate.month + monthOffset;
    int currentYear = currentDate.year;

    List<String> months = Date(currentDate).getListOfMonthsToDate(currentMonth);
    List<int> co2ValuePerMonth = [];

    for(var i = 0; i < currentMonth; i++) {
      co2ValuePerMonth.add(0);
    }

    snapshot.documents.map((trans) {
      int year = int.parse(getYear(trans.data['Date']));

      if(year == currentYear) {
        int month = int.parse(getMonth(trans.data['Date']));

        if(co2ValuePerMonth[month - 1] == 0) {
          co2ValuePerMonth[month - 1] = trans.data['CO2'];
        } else {
          int total = co2ValuePerMonth[month - 1];

          total += trans.data['CO2'];
          co2ValuePerMonth[month - 1] = total;
        }
      }
    }).toList();

    return CO2ByMonth(
      months: months,
      co2Values: co2ValuePerMonth,
    );
  }


  Stream<CO2ByMonth> get co2ByMonth {
    CollectionReference transactionCollection = userCollection.document(uid).collection('Trans');
    return transactionCollection.snapshots()
        .map(_co2ByMonthFromSnapshot);
  }


  Stream<CO2ByWeek> get co2ByWeek {

  }


  Stream<CO2ByDay> get co2ByDay {

  }

  Future<http.Response> getInfo() {
    return http.get('http://mbl.is'); //mavg/tas/2020/2039/ISL');
  }

  Future<void> getClimateChangeInfo() async {
    var response = await getInfo();

    if(response.statusCode == 200) {
      //print('hurra');
    } else {
      print('oh no');
    }
    //print('body: [${response.body}]');
    //print(response.body);
    //print(json.decode(response.body));
  }


  // Does the user already own this badge?
  Future<bool> doesBadgeExist(String badgeID, CollectionReference userBadges) async {
    bool exists = false;

    QuerySnapshot badges = await userBadges.getDocuments();
    badges.documents.forEach((DocumentSnapshot snapshot) {
      if(snapshot.documentID == badgeID) {
        exists = true;
      }
    });

    return exists;
  }


  Future<Badge> createBadge(user, badge) async {
    var newBadge = Badge(
      name: badge.data['Name'],
      dateEarned: Date(DateTime.now()).getCurrentDate(),
      description: badge.data['Description'],
      image: badge.data['Image'],
    );

    await user.collection('Badges').document(badge.documentID).setData({
      'Name': newBadge.name,
      'DateEarned': newBadge.dateEarned,
      'Description': newBadge.description,
      'Image': newBadge.image,
    });

    return newBadge;
  }


  Future<bool> checkConditions(user, badge) async {
    if (badge.data['Condition'] == 'Plant Trees') {
      return await user.get().then((u) {
        if (u.data['TreesPlanted'] >= badge.data['ConditionValue']) {
          return true;
        } else {
          return false;
        }
      });
    }

    else if(badge.data['Condition'] == 'Number of Days') {
      return await user.get().then((u) {
        if (u.data['DaysActive'] >= badge.data['ConditionValue']) {
          return true;
        } else {
          return false;
        }
      });
    }

    return false;
  }


  Future awardBadges(Function addNewBadge) async {
    DocumentReference user = userCollection.document(uid);
    CollectionReference userBadges = user.collection('Badges');
    List<Badge> newBadges = [];

    await badgeCollection.snapshots().map((snapshot) {
      snapshot.documents.map((doc) async {
        if(!await doesBadgeExist(doc.documentID, userBadges)) {
          if(await checkConditions(user, doc)) {
            Badge newBadge = await createBadge(user, doc);
            newBadges.add(newBadge);
            addNewBadge(newBadge);
          }
        }
      }).toList();
    }).toList();
  }

  List<Badge> _userBadgesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Badge(
        name: doc.data['Name'],
        description: doc.data['Description'],
        dateEarned: doc.data['DateEarned'],
        image: doc.data['Image'],
      );
    }).toList();
  }


  Stream<List<Badge>> get userBadges {
    return userCollection.document(uid).collection('Badges').snapshots()
      .map(_userBadgesFromSnapshot);
  }


  List<UserProfile> _userFriendsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserProfile(
        uid: doc.documentID,
        firstName: doc.data['FirstName'],
        lastName: doc.data['LastName'],
        pendingInvite: doc.data['PendingInvite'],
      );
    }).toList();
  }


  Stream<List<UserProfile>> get friendList {
    return userCollection.document(uid).collection('Friends').snapshots()
      .map(_userFriendsFromSnapshot);
  }

  Future<List<UserProfile>> userSearch(String query) async {
    List<String> preExistingFriends = [];
    List<UserProfile> result = [];
    if(query == '') {
      return result;
    }

    var friends = await userCollection.document(uid).collection('Friends').getDocuments();
    friends.documents.forEach((friend) {
      preExistingFriends.add(friend.documentID);
    });

    var users = await userCollection.getDocuments();
    users.documents.forEach((user) {
      if(user.documentID != uid) {
        if(user.data['FirstName'].toString().toLowerCase().contains(query.toLowerCase())) {
          if(!preExistingFriends.contains(user.documentID)) {
            result.add(
              UserProfile(
                uid: user.documentID,
                firstName: user.data['FirstName'],
                lastName: user.data['LastName']
              )
            );
          }
        }
      }
    });

    return result;
  }

  Future<void> addFriend(String newFriendID) async {
    UserProfile newFriend = await userCollection.document(newFriendID).get().then((friend) {
      return UserProfile(
        uid: friend.documentID,
        firstName: friend.data['FirstName'],
        lastName: friend.data['LastName'],
        age: friend.data['Age'],
        treesPlanted: friend.data['TreesPlanted'],
        daysActive: friend.data['DaysActive'],
        carSize: friend.data['CarSize'],
        carFuelType: friend.data['CarFuelType'],
      );
    });

    userCollection.document(uid).collection('Friends').document(newFriendID).setData({
      'FirstName': newFriend.firstName,
      'LastName': newFriend.lastName,
      'Age': newFriend.age,
      'TreesPlanted': newFriend.treesPlanted,
      'DaysActive': newFriend.daysActive,
      'CarSize': newFriend.carSize,
      'CarFuelType': newFriend.carFuelType,
      'PendingInvite': true,
    });

    String currentUserName  = await userCollection.document(uid).get().then((u){
      return u.data['FirstName'];
    });

    userCollection.document(newFriendID).collection('Notifications').add({
      'Type': 'Friend Request',
      'From': currentUserName,
      'FromID': uid
    });
  }


  List<UserNotification> _friendRequestsFromSnapshot(QuerySnapshot snapshot) {
    List<UserNotification> requests = [];
    snapshot.documents.map((doc) {
      if(doc.data['Type'] == 'Friend Request') {
        requests.add(UserNotification(
          notificationID: doc.documentID,
          type: doc.data['Type'],
          from: doc.data['From'],
          fromID: doc.data['FromID'],
        ));
      }
    }).toList();

    return requests;
  }


  Stream<List<UserNotification>> get friendRequests {
    return userCollection.document(uid).collection('Notifications').snapshots()
      .map(_friendRequestsFromSnapshot);
  }


  Stream<List<UserNotification>> get notifications {
    return userCollection.document(uid).collection('Notifications').snapshots()
      .map(_friendRequestsFromSnapshot);
  }

  Future<void> acceptFriendRequest(String fromID, String notifID) async {
    UserProfile newFriend = await userCollection.document(fromID).get().then((friend) {
      return UserProfile(
        uid: friend.documentID,
        firstName: friend.data['FirstName'],
        lastName: friend.data['LastName'],
        age: friend.data['Age'],
        treesPlanted: friend.data['TreesPlanted'],
        daysActive: friend.data['DaysActive'],
        carSize: friend.data['CarSize'],
        carFuelType: friend.data['CarFuelType'],
      );
    });

    userCollection.document(uid).collection('Friends').document(fromID).setData({
      'FirstName': newFriend.firstName,
      'LastName': newFriend.lastName,
      'Age': newFriend.age,
      'TreesPlanted': newFriend.treesPlanted,
      'DaysActive': newFriend.daysActive,
      'CarSize': newFriend.carSize,
      'CarFuelType': newFriend.carFuelType,
      'PendingInvite': false,
    });

    userCollection.document(fromID).collection('Friends').document(uid).updateData({
      'PendingInvite': false,
    });

    userCollection.document(uid).collection('Notifications').document(notifID).delete();
  }

  // TODO: Decline friend request
  Future<void> declineFriendRequest(String fromID, String notifID) async {

  }

  Future<void> updateUserProfile(String firstName, String lastName, int age, String meat, String fish, String dariy, String fruit, String CarFuelType, String CarSize, int TreesPlanted, String Username, int DaysActive) async {
    return await userCollection.document(uid).setData({
      'FirstName': firstName,
      'LastName': lastName,
      'Age': age,
      'Meat': meat,
      'Fish': fish,
      'Fruit': fruit,
      'Dairy': dariy,
      'CarFuelType': CarFuelType,
      'CarSize': CarSize,
      'Username': Username,
      'TreesPlanted': TreesPlanted,
      'DaysActive': DaysActive,
    });
  }
}
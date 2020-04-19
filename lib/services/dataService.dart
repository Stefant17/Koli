import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/co2_by_category.dart';
import 'package:koli/models/meKoli_avatar.dart';
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
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../models/userCard.dart';


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

  Future initializeUserProfile(String email) async {
    return await userCollection.document(uid).setData({
      'Username': '',
      'FirstName': '',
      'LastName': '',
      'Age': 0,
      'CarFuelType': "95 Oktan",
      'CarSize': 'Medium',
      'DaysActive': 1,
      'TreesPlanted': 0,
      'DateJoined': '',
      'Meat': '0.09',
      'Fish': '0.05',
      'Fruit': '0.15',
      'Dairy': '0.20',
      'Grains': '0',
      'Email': email,
      'DateJoined': Date(DateTime.now()).getCurrentDate(),
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
      String date = convertCardDateToAppFormat(cardTransactions[i]['FAERSLUDAGS']);

      Category cat = await getDefaultCategoryFromCompany(compID);

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
    userCollection.document(uid).collection('Cards').document(card.cardID).updateData({
      'TransCount': newTransCount,
    });
  }


  Future<List<UserCard>> getUserCards(CollectionReference cardsCollection) async {
    List<UserCard> userCards = [];

    QuerySnapshot cards = await cardsCollection.getDocuments();
    cards.documents.forEach((DocumentSnapshot snapshot) {
      UserCard newCard = UserCard(
        cardID: snapshot.documentID,
        cardNumber: snapshot.data['CardNumber'].replaceAll(' ', ''),
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
      try {
        print(cardList[i].cardNumber);
        String cardLines = await rootBundle.loadString(
            'assets/testing/card_transactions/${cardList[i].cardNumber.replaceAll(' ', '')}.json'
        );

        var decodedLines = json.decode(cardLines);
        int numberOfTrans = cardList[i].transCount;

        if(decodedLines.length > numberOfTrans) {
          updateCardTransCount(cardList[i], decodedLines.length);
          parseCardTransactions(decodedLines, numberOfTrans);
        }
      } catch(e) {
        print(e);
      }
    }
  }


  Future<bool> addCardToUser(String number, String expiry, String cvv, String provider) async {
    await userCollection.document(uid).collection('Cards').add({
      'CardNumber': number,
      'Expiry': expiry,
      'CVV': cvv,
      'Provider': provider,
      'TransCount': 0
    });
  }


  Future<int> getCO2fromCompany(UserTransaction trans) async {
    var company = companyCollection.document(trans.companyID);
    var user = userCollection.document(uid);

    var companyName = await company.get().then((com) {
      return com['Name'];
    });

    if(companyName == 'Kolviður') {
      return 0;
    }

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
      double total = 0;
      double fish;
      double meat;
      double fruit;
      double dairy;
      double grain;
      double nuts;
      double vegetables;

      await user.get().then((user) {
        //print(user['FirstName']);
        fish = double.parse( user['Fish']);
        fruit = double.parse(user['Fruit']);
        meat = double.parse(user['Meat']);
        dairy = double.parse(user['Dairy']);
      });

      grain = ((fish + fruit + meat + dairy)/3 *2);
      nuts = ((fish + fruit + meat + dairy)/3);

      await category.get().then((cat) {
        //var fish = cat['co2_per_kr_fish'];
        meat = (trans.amount * meat * cat['co2_per_kr_meat']);
        fish = (trans.amount * fish * cat['co2_per_kr_fish']);
        fruit = (trans.amount * fruit * cat['co2_per_kr_fruit']);
        nuts = (trans.amount * nuts * cat['co2_per_kr_nuts']);
        dairy =  (trans.amount * dairy * cat['co2_per_kg_dairy']);
        grain = (trans.amount * grain * cat['co2_per_kr_grains']);

        total = meat + fish + fruit + nuts + dairy + grain;
      });
      return (total).toInt();
    }

    return 0;
  }


  Future createUserTransaction(UserTransaction trans) async {
    trans.co2 = await getCO2fromCompany(trans);

    Company company = await companyCollection.document((trans.companyID)).get().then((com) {
      print('yo');
      return Company(
        co2Friendly: com.data['Co2Friend']
      );
    });

    print('_shownotification before');
    if(company.co2Friendly){
      print('_shownotification after');
      //BackgroundService()._showNotification();
    }

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

    if(date.contains(new RegExp(r'[A-Z]'))) {
      return '';
    }

    if(date.contains('/')) {
      splitDate = date.split('/');
    }

    else if(date.contains('.')) {
      splitDate = date.split('.');
    }

    else {
      return '';
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
        co2Friendly: doc.data['Co2Friend'],
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

    categories.sort((a, b) {
      return a.name.compareTo(b.name);
    });

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

  //TODO: Kannski sýna líka hversu mikið notandi jafnaði sig
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


  CO2ByCategory _co2byCategoryFromSnapshot(QuerySnapshot snapshot) {

  }


  Stream<CO2ByCategory> get co2ByCategory {

  }


  CO2ByCategory _co2byCategoryForCurrentMonthFromSnapshot(QuerySnapshot snapshot) {
    String currentMonth = getMonth(Date(DateTime.now()).getCurrentDate());

    List<String> categories = [];
    List<int> co2Values = [];

    snapshot.documents.map((doc) {
      if(getMonth(doc.data['Date']) == currentMonth && doc.data['Category'] != 'Málefni') {
        categories.add(doc.data['Category']);
        co2Values.add(doc.data['CO2']);
      }
    }).toList();

    return CO2ByCategory(
      categories: categories,
      co2Values: co2Values,
    );
  }


  Stream<CO2ByCategory> get co2ByCategoryForCurrentMonth {
    return userCollection.document(uid).collection('Trans').snapshots()
      .map(_co2byCategoryForCurrentMonthFromSnapshot);
  }


  Stream<CO2ByWeek> get co2ByWeek {

  }


  Stream<CO2ByDay> get co2ByDay {

  }

  Future<http.Response> getInfo() {
    return http.get('http://mbl.is'); //mavg/tas/2020/2039/ISL');
  }

  Future<void> getClimateChangeInfo() async {
    /*var response = await getInfo();

    if(response.statusCode == 200) {
      //print('hurra');
    } else {
      print('oh no');
    }
    //print('body: [${response.body}]');
    //print(response.body);
    //print(json.decode(response.body));

     */
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
    return await user.get().then((u) {
      if(u.data[badge.data['Condition']] >= badge.data['ConditionValue']) {
        return true;
      } else {
        return false;
      }
    });
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

  //TODO: Implement this shiz
  Future<void> plantTrees(int treeCount, int price, UserCard card, String donorName, String donorEmail) async {
    // Get the document for Kolviður
    Company company = await companyCollection.document('jJCsR0JmqcBRhWZxfWTU').get().then((com) {
      return Company(
        companyID: com.documentID,
        mccID: com.data['MCC'],
        name: com.data['Name'],
        region: com.data['Region'],
      );
    });

    var trans = UserTransaction(
      amount: price,
      company: company.name,
      companyID: company.companyID,
      date: Date(DateTime.now()).getCurrentDate(),
      mcc: company.mccID,
      categoryID: ' xCvETWEJWb6bBJe7Oc9y',
      category: 'Málefni',
      region: company.region
    );

    //TODO: Credit card stuff

    await createUserTransaction(trans);

    int currentUserTreeCount = await userCollection.document(uid).get().then((user) {
      return user.data['TreesPlanted'];
    });
    await userCollection.document(uid).updateData({
      'TreesPlanted': currentUserTreeCount + treeCount,
    });

    if(donorEmail == null || donorEmail == '') {
      donorEmail = await userCollection.document(uid).get().then((user) {
        return user.data['Email'];
      });
    }

    if(donorName == null || donorName == '') {
      donorName = await userCollection.document(uid).get().then((user) {
        return user.data['FirstName'];
      });
    }

    sendDonationEmail(donorName, donorEmail);
    sendConfirmationToKoli(donorName, donorEmail, price, treeCount);
  }

  void sendDonationEmail(String donorName, String donorEmail) async {
    String username = 'koli.kolur.kolason@gmail.com';
    String password = 'Koli1234';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Koli')
      ..recipients.add(donorEmail)
      ..subject = 'Tylkinning um framlag til Kolviðar'
      ..text =
      'Hæ $donorName, \n\nOkkur hefur borist framlag til Kolviðar í þínu nafni.'
      '\nPeningurinn mun fara í það að gróðursetja tré hér á landi. \n\n '
      'Takk fyrir stuðninginn xoxo \n\n-Koli';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch(error) {
      print(error);
      for(var p in error.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  void sendConfirmationToKoli(String donorName, String donorEmail, int price, int treeAmount) async {
    String username = 'koli.kolur.kolason@gmail.com';
    String password = 'Koli1234';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Koli')
      ..recipients.add(username)
      ..subject = 'Staðfesting um framlag til Kolviðar - $donorName'
      ..text =
          'Staðfesting um framlag til kolviðar\n'
          '-----------------------------------\n'
          'Nafn:            $donorName\n'
          'Netfang:        $donorEmail\n'
          'Fjöldi trjáa:    $treeAmount\n'
          'Verð:            $price\n';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch(error) {
      print(error);
      for(var p in error.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  List<UserCard> _userCardsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((card) {
      return UserCard(
        cardID: card.documentID,
        cardNumber: card['CardNumber'],
        expiry: card['Expiry'],
        cvv: card['CVV'],
        provider: card['Provider'],
      );
    }).toList();
  }

  Stream<List<UserCard>> get userCards {
    return userCollection.document(uid).collection('Cards').snapshots()
      .map(_userCardsFromSnapshot);
  }

  void confirmMeKoli(List<String> meKoli) async {
    userCollection.document(uid).collection('meKoli').document('avatar').setData({
      'Face': meKoli[0],
      'Mouth': meKoli[1],
      'Eyes': meKoli[2],
      'Beard': meKoli[3],
      'Eyebrows': meKoli[4]
    });
  }

  MeKoliAvatar _meKoliAvatarFromSnapshot(DocumentSnapshot snapshot) {
    return MeKoliAvatar(
      face: snapshot.data['Face'],
      eyes: snapshot.data['Eyes'],
      mouth: snapshot.data['Mouth'],
      eyebrows: snapshot.data['Eyebrows'],
      beard: snapshot.data['Beard'],
    );
  }

  Stream<MeKoliAvatar> get meKoliAvatar {
    return userCollection.document(uid).collection('meKoli').document('avatar').snapshots()
      .map(_meKoliAvatarFromSnapshot);
  }
}
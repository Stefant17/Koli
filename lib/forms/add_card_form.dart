import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/card_input_formatters.dart';
import 'package:provider/provider.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';

class AddCardForm extends StatefulWidget {
  @override
  _AddCardFormState createState() => _AddCardFormState();
}

class _AddCardFormState extends State<AddCardForm> {
  String cardNumber = '';
  String cardExpiry = '';
  String cardCVV = '';
  String cardProvider = '';

  String errorMessage = '';

  bool isCardValid = false;
  bool hasCheckedCardNumber = false;

  AlertDialog confirmationPopup() {
    return AlertDialog(
      //title: Text('Rewind and remember'),
      content: SingleChildScrollView(
        child: Text('Kortið hefur verið tengt við aðganginn þinn')
      ),

      actions: <Widget>[
        FlatButton(
          child: Text('Í lagi'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: appBar(context, ''),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(
              'Bæta við nýju korti',
              style: TextStyle(
                fontSize: 30,
              ),
            ),

            SizedBox(height: 10),

            Text(
              'Með því að stimpla inn kortaupplýsingar hér fyrir neðan geturðu'
              ' tengt nýtt kort við aðganginn þinn. Færslur á kortinu munu ganga'
              ' upp í kolefnissporið þitt.'
            ),

            SizedBox(height: 20),

            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Kortanúmer',
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                        ),
                      ),
                    ),

                    validator: (val) =>
                    val.isEmpty
                        ? 'Sláðu inn númer'
                        : null,

                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(19),
                      WhitelistingTextInputFormatter.digitsOnly,
                      new CardNumberInputFormatter(),
                    ],

                    onChanged: (val) {
                      setState(() {
                        cardNumber = val;
                      });
                    },

                    onFieldSubmitted: (val) {
                      Map<String, dynamic> cardData = CreditCardValidator.getCard(cardNumber.replaceAll(' ', ''));

                      isCardValid = cardData[CreditCardValidator.isValidCard];

                      setState(() {
                        hasCheckedCardNumber = true;
                      });

                      if(isCardValid) {
                        setState(() {
                          cardProvider = cardData[CreditCardValidator.cardType];
                        });
                      } else {
                        setState(() {
                          cardProvider = '';
                        });
                      }
                    },
                  ),
                ),

                SizedBox(width: 10),

                !isCardValid && hasCheckedCardNumber ?
                Icon(
                  FontAwesomeIcons.times,
                  color: Colors.red,
                ): isCardValid ?
                Icon(
                  FontAwesomeIcons.check,
                  color: Colors.green,
                )
                :Text(''),

                SizedBox(width: 10),
              ],
            ),

            SizedBox(height: 20),

            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: 70,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Dags.',
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                        ),
                      ),
                    ),

                    validator: (val) =>
                    val.isEmpty
                        ? 'Sláðu inn dagsetningu'
                        : null,

                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                      WhitelistingTextInputFormatter.digitsOnly,
                      new CardDateInputFormatter(),
                    ],

                    onChanged: (val) {
                      setState(() {
                        cardExpiry = val;
                      });
                    },
                  ),
                ),

                SizedBox(width: 10),

                Container(
                  width: 90,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Öryggiskóði',
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                        ),
                      ),
                    ),

                    validator: (val) =>
                    val.isEmpty
                        ? 'Sláðu inn öryggiskóða'
                        : null,

                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],

                    onChanged: (val) {
                      setState(() {
                        cardCVV = val;
                      });
                    },
                  ),
                ),


                //SizedBox(width: 40),

                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.ccVisa,
                          size: 45,
                          color: cardProvider != 'VISA' ? Colors.grey[500] : Colors.blue,
                        ),

                        SizedBox(width: 20),

                        Icon(
                          FontAwesomeIcons.ccMastercard,
                          size: 45,
                          color: cardProvider != 'MASTERCARD' ? Colors.grey[500] : Colors.red[400],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 20),

            Container(
              alignment: Alignment.centerRight,
              child: RaisedButton(
                elevation: 0.0,
                color: Colors.white,
                child: Text(
                  'Staðfesta',
                  style: TextStyle(
                    color: isCardValid ? Colors.black : Colors.grey[100],
                  ),
                ),

                padding: EdgeInsets.fromLTRB(40, 15, 40, 15),

                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: isCardValid ? Colors.black : Colors.grey[100],
                      width: 2,
                    )
                ),

                onPressed: () {
                  if(isCardValid) {
                    DatabaseService(uid: user.uid).addCardToUser(
                      cardNumber, cardExpiry, cardCVV, cardProvider
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return confirmationPopup();
                      }
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
      floatingActionButton: Constants().homeFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

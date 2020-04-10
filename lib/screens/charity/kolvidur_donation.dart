import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/userCard.dart';
import 'package:koli/shared/card_input_formatters.dart';
import 'package:provider/provider.dart';

import '../../services/dataService.dart';

class KolvidurDonation extends StatefulWidget {
  @override
  _KolvidurDonationState createState() => _KolvidurDonationState();
}

class _KolvidurDonationState extends State<KolvidurDonation> {
  String cardChoice = 'old';
  String selectedCardID = '';

  String cardNumber = '';
  String cardExpiry = '';
  String cardCVV = '';
  String cardProvider = '';

  bool isCardValid = false;
  bool hasCheckedCardNumber = false;

  var selectedTreeOption = '10 Tré - 2.200 kr.';
  var treeOptions = [
    [0, '10 Tré - 2.200 kr.', 10, 2200],
    [1, '25 Tré - 5.500 kr.', 25, 5500],
    [2, '50 Tré - 11.000 kr.', 50, 11000],
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Styrkja Kolvið',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 10),

          Text(
            /*'Vissir þú að það að gróðursetja eitt tré getur bundið rúmlega '
            '20 kg af CO2 á einu ári? Þegar tréð er orðið fullvaxið mun það '
            'hafa bundið yfir eitt tonn af CO2. '*/
            ''
          ),

          DropdownButton<String>(
            elevation: 1,
            value: selectedTreeOption,
            items: treeOptions.map((opt) {
              return DropdownMenuItem<String>(
                value: opt[1],
                child: Text(opt[1]),
              );
            }).toList(),

            onChanged: (val) {
              setState(() {
                selectedTreeOption = val;
              });
            },
          ),

          Row(
            children: <Widget>[
              Radio(
                groupValue: cardChoice,
                value: 'old',
                onChanged: (val) {
                  setState(() {
                    cardChoice = val;
                  });
                },
              ),

              Text('Nota eitt af mínum kortum'),
            ],
          ),

          Row(
            children: <Widget>[
              Radio(
                groupValue: cardChoice,
                value: 'new',
                onChanged: (val) {
                  setState(() {
                    cardChoice = val;
                  });
                },
              ),

              Text('Nota annað kort'),
            ],
          ),

          cardChoice == 'old' ?
          StreamBuilder<List<UserCard>>(
            stream: DatabaseService(uid: user.uid).userCards,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<UserCard> cards = snapshot.data;

                return Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: cards.map((card) {
                            var hiddenCardNumber = '';
                            for(var i = 0; i < card.cardNumber.length; i++) {
                              if(i < card.cardNumber.length - 4) {
                                if(card.cardNumber[i] != ' ') {
                                  hiddenCardNumber += '*';
                                } else {
                                  hiddenCardNumber += ' ';
                                }
                              } else {
                                hiddenCardNumber += card.cardNumber[i];
                              }
                            }

                            return InkWell(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                color: selectedCardID == card.cardID ? Colors.grey[100] : Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: Icon(
                                        card.provider == 'VISA' ?
                                        FontAwesomeIcons.ccVisa
                                        :card.provider == 'MASTERCARD' ?
                                        FontAwesomeIcons.ccMastercard
                                        :null,

                                        color: card.provider == 'VISA' ?
                                        Colors.blueAccent
                                        :card.provider == 'MASTERCARD' ?
                                        Colors.red[500]
                                        :null,

                                        size: 40,
                                      ),
                                    ),

                                    SizedBox(width: 20),

                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              hiddenCardNumber,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),

                                            SizedBox(height: 2),

                                            Container(
                                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                              child: Text(
                                                card.expiry,
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              onTap: () {
                                setState(() {
                                  selectedCardID = card.cardID;
                                  cardNumber = card.cardNumber;
                                  cardCVV = card.cvv;
                                  cardExpiry = card.expiry;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      RaisedButton(
                        elevation: 0.0,
                        color: Colors.white,
                        child: Text(
                          'Áfram',
                          style: TextStyle(
                            color: selectedCardID != '' ? Colors.black : Colors.grey[100],
                          ),
                        ),

                        padding: EdgeInsets.fromLTRB(40, 15, 40, 15),

                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: selectedCardID != '' ? Colors.black : Colors.grey[100],
                              width: 2,
                            )
                        ),

                        onPressed: () {
                          if(selectedCardID != '' && selectedTreeOption != '') {
                            var newCard = UserCard(
                              cardNumber: cardNumber,
                              expiry: cardExpiry,
                              cvv: cardCVV,
                            );

                            int treeAmount;
                            int price;

                            for(var i = 0; i < treeOptions.length; i++) {
                              if(treeOptions[i][1] == selectedTreeOption) {
                                treeAmount = treeOptions[i][2];
                                price = treeOptions[i][3];
                              }
                            }

                            Navigator.pushNamed(
                              context,
                              '/Staðfesta framlag',
                              arguments: {
                                'card': newCard,
                                'price': price,
                                'treeAmount': treeAmount,
                              }
                            );

                            //Navigator.pop(context);
                          }
                        },
                      ),

                    ],
                  ),
                );
              } else {
                return Text('Augnablik');
              }
            }
          )
          :
          Container(
            child: Column(
              children: <Widget>[
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

                RaisedButton(
                  elevation: 0.0,
                  color: Colors.white,
                  child: Text(
                    'Áfram',
                    style: TextStyle(
                      color: selectedCardID != '' ? Colors.black : Colors.grey[100],
                    ),
                  ),

                  padding: EdgeInsets.fromLTRB(40, 15, 40, 15),

                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: selectedCardID != '' ? Colors.black : Colors.grey[100],
                        width: 2,
                      )
                  ),

                  onPressed: () {
                    if(selectedTreeOption != '') {
                      //blablabla
                      //Navigator.pop(context);
                    }
                  },
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}

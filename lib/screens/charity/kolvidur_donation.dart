import 'package:flutter/material.dart';

import '../../services/dataService.dart';

class KolvidurDonation extends StatefulWidget {
  @override
  _KolvidurDonationState createState() => _KolvidurDonationState();
}

class _KolvidurDonationState extends State<KolvidurDonation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
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
            'Vissir þú að það að gróðursetja eitt tré getur bundið rúmlega '
            '20 kg af CO2 á einu ári? Þegar tréð er orðið fullvaxið mun það '
            'hafa bundið yfir eitt tonn af CO2. '
          ),

          TextFormField(
            decoration: InputDecoration(
              labelText: 'Verð',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                ),
              ),
            ),

            validator: (val) =>
            val.isEmpty
                ? 'Sláðu inn verð'
                : null,

            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontFamily: 'Poppins',
            ),

            onChanged: (val) {
              setState(() {
                //newAmount = int.parse(val);
              });
            },
          ),
        ],
      ),
    );
  }
}

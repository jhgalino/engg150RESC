import 'package:flutter/material.dart';
import 'package:resc/calculations/calc.dart';
import 'package:resc/components/recommendations.dart';

import '../invariants/invariants.dart';

class CalcResult extends StatefulWidget {
  double? floorArea;
  int? bcSAL;
  int? bcLL;
  int? bcBL;
  int serviceVoltage;

  CalcResult(
      {this.floorArea,
      this.bcSAL,
      this.bcLL,
      this.bcBL,
      required this.serviceVoltage,
      Key? key})
      : super(key: key);

  @override
  State<CalcResult> createState() => _CalcResultState();
}

class _CalcResultState extends State<CalcResult> {
  double? _safetyFactor;
  bool _safetyFactorValid = true;
  String _conductorMaterial = "copper";
  String _conductorType = "tw";

  @override
  Widget build(BuildContext context) {
    return _computedDialog(widget.floorArea, widget.bcSAL, widget.bcLL,
        widget.bcBL, widget.serviceVoltage);
  }

  Widget _computedDialog(
      double? floorArea, int? bcSAL, int? bcLL, int? bcBL, int serviceVoltage) {
    if (floorArea == null || bcSAL == null || bcLL == null || bcBL == null) {
      return SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'Load Calculation Results',
              style: TextStyle(fontSize: 15.0),
            )
          ],
        ),
        titlePadding:
            const EdgeInsets.symmetric(vertical: 24.0, horizontal: 5.0),
        contentPadding: const EdgeInsets.fromLTRB(5.0, 12.0, 0.0, 16.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        children: const <Widget>[Text('One or more inputs are invalid!')],
      );
    } else {
      double tncl = Calc.getTotalNetComputedLoad(floorArea, bcSAL, bcLL, bcBL);
      double iflc = Calc.getIFLC(tncl, serviceVoltage);

      return SimpleDialog(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
            Text(
              'Load Calculation Results',
              style: TextStyle(fontSize: 15.0),
            )
          ]),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 5.0, vertical: 24.0),
          contentPadding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          insetPadding: const EdgeInsets.only(left: 40, right: 40),
          children: <Widget>[
            Column(
              children: <Widget>[
                const Text(
                  "Your Total Net Computed Load is:",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "$tncl VA",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Your Full Load Current is:",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "$iflc VA",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(
                  height: 50.0,
                  thickness: 2.0,
                  indent: 10.0,
                  endIndent: 10.0,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    const Text(
                      'Safety Factor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        onChanged: (String value) {
                          double? val = double.tryParse(value);
                          if (val != null) {
                            setState(() {
                              _safetyFactorValid = true;
                              _safetyFactor = 1 + (val / 100);
                            });
                          } else {
                            setState(() {
                              _safetyFactorValid = false;
                              _safetyFactor = val;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          suffixText: "%",
                            errorText: _safetyFactorValid
                                ? null
                                : 'Must be an integer'),

                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_safetyFactor != null) {
                        double adjustedIFLC =
                            Calc.getAdjustedIFLC(iflc, _safetyFactor!);
                        double minDistanceForWire = 1e18;
                        double minDistanceForITB = 1e18;
                        double wireSize = 0;
                        int itb = 0;

                        Invariants.iflcToRecommendedSizeOfWires
                            .forEach((key, value) {
                          double distance = (adjustedIFLC - key).abs();
                          if (distance <= minDistanceForWire) {
                            minDistanceForWire = distance;
                            wireSize = value;
                          }
                        });

                        double inverseTB = tncl / serviceVoltage;
                        for (var element in Invariants.mainProtectiveDevice) {
                          double distance = (inverseTB - element).abs();
                          if (distance <= minDistanceForITB) {
                            minDistanceForITB = distance;
                            itb = element;
                          }
                        }

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Recommend(wireSize: wireSize, itb: itb);
                            });
                      }
                    },
                    child: const Text("Show Recommendations"))
              ],
            )
          ]);
    }
  }
}

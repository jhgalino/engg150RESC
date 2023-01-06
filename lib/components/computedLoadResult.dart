import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:resc/calculations/calc.dart';
import 'package:resc/components/recommendations.dart';

import '../invariants/invariants.dart';

class CalcResult extends StatefulWidget {
  final double? floorArea;
  final int? bcSAL;
  final int? bcLL;
  final int? bcBL;
  final int serviceVoltage;

  const CalcResult(
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
  bool _safetyFactorValid = false;

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
        children: const <Widget>[
          Text(
            'One or more inputs are invalid!',
            textAlign: TextAlign.center,
          )
        ],
      );
    } else {
      double tncl = Calc.getTotalNetComputedLoad(floorArea, bcSAL, bcLL, bcBL);
      double iflc = Calc.getIFLC(tncl, serviceVoltage);
      double glrcl = Calc.getGLRCL(floorArea);
      double tSAL = Calc.getTotalSmallApplianceLoad(bcSAL);
      double tLL = Calc.getTotalLaundryLoad(bcLL);
      double tBL = Calc.getTotalBathroomLoad(bcBL);

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
                resultRow(
                    "General Lighting and Convenience Receptacle Load", glrcl),
                resultSpace(),
                resultRow("Small Appliance Load", tSAL),
                resultSpace(),
                resultRow("Laundry Load", tLL),
                resultSpace(),
                resultRow("Bathroom Load", tBL),
                resultSpace(),
                resultRow("Subtotal", glrcl + tSAL + tLL + tBL),
                const SizedBox(
                  height: 5,
                ),
                resultRow("Subtotal with Demand Factor",
                    Calc.getTotalWithDemandFactor(glrcl + tSAL + tLL + tBL)),
                resultSpace(),
                resultRow("Total Net Computed Load", tncl,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                resultRow("Full Load Current", iflc,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      width: 150,
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
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                    onPressed: () {
                      FlutterClipboard.copy(
                          "General Lighting and Convenience Receptacle Load: $glrcl\n"
                          "Small Appliance Load: $tSAL\n"
                          "Laundry Load: $tLL\n"
                          "Bathroom Load: $tBL\n"
                          "Subtotal: ${glrcl + tSAL + tLL + tBL}\n"
                          "Subtotal with Demand Factor: ${Calc.getTotalWithDemandFactor(glrcl + tSAL + tLL + tBL)}\n"
                          "Total Net Computed Load: $tncl\n"
                          "Full Load Current: $iflc");

                      showToast("Copied to clipboard", context: context);
                    },
                    child: const Text("Copy to Clipboard")),
                showRecommendationsButton(
                    iflc: iflc, tncl: tncl, serviceVoltage: serviceVoltage)
              ],
            )
          ]);
    }
  }

  Widget resultRow(String name, double value, {TextStyle? style}) {
    return Row(
      children: [
        Expanded(child: Text(name)),
        Spacer(),
        Text(
          "$value VA",
          style: style,
        ),
      ],
    );
  }

  Widget resultSpace() {
    return SizedBox(
      height: Invariants.verticalSpacing,
    );
  }

  Widget showRecommendationsButton(
      {required double iflc,
      required double tncl,
      required int serviceVoltage}) {
    return ElevatedButton(
        onPressed: () {
          if (_safetyFactor != null) {
            double adjustedIFLC = Calc.getAdjustedIFLC(iflc, _safetyFactor!);
            double minDistanceForWire = 1e18;
            double minDistanceForITB = 1e18;
            double wireSize = 0;
            int itb = 0;

            Invariants.iflcToRecommendedSizeOfWires.forEach((key, value) {
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
          } else {

          }
        },
        child: const Text("Show Recommendations"));
  }
}

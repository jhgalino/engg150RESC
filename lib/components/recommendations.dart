import 'package:flutter/material.dart';
import 'package:resc/invariants/invariants.dart';

class Recommend extends StatelessWidget {
  final double wireSize;
  final int itb;

  Recommend({required this.wireSize, required this.itb, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'Recommendations',
            style: TextStyle(fontSize: 15.0),
          )
        ],
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 5.0),
      contentPadding: const EdgeInsets.fromLTRB(5.0, 12.0, 0.0, 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      insetPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
      children: <Widget>[
        Column(
          children: [
            Row(
              children: [
                const Text("Recommended Feeder Size: "),
                const Spacer(),
                Text("$wireSize sq mm")
              ],
            ),
            SizedBox(
              height: Invariants.verticalSpacing,
            ),
            Row(
              children: [
                const Text("Recommended Protective Device: "),
                const Spacer(),
                Expanded(child: Text("$itb AT Circuit Breaker"))
              ],
            )
          ],
        )
      ],
    );
  }
}

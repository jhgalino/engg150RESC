import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resc/components/computedLoadResult.dart';
import 'package:resc/invariants/invariants.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RESC',
      theme: ThemeData(
        primarySwatch: Invariants.navBarColor,
      ),
      home: const MyHomePage(title: 'RESC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _serviceVoltage = 230;
  double? _totalFloorArea;
  int? _smallApplianceLoad;
  int? _laundryLoad;
  int? _bathroomLoad;

  bool _floorAreaValid = true,
      _salValid = true,
      _llValid = true,
      _blValid = true;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          children: <Widget>[
            Icon(
              Icons.lightbulb_rounded,
              color: Invariants.yellow,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RESC'),
                Text(
                  'Residential Electrical Service Calculator',
                  style: TextStyle(fontSize: Invariants.fontSizeSmall),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          // TODO: Add onSelected function
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(child: Text('Reset Form')),
              const PopupMenuItem(
                child: Text('About RESC'),
              )
            ],
            icon: const Icon(Icons.menu),
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                children: <Widget>[
                  Row(
                    children: [
                      const Text(
                        'Service Voltage',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: Invariants.formWidth,
                        child: DropdownButton(
                          items: const <DropdownMenuItem<int>>[
                            DropdownMenuItem(value: 230, child: Text('230V')),
                            DropdownMenuItem(value: 208, child: Text('208V')),
                            DropdownMenuItem(value: 200, child: Text('200V')),
                            DropdownMenuItem(value: 115, child: Text('115V'))
                          ],
                          onChanged: (int? value) {
                            setState(() {
                              _serviceVoltage = value!;
                            });
                          },
                          value: _serviceVoltage,
                          isExpanded: true,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Invariants.verticalSpacing,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Flexible(
                        flex: 3,
                        child: Text(
                          'General Lighting and Convenience Receptacle Load',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      )
                      // SizedBox(child: Text('General Lighting and Convenience Receptacle Load'),)
                    ],
                  ),
                  // TODO: Add validation
                  Row(
                    children: [
                      const Text(
                        'Total Floor Area (in m\u00B2)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: Invariants.formWidth,
                        child: TextField(
                          onChanged: (String value) {
                            double? val = double.tryParse(value);
                            if (val == null) {
                              setState(() {
                                _floorAreaValid = false;
                                _totalFloorArea = val;
                              });
                            } else {
                              setState(() {
                                _floorAreaValid = true;
                                _totalFloorArea = val;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            suffixText: "m\u00B2",
                              errorText: _floorAreaValid
                                  ? null
                                  : 'Must be an integer'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Invariants.verticalSpacing,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Flexible(
                        flex: 3,
                        child: Text(
                          'Small Appliance Load',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Number of Branch Circuits',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: Invariants.formWidth,
                        child: TextField(
                          onChanged: (String value) {
                            int? val = int.tryParse(value);
                            if (val == null) {
                              setState(() {
                                _salValid = false;
                                _smallApplianceLoad = val;
                              });
                            } else {
                              setState(() {
                                _salValid = true;
                                _smallApplianceLoad = val;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              errorText: _salValid
                                  ? null
                                  : 'Small Appliance Load must be an integer'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Invariants.verticalSpacing,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Flexible(
                        flex: 3,
                        child: Text(
                          'Laundry Load',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Number of Branch Circuits',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: Invariants.formWidth,
                        child: TextField(
                          onChanged: (String value) {
                            int? val = int.tryParse(value);
                            if (val == null) {
                              setState(() {
                                _llValid = false;
                                _laundryLoad = val;
                              });
                            } else {
                              setState(() {
                                _llValid = true;
                                _laundryLoad = val;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              errorText: _llValid
                                  ? null
                                  : 'Laundry Load must be an integer'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Invariants.verticalSpacing,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Flexible(
                        flex: 3,
                        child: Text(
                          'Bathroom Load',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Number of Branch Circuits',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: Invariants.formWidth,
                        child: TextField(
                          onChanged: (String value) {
                            int? val = int.tryParse(value);
                            if (val == null) {
                              setState(() {
                                _blValid = false;
                                _bathroomLoad = val;
                              });
                            } else {
                              setState(() {
                                _blValid = true;
                                _bathroomLoad = val;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              errorText: _blValid
                                  ? null
                                  : 'Bathroom Load must be an integer'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Invariants.verticalSpacing,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CalcResult(
                                    floorArea: _totalFloorArea,
                                    bcSAL: _smallApplianceLoad,
                                    bcLL: _laundryLoad,
                                    bcBL: _bathroomLoad,
                                    serviceVoltage: _serviceVoltage,
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Invariants.yellow,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0))),
                          child: Text(
                            'SOLVE',
                            style:
                                TextStyle(fontSize: Invariants.fontSizeMedium),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

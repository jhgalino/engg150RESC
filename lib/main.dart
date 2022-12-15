import 'package:flutter/material.dart';

void main() {
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'RESC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _serviceVoltage = 230;
  int? _totalFloorArea;
  int? _smallApplianceLoad;
  int? _laundryLoad;
  int? _bathroomLoad;

  bool _floorAreaValid = true,
      _salValid = true,
      _llValid = true,
      _blValid = true;

  // This widget shows the computed values
  Widget computedDialog(int? floorArea, int? bcSAL, int? bcLL, int? bcBL) {
    if (floorArea == null || bcSAL == null || bcLL == null || bcBL == null) {
      return const SimpleDialog(
        title: Center(
          child: Text('Load Calculation Results'),
        ),
        children: <Widget>[Text('One or more inputs are invalid!')],
      );
    } else {
      int glrcl = floorArea * 24;
      int tSAL = bcSAL * 1500;
      int tLL = bcLL * 1500;
      int tBL = bcBL * 1500;
      int TOT = glrcl + tSAL + tLL + tBL;
      double ntl;

      if (TOT >= 3000) {
        ntl = 3000 + (TOT - 3000) * 0.35;
      } else {
        ntl = 3000 + (120000 - 3000) * 0.35 + (TOT - 120000) * 0.25;
      }

      ntl = ntl.roundToDouble();

      return SimpleDialog(
        title: const Center(
          child: Text('Load Calculation Results'),
        ),
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                        'General Lighting and Convenience Receptacle Load: $glrcl'),
                  )
                ],
              ),
              Row(
                children: [Text('Total Small Appliance Load: $tSAL')],
              ),
              Row(
                children: [
                  Text('Total Laundry Load: $tLL'),
                ],
              ),
              Row(children: [Text('Total Bathroom Load: $tBL')]),
              Row(
                children: [Text('Net Total Load: $ntl')],
              )
            ],
          )
        ],
      );
    }
  }

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
        title: Text(widget.title),
        actions: <Widget>[
          // TODO: Add onSelected function
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                  child: Text('Reset Form')),
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
                      const Text('Service Voltage'),
                      const Spacer(),
                      SizedBox(
                        width: 200,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('General Lighting and Convenience Receptacle Load')
                    ],
                  ),
                  // TODO: Add validation
                  Row(
                    children: [
                      const Text('Total Floor Area (m\u00B2)'),
                      const Spacer(),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          onChanged: (String value) {
                            int? val = int.tryParse(value);
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
                              errorText: _floorAreaValid
                                  ? null
                                  : 'Floor area must be an integer'),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[Text('Small Appliance Load')],
                  ),
                  Row(
                    children: [
                      const Text('Number of Branch Circuit'),
                      const Spacer(),
                      SizedBox(
                        width: 180,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[Text('Laundry Load')],
                  ),
                  Row(
                    children: [
                      const Text('Number of Branch Circuits'),
                      const Spacer(),
                      SizedBox(
                        width: 180,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[Text('Bathroom Load')],
                  ),
                  Row(
                    children: [
                      const Text('Number of Branch Circuits'),
                      const Spacer(),
                      SizedBox(
                        width: 180,
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return computedDialog(_totalFloorArea, _smallApplianceLoad,
                    _laundryLoad, _bathroomLoad);
              });
        },
        backgroundColor: Colors.green,
        child: const Text('Solve'),
      ),
    );
  }
}

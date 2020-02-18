import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transport_data.dart';

class TransportScreen extends StatefulWidget {
  @override
  _TransportScreenState createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transportData = Provider.of<TransportData>(context, listen: false);
      transportData
          .updateAllWidgets();
    });
  }

  @override
  void deactivate() {
    final transportData = Provider.of<TransportData>(context, listen: false);
    transportData.routeAndStationWidgetController.close();
    transportData.displayWidgetController.close();
    transportData.statusIndicatorWidgetController.close();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final transportData = Provider.of<TransportData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('交通概況'),
        actions: <Widget>[
          StreamBuilder<Widget>(
                stream: transportData.statusIndicatorWidgetController.stream,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else if (snapshot.hasError) {
                    return Text('snapshot Error');
                  } else {
                    return Container();
                  }
                },
              ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 15.0),
              TypeMenu(),
              SizedBox(width: 15.0),
              StreamBuilder<Widget>(
                stream: transportData.routeAndStationWidgetController.stream,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else if (snapshot.hasError) {
                    return Text('snapshot Error');
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<Widget>(
              stream: transportData.displayWidgetController.stream,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else if (snapshot.hasError) {
                  return Text('snapshot Error');
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.swap_horiz),
        backgroundColor: Colors.brown,
        onPressed: () {
          transportData.switchDirection();
        },
      ),
    );
  }
}

class TypeMenu extends StatefulWidget {
  @override
  _TypeMenuState createState() => _TypeMenuState();
}

class _TypeMenuState extends State<TypeMenu> {
  @override
  Widget build(BuildContext context) {
    final transportData = Provider.of<TransportData>(context, listen: false);
    return DropdownButton<int>(
      value: transportData.getSelectedTransport,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.amber,
      ),
      onChanged: (int newValue) {
        setState(() {
          transportData.updateAllWidgets(selectedTransport: newValue);
        });
      },
      itemHeight: 85.0,
      items: transportData.type.map((type) {
        return DropdownMenuItem<int>(
          value: type[0],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(type[1], style: TextStyle(fontSize: 18.0)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

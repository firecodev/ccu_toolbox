import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/transport_screen.dart';
import './providers/transport_data.dart';

class TransportMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TransportData>(create: (_) => TransportData()),
      ],
      child: TransportScreen(),
    );
  }
}

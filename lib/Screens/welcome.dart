import 'package:flutter/material.dart';

import 'Components/body.dart';

class Welcome extends StatelessWidget {

  static const String id="Welcome";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),

    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  fetchData() async {
    final url = "https://api-firebase-try.firebaseapp.com/quotes";
    var res = await http.get(url);
    return jsonDecode(res.body)["headers"];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Offstage();
            }
            return "Nothing Found".text.makeCentered();
          }
          else if (snapshot.connectionState == ConnectionState.none) {
            return "Connection not made".text.makeCentered();
          }
          return CircularProgressIndicator().centered();
        },
      ),
    );
  }
}

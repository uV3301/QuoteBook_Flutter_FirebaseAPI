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
  final color = Colors.teal;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return StatefulBuilder(
                builder:(context, setState){
                               return VxSwiper(  
                  scrollDirection: Axis.vertical,
                  height: context.screenHeight,
                  viewportFraction: 1.0,
                  items: snapshot.data.map<Widget>(
                    (el)=> VStack(
                      [
                        "Quotes".text.xl2.white.makeCentered(),
                        "${el["quoteText"]}".text.xl2.italic.white.make().box.shadowMd.make(),
                        IconButton(iconSize: 30,icon: Icon(Icons.share, color: Colors.white,),onPressed: null,),
                        
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                      alignment: MainAxisAlignment.spaceAround,
                      )
                    .animatedBox
                    .p16
                    .color(color)
                    .make()
                    .h(context.screenHeight)
                  ).toList()
                ); }
              );
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

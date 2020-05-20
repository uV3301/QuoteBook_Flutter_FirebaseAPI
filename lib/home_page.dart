import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
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
    final colors = [
    Vx.green600, Vx.teal600, Vx.blue600, Vx.red500, Vx.yellow600, Vx.pink600, Vx.indigo600
    ];
    return Material(
      child: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return StatefulBuilder(
                builder:(context, setState){
                  final color = colors[Random().nextInt(7)];
                               return VxSwiper(  
                  scrollDirection: Axis.vertical,
                  height: context.screenHeight,
                  viewportFraction: 1.0,
                  onPageChanged: (index) {
                    setState((){});
                  },
                  items: snapshot.data.map<Widget>(
                    (el)=> VStack(
                      [
                        "Quotes".text.xl3.white.bold.makeCentered(),
                        "${el["quoteText"]}".text.xl2.italic.white.make().box.shadowXl.make().p20(),
                        "- ${el["quoteAuthor"]}".text.xl.white.make(),
                        IconButton(focusColor: color,iconSize: 30,icon: Icon(Icons.share, color: Colors.white,),onPressed: () {
                          Share.share("${el["quoteText"]}");
                        },),
                        
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                      alignment: MainAxisAlignment.spaceEvenly,
                      )
                    .animatedBox
                    .p20
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

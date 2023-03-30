import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  


class OwnedWordsPage extends StatefulWidget {

  const OwnedWordsPage({Key? key}) : super(key: key);
 
  @override
  State<OwnedWordsPage> createState() => _OwnedWordsPageState();
}
 
class _OwnedWordsPageState extends State<OwnedWordsPage> {

  TextEditingController pseudoName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 400,
      height: 100,
      
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 227, 227, 144),
              border: Border.all(
              color: Colors.black,
              width: 1,
              ),
              borderRadius: const BorderRadius.all(
                      Radius.circular(10),),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text("Matheo"),
                Spacer(flex: 1,),
                Text("#12",  style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height:100),
                Text("Contenue du petit mot écris \n par Matheo"),

              ],
            ),
          ),
          /*Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text("Contenue du petit mot écris \n par Matheo"),
              ],
            ),
          ),*/

        ],
      ),
    );
    /*
    return Padding(

      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            children :<Widget>[
              Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: 
                const TextField(
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Matheo',
                    border: InputBorder.none,
                  ),
                ),
              
            ),
          ]
          ),
        ]
      ),
    );*/
  }
}
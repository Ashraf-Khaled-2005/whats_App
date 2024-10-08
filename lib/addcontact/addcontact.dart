import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:untitled1/addcontact/chats.dart';

class Addcontact extends StatelessWidget {
  Addcontact({super.key});
  List New =[{
  "image": "https://cdn.stocksnap.io/img-thumbs/960w/mountains-clouds_A4Y2Q66EL4.jpg",
  "name": "New group",
},{
"image": "https://cdn.create.vista.com/api/media/small/8099055/stock-photo-autumnal-natural-background",
"name": "New contact",
},{
"image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiYdLgEeNF0dmf4tC2me4zMZpEQBVJwyv6ta6T1qgsrg&s",
"name": "New comuntiy",
}
];List chats =[{
    "image": "https://cdn.stocksnap.io/img-thumbs/960w/mountains-clouds_A4Y2Q66EL4.jpg",
    "name": "(you)"
  },{
    "image": "https://cdn.create.vista.com/api/media/small/8099055/stock-photo-autumnal-natural-background",
    "name": "01256374527"
  },{
    "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiYdLgEeNF0dmf4tC2me4zMZpEQBVJwyv6ta6T1qgsrg&s",
    "name": "012e6364263"
  }
  ];
@override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Row(
                children: [
                  IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen())),
                      icon: Icon(Icons.arrow_back),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Select contact',style: TextStyle(fontSize: 13),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 300),
                    child: Icon(Icons.search),
                  ),

                ],
              ),SizedBox(height: 30),
          Container(
            height: 150,
            child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context,i){
                  return ListTile(
                    title: Text(New[i]['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                     leading: AdvancedAvatar(
                      image: NetworkImage(New[i]['image']),
                      foregroundDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      size: 30,
                    ),
                  );
                },
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            height: 30,
            width: double.infinity,
            child: Text("Contacts on whatsApp",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    )),
          ),
          Container(
            height: 300,
            child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context,i){
                  return ListTile(
                    title: Text(chats[i]['name']),
                    leading: AdvancedAvatar(
                      image: NetworkImage(chats[i]['image']),
                      foregroundDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      size: 30,
                    ),
                  );
                }),
          ),

        ],
      ),

      );
  }
}

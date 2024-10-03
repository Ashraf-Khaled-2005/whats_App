import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:statuspart/status/addstory.dart';
import 'package:statuspart/status/liststatus.dart';
import 'package:statuspart/status/storyview.dart';

class status extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(leading: Icon(Icons.search),title: Text('Status',style: TextStyle(color: Colors.white),),backgroundColor: Color(0xff075e54)),
      body: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            elevation: 0.0,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>Addstory())),
                leading: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          "https://www.shutterstock.com/image-vector/person-icon-260nw-282598823.jpg"),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 1.0,
                      child: Container(
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
                title: Text(
                  "My Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Tap to add status update"),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            height: 30,
            color: Color(0xffe8eae9),
            width: double.infinity,
            child: Text("Recent Updates",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff075e54))),
          ),
          Container(
            height: height*0.69,
            child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context,i){
                  return ListTile(
                    onTap: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>StoryPageView())),
                    title: Text(chats[i]['name']),
                    subtitle: Text(chats[i]['time']),
                    leading: AdvancedAvatar(
                      image: NetworkImage(chats[i]['image']),
                      foregroundDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue,width: 3),
                      ),
                      size: 45,
                    ),
                  );
                }),
          ),


        ],
      ),

    );
  }
}
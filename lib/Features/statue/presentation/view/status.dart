import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/GetUserDataCubit/get_user_data_cubit.dart';
import 'package:our_whatsapp/Features/statue/data/model/statusModel.dart';
import 'package:our_whatsapp/Features/statue/presentation/view/widget/Show_my_stories.dart';
import 'widget/addstory.dart';
import 'widget/storyview.dart';

class status extends StatefulWidget {
  const status({super.key});

  @override
  State<status> createState() => _statusState();
}

class _statusState extends State<status> {
  List<StatueModel>? curstories;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Addstory(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
          )),
      appBar: AppBar(
          leading: const Icon(Icons.search),
          title: const Text(
            'Status',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff075e54)),
      body: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () async {
                  if (curstories?.isEmpty ?? true) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Addstory(),
                      ),
                    );
                  } else {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowMyStories(
                          list: curstories!,
                        ),
                      ),
                    );
                  }
                },
                leading: Stack(
                  children: <Widget>[
                    const CircleAvatar(
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
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    )
                  ],
                ),
                title: const Text(
                  "My Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Tap to Show Your status "),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            height: 30,
            color: const Color(0xffe8eae9),
            width: double.infinity,
            child: const Text("Recent Updates",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff075e54))),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Stories')
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading messages.'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No stories yet.'));
              }

              var myuser = context.read<GetUserDataCubit>().userData;
              Map<String, List<StatueModel>> userStoriesMap = {};

              for (var item in snapshot.data!.docs) {
                var data = item.data();
                if (myuser.ids?.contains(data['userid']) ?? false) {
                  StatueModel story = StatueModel.formJson(data);

                  if (userStoriesMap.containsKey(data['userid'])) {
                    userStoriesMap[data['userid']]!.add(story);
                  } else {
                    userStoriesMap[data['userid']] = [story];
                  }
                } else if (myuser.id == data['userid']) {
                  StatueModel story = StatueModel.formJson(data);

                  if (userStoriesMap.containsKey(myuser.id)) {
                    userStoriesMap[data['userid']]!.add(story);
                  } else {
                    userStoriesMap[data['userid']] = [story];
                  }
                }
              }

              userStoriesMap.forEach((userId, stories) {
                stories.sort((a, b) => b.time.compareTo(a.time));
              });
              curstories = userStoriesMap[myuser.id] ?? [];

              return Expanded(
                child: ListView.builder(
                  itemCount: userStoriesMap.keys.length,
                  itemBuilder: (context, index) {
                    String userId = userStoriesMap.keys.elementAt(index);
                    List<StatueModel> userStories = userStoriesMap[userId]!;

                    StatueModel firstStory = userStories.first;

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StoryPageView(userStories: userStories),
                          ),
                        );
                      },
                      title: Text(firstStory.username),
                      subtitle: userId == myuser.id
                          ? const Text("(YOU)")
                          : Text(
                              'Tap to view all ${userStories.length} stories'),
                      leading: AdvancedAvatar(
                        image: NetworkImage(firstStory.userimage),
                        foregroundDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 3),
                        ),
                        size: 45,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

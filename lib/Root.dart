import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/GetUserDataCubit/get_user_data_cubit.dart';
import 'package:our_whatsapp/Features/Chats/presentation/view/Chat.dart';

import 'Features/status/status.dart';

class RootPage extends StatefulWidget {
  final MyUserData user;
  const RootPage({super.key, required this.user});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentpage = 0;
  late PageController controller;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentpage);
    controller.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    int newPage = controller.page!.round();
    if (currentpage != newPage) {
      setState(() {
        currentpage = newPage;
      });
    }
  }

  @override
  void dispose() {
    controller.removeListener(_handlePageChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [ChatScreen(user: widget.user), status()];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        animationDuration: Duration(milliseconds: 300),
        selectedIndex: currentpage,
        onDestinationSelected: (value) {
          setState(() {
            currentpage = value;
            controller.animateToPage(currentpage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceIn);
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.star_outline), label: "Statue"),
        ],
      ),
      body: PageView(
        controller: controller,
        children: pages,
      ),
    );
  }
}

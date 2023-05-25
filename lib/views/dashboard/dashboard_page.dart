import 'package:flutter/material.dart';
import 'package:todo_app/shared/app_color.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/views/authentication/login_page.dart';
import 'package:todo_app/views/todo/add_update_todo_page.dart';
import 'package:todo_app/views/todo/todo_list_page.dart';

import '../../service/auth_service.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(children: [
            DrawerHeader(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(
                        AuthService.instance.user?.photoURL ?? '')),
                Text(AuthService.instance.user?.displayName ?? ''),
                Text(AuthService.instance.user?.email ?? ''),
              ],
            )),
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppColor.red.withOpacity(0.3)),
                onPressed: _handleSignOutEvent,
                child: const Text("Sign out"))
          ]),
        ),
        appBar: AppBar(
            // title: const Text("Dashboard"),
            ),
        body: const ToDoListPage(),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add note",
          child: const Icon(
            Icons.add,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddUpdateToDoPage()));
          },
        ));
  }

  _handleSignOutEvent() async {
    try {
      await AuthService.instance.signOut();
      AuthService.instance.userLoginState.listen((event) {
        if (event == null) {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false);
        }
      });
    } catch (e) {
      Utils.showSnackBar(context, text: e.toString());
    }
  }
}

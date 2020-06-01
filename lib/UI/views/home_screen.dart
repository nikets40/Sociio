import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/pages/call_page.dart';
import 'package:nixmessenger/UI/pages/chats_page.dart';
import 'package:nixmessenger/UI/pages/contacts_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String tabTitle = "Chats";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(
        length: bottomTabs().length, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      setState(() {
        switch (tabController.index) {
          case 0:
            tabTitle = "Chats";
            break;
          case 1:
            tabTitle = "Calls";
            break;
          case 2:
            tabTitle = "Contacts";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Text(
              tabTitle,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.more_vert),onPressed: (){},)],

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: fabIcon(),
      ),
      body: Container(
        child: TabBarView(
          controller: tabController,
          children: [ChatsPage(), CallPage(), ContactsPage()],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
              color: Colors.black,
              child: TabBar(
                controller: tabController,
                indicatorColor: Colors.transparent,
                tabs: bottomTabs(),
                unselectedLabelColor: Colors.white54,
                labelColor: Colors.green,
              ))),
    );
  }

  bottomTabs() {
    List<Tab> items = List<Tab>();
    items.add(Tab(
      icon: Icon(
        Icons.message,
        size: 30,
      ),
      text: "Chats",
    ));
    items.add(Tab(icon: Icon(Icons.call, size: 30), text: ("Calls")));
    items.add(Tab(icon: Icon(Icons.person, size: 30), text: ("Contacts")));
    return items;
  }

  fabIcon() {
    switch (tabController.index) {
      case 0:
        return Icon(
          Icons.edit,
          color: Colors.white,
        );
      case 1:
        return Icon(
          Icons.add_call,
          color: Colors.white,
        );
      case 2:
        return Icon(
          Icons.person_add,
          color: Colors.white,

        );
    }
  }
}

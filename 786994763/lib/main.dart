import 'dart:ui';

import 'package:flutter/material.dart';

import 'add_page_route.dart';
import 'models/page.dart';
import 'styles.dart';
import 'subject_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const ChatJournal(title: 'Chat Journal'),
        EventList.routeName: (context) => EventList(),
        PageInput.routeName: (context) => PageInput(),
      },
    );
  }
}

class ChatJournal extends StatefulWidget {
  const ChatJournal({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ChatJournalState createState() => _ChatJournalState();
}

class _ChatJournalState extends State<ChatJournal> {
  int _selectedIndex = -1;

  final _accentColor = const Color(0xff86BB8B);

  List<PageInfo> _pagesList = [];

  void _addNewPage() async {
    final result = await Navigator.pushNamed(
      context,
      PageInput.routeName,
      arguments: _pagesList,
    ) as List<PageInfo>;
    _pagesList = result;
    setState(() {});
  }

  void _addEvents(int index) async {
    print('kek: $_pagesList[index].title');
    await Navigator.pushNamed(context, EventList.routeName,
        arguments: _pagesList[index]);
    //_pagesList[index] = result;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_pagesList.isEmpty) {
      _pagesList.add(PageInfo(
        'Travel',
        const Icon(Icons.flight_takeoff),
        DateTime.now(),
        DateTime.now(),
      ));
      _pagesList.add(PageInfo(
        'Family',
        const Icon(Icons.chair),
        DateTime.now(),
        DateTime.now(),
      ));
      _pagesList.add(PageInfo(
        'Sports',
        const Icon(Icons.sports_basketball),
        DateTime.now(),
        DateTime.now(),
      ));
    }
    return Scaffold(
      appBar: _homeAppBar,
      body: Column(
        children: [
          _questionaryBot,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: _pagesListView,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      bottomNavigationBar: _bottomNavBar,
      floatingActionButton: _fabAddNewPage,
    );
  }

  AppBar get _homeAppBar {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.amber[50],
        ),
        onPressed: () {},
        tooltip: 'Open Menu',
      ),
      centerTitle: true,
      title: _titleHomePage,
      actions: [
        Container(
          child: IconButton(
            icon: const Icon(
              Icons.dark_mode,
              size: 30,
            ),
            onPressed: () {},
          ),
          padding: const EdgeInsets.only(right: 6),
        )
      ],
    );
  }

  Widget get _titleHomePage {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: widget.title),
          WidgetSpan(
            child: Container(
              child: const Text('🏡'),
              padding: const EdgeInsets.only(left: 8),
            ),
          ),
        ],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.amber[50],
        ),
      ),
    );
  }

  Widget get _questionaryBot {
    return Padding(
      child: Container(
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.85),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: const Text(
              'Questionary Bot',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff49664c),
              ),
            ),
          ),
        ),
        height: 60,
      ),
      padding: const EdgeInsets.only(top: 20, right: 36, left: 36),
    );
  }

  Widget get _pagesListView {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        thickness: 2,
      ),
      itemCount: _pagesList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            void setState() => _selectedIndex = index;
            _addEvents(index);
          },
          selected: index == _selectedIndex,
          contentPadding: const EdgeInsets.only(left: 26),
          trailing: _pagesList[index].eventList.isNotEmpty
              ? Container(
                  child: Text('${_pagesList[index].eventList.last.date.hour}:' +
                      '${_pagesList[index].eventList.last.date.hour}'),
                  padding: const EdgeInsets.only(right: 10),
                )
              : const Text(''),
          title: Text(
            _pagesList[index].title,
            style: categoryTitleStyle,
          ),
          leading: CircleAvatar(
            child: _pagesList[index].icon,
            radius: 28,
          ),
          subtitle: _pagesList[index].eventList.isNotEmpty
              ? Text(
                  _pagesList[index].eventList.last.content,
                  style: categorySubtitleStyle,
                )
              : Text(
                  _pagesList[index].subtitle,
                  style: categorySubtitleStyle,
                ),
        );
      },
    );
  }

  Widget get _fabAddNewPage {
    return FloatingActionButton(
      child: const Icon(
        Icons.add,
        size: 36,
        color: Color(0xff49664c),
      ),
      backgroundColor: _accentColor,
      onPressed: _addNewPage,
    );
  }

  BottomNavigationBar get _bottomNavBar {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            size: 30,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.assignment,
            size: 30,
          ),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map,
            size: 30,
          ),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.explore,
            size: 30,
          ),
          label: 'Explore',
          backgroundColor: Colors.green,
        ),
      ],
    );
  }
}

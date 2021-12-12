import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golden_goose/screens/home.dart';
import 'package:golden_goose/screens/rank.dart';

import 'chart.dart';
import 'my_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List<Widget>? _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Home(),
      Chart(),
      const Rank(),
      const MyPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _pages!.length,
        child: Scaffold(
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: _pages!,
          ),
          bottomNavigationBar: TabBar(
              isScrollable: false,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      width: 5.0, color: Colors.white.withOpacity(0.1)),
                  insets: const EdgeInsets.symmetric(horizontal: 16.0)),
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              tabs: const [
                Tab(
                    height: 40,
                    iconMargin: EdgeInsets.zero,
                    icon: Icon(Icons.home, size: 20),
                    child: Text("home", style: TextStyle(fontSize: 10))),
                Tab(
                    height: 40,
                    iconMargin: EdgeInsets.zero,
                    icon: Icon(Icons.waterfall_chart, size: 20),
                    child: Text("Chart", style: TextStyle(fontSize: 10))),
                Tab(
                    height: 40,
                    iconMargin: EdgeInsets.zero,
                    icon: Icon(FontAwesomeIcons.alignLeft, size: 20),
                    child: Text("Rank", style: TextStyle(fontSize: 10))),
                Tab(
                    height: 40,
                    iconMargin: EdgeInsets.zero,
                    icon: Icon(Icons.person, size: 20),
                    child: Text("My Page", style: TextStyle(fontSize: 10))),
              ]),
        ));
  }
}

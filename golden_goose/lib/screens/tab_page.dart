import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/tab_page_controller.dart';
import 'package:golden_goose/screens/home.dart';

import 'chart.dart';

class TabPage extends StatefulWidget {
  // StatefulWidget

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final TabPageController _tabPageCtrl = Get.put(TabPageController());
  List<Widget>? _pages;

  @override
  void initState() {
    // 생성자 다음에 초기화 호출 부분, 변수 초기화 용도
    // TODO: implement initState
    super.initState();
    _pages = [
      Home(),
      Chart(),
      Text('Manage Page'),
      Text('Test Page'),
    ];
  }

  /*
  @override
  Widget build(BuildContext context) {
    print('tabPage >> build');

    return Obx(()=> Scaffold(
      body: Center(child: _pages![_tabPageCtrl.curPage.toInt()]),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: BottomNavigationBar(
            iconSize: 20,
            selectedFontSize: 10,
            unselectedFontSize: 8,
            //showUnselectedLabels: false,
            backgroundColor: Get.theme.backgroundColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.shifting,
            // This is all you need!
            onTap: _tabPageCtrl.changeCurPage, //_onItemTapped,
            items:[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: ('Home')), // 로그인 사용자 정보 관련
              BottomNavigationBarItem(
                  icon: Icon(Icons.waterfall_chart),
                  label: ('Chart')),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.alignLeft),
                  label: ('Rank')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: ('History')),
            ],
            currentIndex: _tabPageCtrl.curPage.toInt()
        ),
      ),
    ));
  }
  */
  @override
  Widget build(BuildContext context) {
    print('tabPage >> build');
    return DefaultTabController(
        length: _pages!.length,
        child: Scaffold(
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: _pages!,
          ),
          bottomNavigationBar: TabBar(
              isScrollable: false,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      width: 5.0, color: Colors.white.withOpacity(0.1)),
                  insets: EdgeInsets.symmetric(horizontal: 16.0)),
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              tabs: [
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
                    icon: Icon(Icons.history, size: 20),
                    child: Text("History", style: TextStyle(fontSize: 10))),
              ]),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dory/components/dory_colors.dart';
import 'package:dory/components/dory_constants.dart';
import 'package:dory/pages/add_medicine/add_medicine_page.dart';
import 'package:dory/pages/history/history_page.dart';
import 'package:dory/pages/today/today_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = [
    const TodayPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: pagePadding,
        child: SafeArea(child: _pages[_currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMedicine,
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      child: SizedBox(
        height: 80,
        // height: kBottomNavigationBarHeight,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () => _onCurrentPage(0),
                icon: Icon(
                  CupertinoIcons.check_mark,
                  color: _currentIndex == 0
                      ? DoryColors.primaryColor
                      : Colors.grey[350],
                  size: 32,
                )),
            IconButton(
              onPressed: () => _onCurrentPage(1),
              icon: Icon(
                CupertinoIcons.text_badge_checkmark,
                color: _currentIndex == 1
                    ? DoryColors.primaryColor
                    : Colors.grey[350],
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCurrentPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  void _onAddMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicinePage()),
    );
  }
}

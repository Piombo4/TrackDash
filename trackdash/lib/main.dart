import 'package:flutter/material.dart';
import 'package:trackdash/pages/StartActivity.dart';
import 'package:trackdash/utils/CustomNavigationBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  final List<Widget> pages = [
    const Scaffold(
      key: PageStorageKey('Page1'),
    ),
    const StartActivity(
      key: PageStorageKey('Page2'),
    ),
    const Scaffold(
      key: PageStorageKey('Page3'),
    )
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget BottomNavigationBar(int selectedIndex) => CustomBottomNavigation(
        selectedColor: Colors.greenAccent,
        selectedLightColor: Colors.greenAccent,
        itemIcons: [Icons.history, Icons.settings],
        centerIcon: Icons.mode_of_travel,
        selectedIndex: _selectedIndex,
        onItemPressed: _onItemTapped,
      );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

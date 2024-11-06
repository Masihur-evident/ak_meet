import 'package:ak_meet/join_meeting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MeetingDashboardScreen extends StatefulWidget {
  @override
  _MeetingDashboardScreenState createState() => _MeetingDashboardScreenState();
}

class _MeetingDashboardScreenState extends State<MeetingDashboardScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0; // Track selected bottom navigation item
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 4 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hai Evident BD!', style: TextStyle(color: Colors.grey)),
                    Text(
                      'Today Meetings',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 24,

                  child:  Image.asset('assets/meeting_avatar.png'), // Replace with actual image path
                ),
              ],
            ),
            const SizedBox(height: 10,),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.purple,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                _buildTab("On Going", 12),
                _buildTab("Upcoming", 8),
                _buildTab("Ended", 48),

              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMeetingList("On Going"),
                  _buildMeetingList("Upcoming"),
                  _buildMeetingList("Ended"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTab(String title, int count) {
    return Tab(
      child: Chip(
        backgroundColor: Colors.purple,
        label: Text(
          '$title $count',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMeetingList(String status) {
    return ListView(
      children: [
        _buildMeetingCard("Attendance Keeper Team", "17 Jul 2023", "21:00 PM - 21:30 PM", 3),
        _buildMeetingCard("MYE Team", "17 Jul 2023", "21:00 PM - 21:30 PM", 5),
        _buildMeetingCard("IK Team", "17 Jul 2023", "21:00 PM - 21:30 PM", 2),
      ],
    );
  }

  Widget _buildMeetingCard(String title, String date, String time, int participantsCount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Starts in 7h 25m",
                    style: TextStyle(color: Colors.purple, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "$date  |  $time",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: List.generate(
                    participantsCount,
                        (index) =>  CircleAvatar(
                      radius: 12,

                          child:  Image.asset('assets/meeting_avatar.png'),// Replace with actual image path
                    ),
                  ),
                ),
                SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.join_left, color: Colors.purple, size: 36),
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (_)=> JoinMeetingScreen(meetingName: title,)));

                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
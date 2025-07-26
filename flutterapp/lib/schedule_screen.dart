import 'package:flutter/material.dart';
import 'notifications_screen.dart';
import 'widgets/profile_switch_button.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
   appBar: PreferredSize(
  preferredSize: Size.fromHeight(0),
  child: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
),

      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          children: [
            // Icons row above Schedule
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.access_time, size: 30, color: Colors.black),
                const SizedBox(width: 16),
                const ProfileSwitchButton(),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                  child: Icon(Icons.notifications_none, size: 30, color: Colors.black),
                ),
              ],
            ),
            // Schedule title
            Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            const SizedBox(height: 24),
            // Today + date in one line
            Row(
              children: [
                Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 8),
                Text('July 23', style: TextStyle(color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.normal)),
              ],
            ),
            const SizedBox(height: 16),
            _NoClassCard(),
            const SizedBox(height: 32),
            Row(
              children: [
                Text('Wednesday', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 8),
                Text('July 25', style: TextStyle(color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.normal)),
              ],
            ),
            const SizedBox(height: 16),
            _ScheduleCard(),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Event from Debate Club', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Row(
                      
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 18),
              const SizedBox(width: 6),
              Text('July 23', style: TextStyle(fontSize: 15)),
              const SizedBox(width: 16),
              Icon(Icons.access_time, color: Colors.blue, size: 18),
              const SizedBox(width: 4),
              Text('10:00', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(width: 4),
              Text('60 min', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 24, color: Colors.grey[200]),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '"Debate Club" — a club meeting to discuss current topics, develop argumentation skills and public speaking.',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoClassCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.self_improvement, color: Colors.blue[300], size: 90),
          const SizedBox(height: 16),
          Text(
            "You haven't booked an event for today",
            style: TextStyle(color: Colors.grey[400], fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
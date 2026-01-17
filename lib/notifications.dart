import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: const [
                _FilterPill(label: 'All', selected: true),
                SizedBox(width: 8),
                _FilterPill(label: 'Unread'),
              ],
            ),
            const SizedBox(height: 12),
            ..._mockNotifications.map((item) => _NotificationTile(item: item)),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterPill({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected ? Colors.blue : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.blue : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String timeAgo;
  final bool unread;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.unread = false,
  });
}

const List<_NotificationItem> _mockNotifications = [
  _NotificationItem(
    icon: Icons.group,
    iconColor: Colors.blue,
    title: 'New group invite',
    subtitle: 'Alex invited you to join Flutter Devs',
    timeAgo: '2h ago',
    unread: true,
  ),
  _NotificationItem(
    icon: Icons.thumb_up,
    iconColor: Colors.indigo,
    title: 'Someone liked your post',
    subtitle: 'Maria and 4 others liked your photo',
    timeAgo: '5h ago',
  ),
  _NotificationItem(
    icon: Icons.comment,
    iconColor: Colors.green,
    title: 'New comment',
    subtitle: 'David commented: “Great shot!”',
    timeAgo: '1d ago',
  ),
  _NotificationItem(
    icon: Icons.event,
    iconColor: Colors.orange,
    title: 'Upcoming event',
    subtitle: 'Reminder: Hackathon starts tomorrow',
    timeAgo: '2d ago',
  ),
];

class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.unread ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: item.iconColor.withOpacity(0.12),
            child: Icon(item.icon, color: item.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      item.timeAgo,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          if (item.unread)
            Container(
              margin: const EdgeInsets.only(left: 8, top: 4),
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

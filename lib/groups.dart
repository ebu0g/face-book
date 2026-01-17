import 'package:flutter/material.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Groups',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _searchField(),
            const SizedBox(height: 12),
            _chipRow(),
            const SizedBox(height: 16),
            const Text(
              'Suggested for you',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ..._mockGroups.map((g) => _GroupCard(group: g)),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search groups',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _chipRow() {
    final chips = ['For you', 'Local', 'Tech', 'Buy & Sell'];
    return Wrap(
      spacing: 8,
      children: chips
          .map(
            (c) => Chip(
              label: Text(c),
              backgroundColor:
                  c == 'For you' ? Colors.blue.shade50 : Colors.white,
              labelStyle: TextStyle(
                color: c == 'For you' ? Colors.blue : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              shape: StadiumBorder(
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Group {
  final String name;
  final String members;
  final String description;
  final bool joined;

  const _Group({
    required this.name,
    required this.members,
    required this.description,
    this.joined = false,
  });
}

const List<_Group> _mockGroups = [
  _Group(
    name: 'Flutter Devs',
    members: '120k members · 300 posts/day',
    description: 'Share tips, packages, and show your apps.',
  ),
  _Group(
    name: 'UI/UX Inspiration',
    members: '85k members · 120 posts/day',
    description: 'Daily design drops, critiques, and challenges.',
    joined: true,
  ),
  _Group(
    name: 'Local Marketplace',
    members: '54k members · 210 posts/day',
    description: 'Buy, sell, and trade safely with the community.',
  ),
];

class _GroupCard extends StatelessWidget {
  final _Group group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.blueGrey.shade200,
            ),
            child: const Center(
              child: Text(
                'Cover Image',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  group.members,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Text(
                  group.description,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              group.joined ? Colors.grey.shade200 : Colors.blue,
                          foregroundColor:
                              group.joined ? Colors.black87 : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size.fromHeight(40),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {},
                        child: Text(group.joined ? 'Joined' : 'Join Group'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size.fromHeight(40),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {},
                        child: const Text('Preview'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

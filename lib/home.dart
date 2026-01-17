import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: const Text(
          'facebook',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.blue, fontSize: 20),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.message_outlined)),
        ],
      ),
      body: Column(
        children: [
          // Top navigation row
          Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  color: Colors.blue,
                  icon: const Icon(Icons.home),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  color: Colors.black,
                  icon: const Icon(Icons.ondemand_video),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/groups'),
                  color: Colors.black,
                  icon: const Icon(Icons.groups),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  color: Colors.black,
                  icon: const Icon(Icons.storefront),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/notifications'),
                  color: Colors.black,
                  icon: const Icon(Icons.notifications),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  color: Colors.black,
                  icon: const Icon(Icons.menu),
                ),
              ),
            ],
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Post input row
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/images/profile.jpg'),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "What's on your mind?",
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        color: Colors.blue,
                        icon: const Icon(Icons.image),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Stories section
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(4.0),
                      itemCount: _suggestions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) return const _CreateStoryCard();
                        return _SuggestionCard(suggestion: _suggestions[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Posts list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(4.0),
                    itemCount: _posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) =>
                        _PostCard(post: _posts[index]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Story card with "Image" placeholder
class _CreateStoryCard extends StatelessWidget {
  const _CreateStoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 180,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
        ],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: Text('Image')),
                    ),
                  ),
                ),
                Positioned(
                  right: 40,
                  bottom: 1,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: () {},
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Create Story',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FriendSuggestion {
  final String name;
  const _FriendSuggestion({required this.name});
}

const List<_FriendSuggestion> _suggestions = [
  _FriendSuggestion(name: 'Moni'),
  _FriendSuggestion(name: 'Maklu'),
  _FriendSuggestion(name: 'Rabo'),
  _FriendSuggestion(name: 'Hika'),
  _FriendSuggestion(name: 'Gabo'),
];

class _SuggestionCard extends StatelessWidget {
  final _FriendSuggestion suggestion;
  const _SuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  iconSize: 18,
                  onPressed: () {},
                  icon: const Icon(Icons.close)),
            ],
          ),
          const CircleAvatar(radius: 30, child: Text('Image')),
          Text(suggestion.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add, color: Colors.blue),
            label: const Text('Add', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

class _Post {
  final String author;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;
  const _Post({
    required this.author,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}

const List<_Post> _posts = [
  _Post(
    author: 'Moni',
    content: 'Enjoying a sunny day at the beach!',
    imageUrl: '',
    likes: 150,
    comments: 15,
    shares: 20,
  ),
  _Post(
    author: 'Maklu',
    content: 'Just tried a new recipe, it turned out amazing!',
    imageUrl: '',
    likes: 85,
    comments: 25,
    shares: 15,
  ),
  _Post(
    author: 'Rabo',
    content: 'Finished reading an incredible book today!',
    imageUrl: '',
    likes: 90,
    comments: 25,
    shares: 8,
  ),
  _Post(
    author: 'Hika',
    content: 'Ran 10k this morning, feeling energized!',
    imageUrl: '',
    likes: 250,
    comments: 60,
    shares: 32,
  ),
  _Post(
    author: 'Gabo',
    content: 'Went hiking in the mountains and captured breathtaking views!',
    imageUrl: '',
    likes: 180,
    comments: 45,
    shares: 9,
  ),
];

class _PostCard extends StatelessWidget {
  final _Post post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
        ],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: post.author == 'YourName'
                    ? Image.asset('assets/images/profile.jpg')
                    : const Text('Image'),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  post.author,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(minWidth: 32),
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(post.content),
          const SizedBox(height: 8.0),
          Container(
            height: 150,
            color: Colors.grey.shade300,
            child: const Center(child: Text('Image')),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.thumb_up, color: Colors.blue, size: 16),
              Text('${post.likes}'),
              Text('${post.comments} Comments'),
              Text('${post.shares} Shares'),
            ],
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _actionButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Like',
                  onTap: () {}),
              _actionButton(
                  icon: Icons.comment_outlined, label: 'Comment', onTap: () {}),
              _actionButton(
                  icon: Icons.share_outlined, label: 'Share', onTap: () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

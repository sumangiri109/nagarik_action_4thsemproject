import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTab = 'Following';
  String currentView = 'feed'; // 'feed', 'myPosts', 'settings'
  int? showReactionsForPost;
  bool showCreateReportModal = false;
  bool showNotificationsDropdown = false;
  bool showAllSuggestionsModal = false;
  bool showCommentModal = false;
  bool showEditProfileModal = false;
  int? commentingPostId;
  String? selectedReportArea;
  String? selectedPrivacy = 'Public';
  String? filterArea; // For filtering posts by area
  
  // User profile data
  String userName = 'Bogdan Nikitin';
  String userHandle = '@nikitinteam';
  String userEmail = 'bogdan@example.com';
  String userBio = 'Community activist and civic engagement enthusiast';
  String userAvatar = 'https://i.pravatar.cc/150?img=5';
  
  // Track likes for each post
  Map<int, bool> postLikes = {};
  Map<int, int> postLikeCounts = {
    1: 145,
    2: 89,
    3: 67,
    4: 201,
    5: 134,
    6: 98,
    7: 112,
    8: 76,
  };
  
  // Comments for posts
  Map<int, List<Map<String, String>>> postComments = {
    1: [
      {'author': 'Sarah Johnson', 'avatar': 'https://i.pravatar.cc/150?img=45', 'text': 'This is really concerning! Hope it gets fixed soon.'},
      {'author': 'Mike Chen', 'avatar': 'https://i.pravatar.cc/150?img=68', 'text': 'I drove through there yesterday, it\'s terrible!'},
    ],
    2: [
      {'author': 'Priya Sharma', 'avatar': 'https://i.pravatar.cc/150?img=27', 'text': 'Same issue in our area too!'},
    ],
  };

  // Report Areas with Colors
  final Map<String, Color> reportAreas = {
    'Drinking Water': const Color(0xFFB3E5FC),
    'Road': const Color(0xFFCFD8DC),
    'Electricity': const Color(0xFFFFF9C4),
    'Garbage/Sanitation': const Color(0xFFC8E6C9),
    'Street Lights': const Color(0xFFFFE0B2),
    'Drainage/Sewage': const Color(0xFFD7CCC8),
    'Public Safety': const Color(0xFFFFCDD2),
    'Others': const Color(0xFFE1BEE7),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Light orange background
      body: Stack(
        children: [
          Row(
            children: [
              // Left Sidebar
              _buildLeftSidebar(),
              
              // Main Feed
              Expanded(
                flex: 3,
                child: currentView == 'feed' 
                    ? _buildMainFeed() 
                    : currentView == 'myPosts' 
                        ? _buildMyPosts()
                        : _buildSettingsPage(),
              ),
              
              // Right Sidebar
              _buildRightSidebar(),
            ],
          ),
          
          // Create Report Modal
          if (showCreateReportModal)
            _buildCreateReportModal(),
          
          // Notifications Dropdown
          if (showNotificationsDropdown)
            _buildNotificationsDropdown(),
          
          // All Suggestions Modal
          if (showAllSuggestionsModal)
            _buildAllSuggestionsModal(),
          
          // Comment Modal
          if (showCommentModal && commentingPostId != null)
            _buildCommentModal(commentingPostId!),
          
          // Edit Profile Modal
          if (showEditProfileModal)
            _buildEditProfileModal(),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFFFE0B2)],
              ),
            ),
            child: CircleAvatar(
              radius: 47,
              backgroundImage: NetworkImage(userAvatar),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            userHandle,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 30),
          
          // Menu Items
          _buildMenuItem(Icons.feed, 'News Feed', currentView == 'feed', onTap: () {
            setState(() {
              currentView = 'feed';
            });
          }),
          _buildMenuItem(Icons.notifications, 'Notifications', false, onTap: () {
            setState(() {
              showNotificationsDropdown = !showNotificationsDropdown;
            });
          }),
          _buildMenuItem(Icons.map, 'Map', false),
          _buildMenuItem(Icons.add_circle, 'Add Report', false, isAddPost: true),
          _buildMenuItem(Icons.post_add, 'My Reports', currentView == 'myPosts', onTap: () {
            setState(() {
              currentView = 'myPosts';
            });
          }),
          _buildMenuItem(Icons.settings, 'Settings', currentView == 'settings', onTap: () {
            setState(() {
              currentView = 'settings';
            });
          }),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool isActive, {bool isAddPost = false, VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: isAddPost ? () {
            setState(() {
              showCreateReportModal = true;
            });
          } : onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? const Color(0xFFFF6B6B) : Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? const Color(0xFFFF6B6B) : Colors.white,
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainFeed() {
    // Demo posts with location and following status
    final allPosts = [
      {
        'author': 'George Lobko',
        'time': '2 hours ago',
        'avatar': 'https://i.pravatar.cc/150?img=12',
        'content': 'The road near Central Park is severely damaged with multiple potholes. This is causing accidents and traffic jams. Immediate repair needed!',
        'images': [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
          'https://images.unsplash.com/photo-1551632811-561732d1e306?w=400',
          'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400',
        ],
        'reportArea': 'Road',
        'country': 'Nepal',
        'district': 'Madhesh',
        'isFollowing': true,
      },
      {
        'author': 'Vitaliy Boyko',
        'time': '3 hours ago',
        'avatar': 'https://i.pravatar.cc/150?img=33',
        'content': "Water supply has been disrupted in our area for the last 3 days. Many families are facing severe water shortage. Please resolve this issue urgently.",
        'images': [],
        'reportArea': 'Drinking Water',
        'country': 'Nepal',
        'district': 'Bagmati',
        'isFollowing': true,
      },
      {
        'author': 'Sarah Johnson',
        'time': '5 hours ago',
        'avatar': 'https://i.pravatar.cc/150?img=45',
        'content': "Street lights on Main Street have not been working for a week. The area becomes very dark and unsafe at night. Please fix them soon.",
        'images': ['https://images.unsplash.com/photo-1513002749550-c59d786b8e6c?w=400'],
        'reportArea': 'Street Lights',
        'country': 'Nepal',
        'district': 'Madhesh',
        'isFollowing': false,
      },
      {
        'author': 'Mike Chen',
        'time': '8 hours ago',
        'avatar': 'https://i.pravatar.cc/150?img=68',
        'content': "Garbage has not been collected in our neighborhood for 2 weeks. The smell is unbearable and it's becoming a health hazard. Urgent action needed!",
        'images': [
          'https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=400',
          'https://images.unsplash.com/photo-1604187351574-c75ca79f5807?w=400',
        ],
        'reportArea': 'Garbage/Sanitation',
        'country': 'India',
        'district': 'Bihar',
        'isFollowing': true,
      },
      {
        'author': 'Priya Sharma',
        'time': '10 hours ago',
        'avatar': 'https://i.pravatar.cc/150?img=27',
        'content': "Power cuts are happening daily for 6-8 hours. This is affecting work from home and online classes. The electricity board needs to fix this immediately.",
        'images': ['https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400'],
        'reportArea': 'Electricity',
        'country': 'Nepal',
        'district': 'Madhesh',
        'isFollowing': true,
      },
      {
        'author': 'Raj Kumar',
        'time': '12 hours ago',
        'avatar': 'https://i.pravatar.cc/150?img=51',
        'content': "The drainage system is completely blocked near the market area. Sewage water is overflowing into the streets. This is a serious health concern!",
        'images': [
          'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?w=400',
          'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400',
        ],
        'reportArea': 'Drainage/Sewage',
        'country': 'Nepal',
        'district': 'Bagmati',
        'isFollowing': false,
      },
      {
        'author': 'Emily Watson',
        'time': '1 day ago',
        'avatar': 'https://i.pravatar.cc/150?img=38',
        'content': "There have been multiple theft incidents in our area recently. We need better street lighting and police patrolling for public safety.",
        'images': [],
        'reportArea': 'Public Safety',
        'country': 'Nepal',
        'district': 'Madhesh',
        'isFollowing': true,
      },
      {
        'author': 'David Lee',
        'time': '1 day ago',
        'avatar': 'https://i.pravatar.cc/150?img=62',
        'content': "The public park equipment is broken and rusty. Children can get hurt playing here. Parks department should repair or replace them soon.",
        'images': ['https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400'],
        'reportArea': 'Others',
        'country': 'Nepal',
        'district': 'Koshi',
        'isFollowing': false,
      },
    ];

    // Filter posts based on selected tab and area filter
    List<Map<String, dynamic>> filteredPosts = allPosts.where((post) {
      bool matchesTab = true;
      if (selectedTab == 'My Country') {
        matchesTab = post['country'] == 'Nepal';
      } else if (selectedTab == 'My District') {
        matchesTab = post['district'] == 'Madhesh';
      } else if (selectedTab == 'Following') {
        matchesTab = post['isFollowing'] == true;
      }

      bool matchesArea = filterArea == null || post['reportArea'] == filterArea;

      return matchesTab && matchesArea;
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Title and Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                ).createShader(bounds),
                child: const Text(
                  'Feeds',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontFamily: 'Courier',
                  ),
                ),
              ),
              Row(
                children: [
                  _buildTab('My Country', selectedTab == 'My Country'),
                  _buildTab('My District', selectedTab == 'My District'),
                  _buildTab('Following', selectedTab == 'Following'),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Posts
          ...filteredPosts.asMap().entries.map((entry) {
            final index = entry.key;
            final post = entry.value;
            return Column(
              children: [
                _buildPost(
                  author: post['author'] as String,
                  time: post['time'] as String,
                  avatar: post['avatar'] as String,
                  content: post['content'] as String,
                  images: List<String>.from(post['images'] as List),
                  postId: index + 1,
                  reportArea: post['reportArea'] as String,
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
          
          if (filteredPosts.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Icon(
                    Icons.search_off,
                    size: 100,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No reports found',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMyPosts() {
    // Demo posts by current user (Bogdan Nikitin)
    final myPosts = [
      {
        'time': '1 day ago',
        'content': 'Power outage in Block A for the last 6 hours. Many residents are affected. Please restore electricity as soon as possible.',
        'images': ['https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400'],
        'reportArea': 'Electricity',
      },
      {
        'time': '3 days ago',
        'content': 'Drainage system is clogged near the community center. Water is overflowing onto the streets. This needs immediate attention.',
        'images': [
          'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?w=400',
          'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400',
        ],
        'reportArea': 'Drainage/Sewage',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            ).createShader(bounds),
            child: const Text(
              'My Reports',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
                fontFamily: 'Courier',
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // My Posts
          if (myPosts.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Icon(
                    Icons.post_add,
                    size: 100,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No reports yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            )
          else
            ...myPosts.asMap().entries.map((entry) {
              final index = entry.key;
              final post = entry.value;
              return Column(
                children: [
                  _buildPost(
                    author: 'Bogdan Nikitin',
                    time: post['time'] as String,
                    avatar: 'https://i.pravatar.cc/150?img=5',
                    content: post['content'] as String,
                    images: List<String>.from(post['images'] as List),
                    postId: 100 + index,
                    reportArea: post['reportArea'] as String,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            ).createShader(bounds),
            child: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
                fontFamily: 'Arial',
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Account Section
          _buildSettingsSection(
            'Account',
            [
              _buildSettingsItem(Icons.person, 'Edit Profile', () {
                setState(() {
                  showEditProfileModal = true;
                });
              }),
              _buildSettingsItem(Icons.lock, 'Change Password', () {}),
              _buildSettingsItem(Icons.privacy_tip, 'Privacy Settings', () {}),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Notifications Section
          _buildSettingsSection(
            'Notifications',
            [
              _buildSettingsItem(Icons.notifications, 'Push Notifications', () {}),
              _buildSettingsItem(Icons.email, 'Email Notifications', () {}),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // App Settings Section
          _buildSettingsSection(
            'App Settings',
            [
              _buildSettingsItem(Icons.language, 'Language', () {}),
              _buildSettingsItem(Icons.dark_mode, 'Theme', () {}),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Support Section
          _buildSettingsSection(
            'Support',
            [
              _buildSettingsItem(Icons.help, 'Help Center', () {}),
              _buildSettingsItem(Icons.info, 'About', () {}),
              _buildSettingsItem(Icons.logout, 'Logout', () {}, isLogout: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B6B),
            ),
          ),
          const SizedBox(height: 15),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : const Color(0xFFFF6B6B),
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isLogout ? Colors.red : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = title;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isActive ? const Color(0xFFFF6B6B) : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPost({
    required String author,
    required String time,
    required String avatar,
    required String content,
    required List<String> images,
    required int postId,
    required String reportArea,
  }) {
    Color backgroundColor = reportAreas[reportArea] ?? Colors.white;
    
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Info
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(avatar),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Report Area Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getDarkerShade(backgroundColor),
                    width: 2,
                  ),
                ),
                child: Text(
                  reportArea,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getDarkerShade(backgroundColor),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.more_vert),
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Content
          Text(
            content,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          
          if (images.isNotEmpty) ...[
            const SizedBox(height: 15),
            if (images.length == 1)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  images[0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (images.length == 2)
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        images[0],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        images[1],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        images[0],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        images[1],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            images[2],
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('🔥', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 5),
                                Text('😍', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 5),
                                Text('😮', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 5),
                                Text('❤️', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 5),
                                Text('😂', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
          
          const SizedBox(height: 15),
          
          // Actions
          Row(
            children: [
              const Icon(Icons.visibility, color: Colors.grey, size: 20),
              const SizedBox(width: 5),
              const Text('6355', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      postLikes[postId] = !(postLikes[postId] ?? false);
                      if (postLikes[postId]!) {
                        postLikeCounts[postId] = (postLikeCounts[postId] ?? 0) + 1;
                      } else {
                        postLikeCounts[postId] = (postLikeCounts[postId] ?? 0) - 1;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        postLikes[postId] ?? false ? Icons.favorite : Icons.favorite_border,
                        color: postLikes[postId] ?? false ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${postLikeCounts[postId] ?? 0}',
                        style: TextStyle(
                          color: postLikes[postId] ?? false ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      commentingPostId = postId;
                      showCommentModal = true;
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${(postComments[postId]?.length ?? 0)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (postId == 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Text('🔥', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 5),
                      Text(
                        'Urgent!',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDarkerShade(Color color) {
    return Color.fromRGBO(
      (color.red * 0.7).toInt(),
      (color.green * 0.7).toInt(),
      (color.blue * 0.7).toInt(),
      1,
    );
  }

  Widget _buildNotificationsDropdown() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showNotificationsDropdown = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside
            child: Container(
              width: 450,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showNotificationsDropdown = false;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 400,
                    child: ListView(
                      children: [
                        _buildNotificationItem(
                          Icons.thumb_up,
                          'Sarah Johnson liked your report',
                          '2 hours ago',
                          const Color(0xFF4CAF50),
                        ),
                        _buildNotificationItem(
                          Icons.comment,
                          'Mike Chen commented on your post',
                          '5 hours ago',
                          const Color(0xFF2196F3),
                        ),
                        _buildNotificationItem(
                          Icons.person_add,
                          'Priya Sharma started following you',
                          '1 day ago',
                          const Color(0xFFFF9800),
                        ),
                        _buildNotificationItem(
                          Icons.thumb_up,
                          'George Lobko liked your report',
                          '1 day ago',
                          const Color(0xFF4CAF50),
                        ),
                        _buildNotificationItem(
                          Icons.comment,
                          'Emily Watson commented: "This is important!"',
                          '2 days ago',
                          const Color(0xFF2196F3),
                        ),
                        _buildNotificationItem(
                          Icons.verified,
                          'Your report has been verified by authorities',
                          '3 days ago',
                          const Color(0xFF9C27B0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(IconData icon, String text, String time, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateReportModal() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 650,
          height: MediaQuery.of(context).size.height * 0.85,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Report',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showCreateReportModal = false;
                          selectedReportArea = null;
                          selectedPrivacy = 'Public';
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bogdan Nikitin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '@nikitinteam',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Title Field
                const Text(
                  'Report Title',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter report title',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Report Area Selection
                const Text(
                  'Report Area *',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedReportArea,
                      hint: const Text('Select report area'),
                      items: reportAreas.keys.map((String area) {
                        return DropdownMenuItem<String>(
                          value: area,
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: reportAreas[area],
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(area),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedReportArea = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Description Field
                const Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Describe the issue in detail...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Action Buttons
                Row(
                  children: [
                    _buildModalButton(Icons.photo_camera, 'Photo', Colors.white),
                    const SizedBox(width: 15),
                    _buildModalButton(Icons.location_on, 'Location', Colors.white),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Privacy Selection
                Row(
                  children: [
                    const Text(
                      'Privacy: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPrivacy,
                          items: const [
                            DropdownMenuItem(value: 'Public', child: Text('Public')),
                            DropdownMenuItem(value: 'Followers', child: Text('Followers')),
                            DropdownMenuItem(value: 'Private', child: Text('Private')),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPrivacy = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: selectedReportArea == null ? null : () {
                        setState(() {
                          showCreateReportModal = false;
                          selectedReportArea = null;
                          selectedPrivacy = 'Public';
                        });
                        // Handle report submission
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF6B6B),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Submit Report',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFF6B6B)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Color(0xFFFF6B6B)),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Section
          _buildFilterSection(),
          
          const SizedBox(height: 30),
          
          // Suggestions Section
          _buildSuggestionsSection(),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Area',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B6B),
            ),
          ),
          const SizedBox(height: 15),
          
          // Scrollable area with fixed height
          SizedBox(
            height: 220, // Height for "All" + 3 filter options
            child: ListView(
              children: [
                // All button
                _buildFilterChip('All', filterArea == null),
                const SizedBox(height: 10),
                
                // Area chips
                ...reportAreas.keys.map((area) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildFilterChip(area, filterArea == area),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    Color? chipColor = label == 'All' ? null : reportAreas[label];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          filterArea = label == 'All' ? null : label;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? (chipColor ?? const Color(0xFFFF6B6B))
              : (chipColor?.withOpacity(0.3) ?? Colors.grey.shade200),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected 
                ? (chipColor ?? const Color(0xFFFF6B6B))
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (label != 'All')
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: chipColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B6B),
            ),
          ),
          const SizedBox(height: 12),
          _buildSuggestionItem('Nick Shelburne', 'https://i.pravatar.cc/150?img=15'),
          const SizedBox(height: 10),
          _buildSuggestionItem('Brittni Lando', 'https://i.pravatar.cc/150?img=25'),
          const SizedBox(height: 10),
          _buildSuggestionItem('Ivan Shevchenko', 'https://i.pravatar.cc/150?img=35'),
          const SizedBox(height: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showAllSuggestionsModal = true;
                });
              },
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentModal(int postId) {
    TextEditingController commentController = TextEditingController();
    List<Map<String, String>> comments = postComments[postId] ?? [];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          showCommentModal = false;
          commentingPostId = null;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside
            child: Container(
              width: 550,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showCommentModal = false;
                            commentingPostId = null;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Comment input field
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(userAvatar),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showCommentModal = false;
                            commentingPostId = null;
                          });
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {
                            setState(() {
                              if (postComments[postId] == null) {
                                postComments[postId] = [];
                              }
                              postComments[postId]!.add({
                                'author': userName,
                                'avatar': userAvatar,
                                'text': commentController.text,
                              });
                              commentController.clear();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  
                  // Comments list
                  SizedBox(
                    height: 300,
                    child: comments.isEmpty
                        ? Center(
                            child: Text(
                              'No comments yet. Be the first to comment!',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          )
                        : ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundImage: NetworkImage(comment['avatar']!),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment['author']!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              comment['text']!,
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllSuggestionsModal() {
    final allSuggestions = [
      {'name': 'Nick Shelburne', 'avatar': 'https://i.pravatar.cc/150?img=15'},
      {'name': 'Brittni Lando', 'avatar': 'https://i.pravatar.cc/150?img=25'},
      {'name': 'Ivan Shevchenko', 'avatar': 'https://i.pravatar.cc/150?img=35'},
      {'name': 'Alex Morgan', 'avatar': 'https://i.pravatar.cc/150?img=40'},
      {'name': 'Emma Wilson', 'avatar': 'https://i.pravatar.cc/150?img=47'},
      {'name': 'James Anderson', 'avatar': 'https://i.pravatar.cc/150?img=52'},
      {'name': 'Sophia Martinez', 'avatar': 'https://i.pravatar.cc/150?img=31'},
      {'name': 'Oliver Brown', 'avatar': 'https://i.pravatar.cc/150?img=59'},
    ];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          showAllSuggestionsModal = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside
            child: Container(
              width: 450,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Suggestions',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showAllSuggestionsModal = false;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: allSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = allSuggestions[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(suggestion['avatar']!),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  suggestion['name']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B6B),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text('Follow', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileModal() {
    TextEditingController nameController = TextEditingController(text: userName);
    TextEditingController handleController = TextEditingController(text: userHandle);
    TextEditingController emailController = TextEditingController(text: userEmail);
    TextEditingController bioController = TextEditingController(text: userBio);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          showEditProfileModal = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside
            child: Container(
              width: 550,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              showEditProfileModal = false;
                            });
                          },
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(userAvatar),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Color(0xFFFF6B6B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Name Field
                    const Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Username Field
                    const Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: handleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Email Field
                    const Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Bio Field
                    const Text(
                      'Bio',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: bioController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showEditProfileModal = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              userName = nameController.text;
                              userHandle = handleController.text;
                              userEmail = emailController.text;
                              userBio = bioController.text;
                              showEditProfileModal = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFFF6B6B),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String name, String avatar) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(avatar),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text('Follow', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
} 
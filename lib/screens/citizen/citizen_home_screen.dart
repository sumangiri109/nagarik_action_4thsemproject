// lib/screens/citizen/citizen_home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nagarik_action_4thsemproject/models/user_models.dart';
import '../../models/issue_model.dart';
import '../../models/comment_model.dart';
import '../../models/enums.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'package:nagarik_action_4thsemproject/services/issue_services.dart';
import '../../services/reaction_service.dart';
import '../../services/comment_service.dart';
import 'report_issue_screen.dart';

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({Key? key}) : super(key: key);

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  // Services
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final IssueService _issueService = IssueService();
  final ReactionService _reactionService = ReactionService();
  final CommentService _commentService = CommentService();

  // Current user
  UserModel? currentUser;
  bool isLoadingUser = true;

  // UI State
  String selectedTab = 'My Ward'; // 'My Ward', 'My Municipality', 'My District'
  String currentView = 'feed'; // 'feed', 'myPosts', 'settings'
  bool showNotificationsDropdown = false;
  bool showCommentModal = false;
  String? commentingIssueId;
  String? filterCategory; // For filtering by category

  // Track reactions for each issue
  Map<String, bool> issueReactions = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _userService.getUserById(user.uid);
      setState(() {
        currentUser = userData;
        isLoadingUser = false;
      });

      // Load user's reactions
      if (userData != null) {
        _loadUserReactions();
      }
    } else {
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  Future<void> _loadUserReactions() async {
    // This will be loaded per issue in the stream
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF3E0),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
        ),
      );
    }

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Please login')));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: Stack(
        children: [
          Row(
            children: [
              _buildLeftSidebar(),
              Expanded(
                flex: 3,
                child: currentView == 'feed'
                    ? _buildMainFeed()
                    : currentView == 'myPosts'
                    ? _buildMyPosts()
                    : _buildSettingsPage(),
              ),
              _buildRightSidebar(),
            ],
          ),

          if (showNotificationsDropdown) _buildNotificationsDropdown(),

          if (showCommentModal && commentingIssueId != null)
            _buildCommentModal(commentingIssueId!),
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
              backgroundImage: currentUser?.profileImageUrl != null
                  ? NetworkImage(currentUser!.profileImageUrl!)
                  : null,
              child: currentUser?.profileImageUrl == null
                  ? Text(
                      currentUser?.name[0].toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Color(0xFFFF6B6B),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            currentUser?.name ?? 'User',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            currentUser?.email ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '${currentUser?.location.district}, Ward ${currentUser?.location.ward}',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Menu Items
          _buildMenuItem(
            Icons.feed,
            'News Feed',
            currentView == 'feed',
            onTap: () {
              setState(() => currentView = 'feed');
            },
          ),
          _buildMenuItem(
            Icons.notifications,
            'Notifications',
            false,
            onTap: () {
              setState(
                () => showNotificationsDropdown = !showNotificationsDropdown,
              );
            },
          ),
          _buildMenuItem(
            Icons.map,
            'Map',
            false,
            onTap: () {
              // TODO: Implement map view
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Map feature coming soon!'),
                  backgroundColor: Color(0xFFFF6B6B),
                ),
              );
            },
          ),
          _buildMenuItem(
            Icons.add_circle,
            'Add Report',
            false,
            isAddPost: true,
          ),
          _buildMenuItem(
            Icons.post_add,
            'My Reports',
            currentView == 'myPosts',
            onTap: () {
              setState(() => currentView = 'myPosts');
            },
          ),
          _buildMenuItem(
            Icons.settings,
            'Settings',
            currentView == 'settings',
            onTap: () {
              setState(() => currentView = 'settings');
            },
          ),

          const Spacer(),

          // Logout
          _buildMenuItem(
            Icons.logout,
            'Logout',
            false,
            onTap: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    bool isActive, {
    bool isAddPost = false,
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isAddPost
            ? () {
                // Navigate to Report Issue Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
                );
              }
            : onTap,
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
    );
  }

  Widget _buildMainFeed() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Title and Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
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
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildTab('My Ward', selectedTab == 'My Ward'),
                    _buildTab(
                      'My Municipality',
                      selectedTab == 'My Municipality',
                    ),
                    _buildTab('My District', selectedTab == 'My District'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Issues Stream
          Expanded(
            child: StreamBuilder<List<IssueModel>>(
              stream: _getIssuesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final issues = snapshot.data ?? [];

                if (issues.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: issues.length,
                  itemBuilder: (context, index) {
                    final issue = issues[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildIssueCard(issue),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<IssueModel>> _getIssuesStream() {
    if (currentUser == null) return Stream.value([]);

    String filterType;
    String? municipality;
    int? ward;

    if (selectedTab == 'My Ward') {
      filterType = 'ward';
      municipality = currentUser!.location.municipality;
      ward = currentUser!.location.ward;
    } else if (selectedTab == 'My Municipality') {
      filterType = 'municipality';
      municipality = currentUser!.location.municipality;
    } else {
      filterType = 'district';
    }

    return _issueService.getIssuesForCitizen(
      district: currentUser!.location.district,
      municipality: municipality,
      ward: ward,
      filterType: filterType,
      categoryFilter: filterCategory != null
          ? IssueCategory.fromJson(filterCategory!)
          : null,
    );
  }

  Widget _buildIssueCard(IssueModel issue) {
    final categoryColor = _getCategoryColor(issue.category);

    return FutureBuilder<bool>(
      future: _reactionService.hasUserReacted(
        issueId: issue.issueId,
        userId: currentUser!.uid,
      ),
      builder: (context, reactionSnapshot) {
        final hasReacted = reactionSnapshot.data ?? false;

        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: categoryColor,
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
              // Author Info & Status
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    child: Text(
                      issue.reporterName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.reporterName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          issue.getTimeAgo(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getDarkerShade(categoryColor),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      issue.category.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getDarkerShade(categoryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Status Badge
                  _buildStatusBadge(issue.status),
                ],
              ),

              const SizedBox(height: 15),

              // Title
              Text(
                issue.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                issue.description,
                style: const TextStyle(fontSize: 15, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Images
              if (issue.imageUrls.isNotEmpty) ...[
                const SizedBox(height: 15),
                _buildImageGallery(issue.imageUrls),
              ],

              // Location
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${issue.issueLocation.municipality}, Ward ${issue.issueLocation.ward}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Actions
              Row(
                children: [
                  const Icon(Icons.visibility, color: Colors.grey, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${issue.viewsCount}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 20),

                  // Like Button
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _toggleReaction(issue),
                      child: Row(
                        children: [
                          Icon(
                            hasReacted ? Icons.favorite : Icons.favorite_border,
                            color: hasReacted ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${issue.reactionsCount}',
                            style: TextStyle(
                              color: hasReacted ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Comment Button
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          commentingIssueId = issue.issueId;
                          showCommentModal = true;
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${issue.commentsCount}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Priority Badge
                  if (issue.priority == IssuePriority.urgent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
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
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(IssueStatus status) {
    Color badgeColor;
    String label;

    switch (status) {
      case IssueStatus.not_started:
        badgeColor = Colors.red;
        label = 'NOT STARTED';
        break;
      case IssueStatus.in_progress:
        badgeColor = Colors.orange;
        label = 'IN PROGRESS';
        break;
      case IssueStatus.completed:
        badgeColor = Colors.green;
        label = 'COMPLETED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getCategoryColor(IssueCategory category) {
    switch (category) {
      case IssueCategory.infrastructure:
        return const Color(0xFFCFD8DC);
      case IssueCategory.water:
        return const Color(0xFFB3E5FC);
      case IssueCategory.electricity:
        return const Color(0xFFFFF9C4);
      case IssueCategory.sanitation:
        return const Color(0xFFC8E6C9);
      case IssueCategory.health:
        return const Color(0xFFFFCDD2);
      case IssueCategory.education:
        return const Color(0xFFE1BEE7);
      case IssueCategory.other:
        return const Color(0xFFE0E0E0);
    }
  }

  Color _getDarkerShade(Color color) {
    return Color.fromRGBO(
      (color.red * 0.7).toInt(),
      (color.green * 0.7).toInt(),
      (color.blue * 0.7).toInt(),
      1,
    );
  }

  Widget _buildImageGallery(List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          images[0],
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              color: Colors.grey.shade200,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  color: const Color(0xFFFF6B6B),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            );
          },
        ),
      );
    } else if (images.length == 2) {
      return Row(
        children: images.map((url) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  url,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 200, color: Colors.grey.shade300),
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Row(
        children: images.take(3).map((url) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  url,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 200, color: Colors.grey.shade300),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  Future<void> _toggleReaction(IssueModel issue) async {
    final hasReacted = await _reactionService.toggleReaction(
      issueId: issue.issueId,
      userId: currentUser!.uid,
      userName: currentUser!.name,
    );

    setState(() {
      issueReactions[issue.issueId] = hasReacted;
    });
  }

  Widget _buildTab(String title, bool isActive) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = title),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            'No reports found',
            style: TextStyle(fontSize: 20, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to report an issue!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPosts() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ShaderMask(
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
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder<List<IssueModel>>(
              stream: _issueService.getUserIssues(currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
                  );
                }

                final issues = snapshot.data ?? [];

                if (issues.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: issues.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildIssueCard(issues[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    // Keep your original settings page - no changes needed
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(child: Text('Settings Page - Coming Soon')),
    );
  }

  Widget _buildRightSidebar() {
    // Your original right sidebar with category filter
    final categories = [
      'All',
      'Infrastructure',
      'Water',
      'Electricity',
      'Sanitation',
      'Health',
      'Education',
      'Other',
    ];

    return Container(
      width: 300,
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
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
                  'Filter by Category',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B6B),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category == 'All'
                          ? filterCategory == null
                          : filterCategory == category.toLowerCase();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              filterCategory = category == 'All'
                                  ? null
                                  : category.toLowerCase();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFF6B6B)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder modals - you can implement these later
  Widget _buildCreateReportModal() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: Text('Report Issue - Coming Soon')),
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
                  Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'ll be notified when someone comments\non your reports or updates their status',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
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

  Widget _buildCommentModal(String issueId) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: Text('Comments - Coming Soon')),
    );
  }
}

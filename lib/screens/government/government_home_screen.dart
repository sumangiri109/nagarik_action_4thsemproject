// lib/screens/government/government_home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nagarik_action_4thsemproject/models/user_models.dart';
import '../../models/issue_model.dart';
import '../../models/comment_model.dart';
import '../../models/enums.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'package:nagarik_action_4thsemproject/services/issue_services.dart';
import '../../services/comment_service.dart';
import 'package:nagarik_action_4thsemproject/screens/login_page.dart';

class GovernmentHomeScreen extends StatefulWidget {
  const GovernmentHomeScreen({Key? key}) : super(key: key);

  @override
  State<GovernmentHomeScreen> createState() => _GovernmentHomeScreenState();
}

class _GovernmentHomeScreenState extends State<GovernmentHomeScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final IssueService _issueService = IssueService();
  final CommentService _commentService = CommentService();

  UserModel? currentUser;
  bool isLoading = true;

  // Filters
  IssueStatus? selectedStatusFilter;
  IssueCategory? selectedCategoryFilter;

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
        isLoading = false;
      });
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentUser == null) {
      return const NagarikLoginPage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: Row(
        children: [
          _buildLeftSidebar(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  // right sidebar for space

  Widget _buildRightSpacer() {
    return Container(
      width: 200, // Same width as citizen's filter sidebar
      margin: const EdgeInsets.all(30),
      // Empty container - just takes up space
    );
  }

  // ============================================================
  // LEFT SIDEBAR
  // ============================================================
  Widget _buildLeftSidebar() {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Logo
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Government Portal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          // Jurisdiction Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_on, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Your Jurisdiction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currentUser!.location.district,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  currentUser!.location.municipality,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  'Ward ${currentUser!.location.ward}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Position Badge
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.badge, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    currentUser?.governmentDetails?.position ?? 'Official',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // User Info
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Text(
                    currentUser!.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Government',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Logout
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await _authService.signOut();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NagarikLoginPage(),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.white, size: 22),
                      SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN CONTENT
  // ============================================================
  Widget _buildMainContent() {
    return Column(
      children: [
        _buildTopBar(),
        _buildStatisticsSection(),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildIssuesFeed()),
              _buildRightSpacer(), // Space only for the feed
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            ).createShader(bounds),
            child: const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          _buildFilterDropdown(),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 18, color: Color(0xFFFF6B6B)),
          const SizedBox(width: 8),
          DropdownButton<IssueStatus?>(
            value: selectedStatusFilter,
            hint: const Text('All Status', style: TextStyle(fontSize: 14)),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: null, child: Text('All Status')),
              DropdownMenuItem(
                value: IssueStatus.not_started,
                child: Text('Not Started'),
              ),
              DropdownMenuItem(
                value: IssueStatus.in_progress,
                child: Text('In Progress'),
              ),
              DropdownMenuItem(
                value: IssueStatus.completed,
                child: Text('Completed'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedStatusFilter = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS SECTION
  // ============================================================
  Widget _buildStatisticsSection() {
    return StreamBuilder<Map<String, int>>(
      stream: _getStatisticsStream(),
      builder: (context, snapshot) {
        final stats =
            snapshot.data ??
            {'total': 0, 'notStarted': 0, 'inProgress': 0, 'completed': 0};

        final total = stats['total'] ?? 0;
        final active = (stats['notStarted'] ?? 0) + (stats['inProgress'] ?? 0);
        final resolved = stats['completed'] ?? 0;
        final resolutionRate = total > 0
            ? ((resolved / total) * 100).toInt()
            : 0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  total.toString(),
                  Icons.assignment,
                  const Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Active',
                  active.toString(),
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Resolved',
                  resolved.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Rate',
                  '$resolutionRate%',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Stream<Map<String, int>> _getStatisticsStream() {
    return _issueService
        .getIssuesForGovernment(
          district: currentUser!.location.district,
          municipality: currentUser!.location.municipality,
          ward: currentUser!.location.ward,
        )
        .map((issues) {
          int notStarted = 0;
          int inProgress = 0;
          int completed = 0;

          for (var issue in issues) {
            switch (issue.status) {
              case IssueStatus.not_started:
                notStarted++;
                break;
              case IssueStatus.in_progress:
                inProgress++;
                break;
              case IssueStatus.completed:
                completed++;
                break;
            }
          }

          return {
            'total': issues.length,
            'notStarted': notStarted,
            'inProgress': inProgress,
            'completed': completed,
          };
        });
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ISSUES FEED
  // ============================================================
  Widget _buildIssuesFeed() {
    return StreamBuilder<List<IssueModel>>(
      stream: _issueService.getIssuesForGovernment(
        district: currentUser!.location.district,
        municipality: currentUser!.location.municipality,
        ward: currentUser!.location.ward,
        statusFilter: selectedStatusFilter,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final issues = snapshot.data ?? [];

        if (issues.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: issues.length,
          itemBuilder: (context, index) => _buildIssueCard(issues[index]),
        );
      },
    );
  }

  Widget _buildIssueCard(IssueModel issue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Compact
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.2),
                  child: Text(
                    issue.reporterName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue.reporterName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _getTimeAgo(issue.createdAt),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCategoryBadge(issue.category),
              ],
            ),
          ),

          // Title & Description - Compact
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  issue.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Images - SAME SIZE AS CITIZEN HOME PAGE
          if (issue.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 2),
            _buildImageGallery(issue.imageUrls),
          ],

          const SizedBox(height: 4),

          // Reporter Contact - Compact
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200, width: 0.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, size: 14, color: Colors.blue.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      issue.reporterEmail,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        _sendEmail(issue.reporterEmail, issue.title),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Email', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Status Update & Actions - All in one row
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Status Dropdown - Compact
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    child: DropdownButton<IssueStatus>(
                      value: issue.status,
                      underline: const SizedBox(),
                      isExpanded: true,
                      isDense: true,
                      items: IssueStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Row(
                            children: [
                              _getStatusIcon(status),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  status.displayName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getStatusColor(status),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null && newStatus != issue.status) {
                          _updateIssueStatus(issue, newStatus);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Engagement Stats - Compact
                _buildEngagementStat(
                  Icons.visibility,
                  issue.viewsCount.toString(),
                ),
                const SizedBox(width: 10),
                _buildEngagementStat(
                  Icons.favorite,
                  issue.reactionsCount.toString(),
                ),
                const SizedBox(width: 10),

                // Comments Button
                TextButton.icon(
                  onPressed: () => _showCommentModal(issue),
                  icon: const Icon(Icons.comment_outlined, size: 14),
                  label: Text(
                    '${issue.commentsCount}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(IssueModel issue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<IssueStatus>(
        value: issue.status,
        underline: const SizedBox(),
        isExpanded: true,
        items: IssueStatus.values.map((status) {
          return DropdownMenuItem(
            value: status,
            child: Row(
              children: [
                _getStatusIcon(status),
                const SizedBox(width: 8),
                Text(
                  status.displayName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(status),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (newStatus) {
          if (newStatus != null && newStatus != issue.status) {
            _updateIssueStatus(issue, newStatus);
          }
        },
      ),
    );
  }

  Widget _getStatusIcon(IssueStatus status) {
    switch (status) {
      case IssueStatus.not_started:
        return const Icon(Icons.circle, color: Colors.red, size: 12);
      case IssueStatus.in_progress:
        return const Icon(Icons.circle, color: Colors.orange, size: 12);
      case IssueStatus.completed:
        return const Icon(Icons.circle, color: Colors.green, size: 12);
    }
  }

  Color _getStatusColor(IssueStatus status) {
    switch (status) {
      case IssueStatus.not_started:
        return Colors.red.shade700;
      case IssueStatus.in_progress:
        return Colors.orange.shade700;
      case IssueStatus.completed:
        return Colors.green.shade700;
    }
  }

  Future<void> _updateIssueStatus(
    IssueModel issue,
    IssueStatus newStatus,
  ) async {
    final success = await _issueService.updateIssueStatus(
      issueId: issue.issueId,
      newStatus: newStatus,
      updatedBy: currentUser!.uid,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Status updated to ${newStatus.displayName}'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to update status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendEmail(String email, String subject) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Regarding: $subject',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open email client'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Widget _buildImageGallery(List<String> imageUrls) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: imageUrls.length == 1
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrls[0],
                width: double.infinity,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length > 3 ? 3 : imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildCategoryBadge(IssueCategory category) {
    final categoryColors = {
      'infrastructure': const Color(0xFFCFD8DC),
      'water': const Color(0xFFB3E5FC),
      'electricity': const Color(0xFFFFF9C4),
      'sanitation': const Color(0xFFC8E6C9),
      'health': const Color(0xFFF8BBD0),
      'education': const Color(0xFFD1C4E9),
      'other': const Color(0xFFE0E0E0),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: categoryColors[category.name] ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category.displayName,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEngagementStat(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 3),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            'No issues in your ward',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Issues reported in Ward ${currentUser?.location.ward} will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMENT MODAL
  // ============================================================
  void _showCommentModal(IssueModel issue) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.comment,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // Comments List
              Expanded(
                child: StreamBuilder<List<CommentModel>>(
                  stream: _commentService.getComments(issue.issueId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data ?? [];

                    if (comments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 60,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No comments yet',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final isGovernment =
                            comment.userRole == UserRole.government;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isGovernment
                                ? Colors.blue.shade50
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isGovernment
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: isGovernment
                                        ? Colors.blue
                                        : Colors.grey,
                                    child: Text(
                                      comment.userName
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment.userName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            if (isGovernment) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Text(
                                                  'Government',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          _getTimeAgo(comment.createdAt),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                comment.text,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Add Comment
              const Divider(),
              _CommentInput(
                issueId: issue.issueId,
                currentUser: currentUser!,
                commentService: _commentService,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COMMENT INPUT WIDGET
// ============================================================
class _CommentInput extends StatefulWidget {
  final String issueId;
  final UserModel currentUser;
  final CommentService commentService;

  const _CommentInput({
    required this.issueId,
    required this.currentUser,
    required this.commentService,
  });

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);

    final comment = CommentModel(
      commentId: '',
      userId: widget.currentUser.uid,
      userName: widget.currentUser.name,
      userRole: widget.currentUser.role,
      text: _controller.text.trim(),
      createdAt: DateTime.now(),
    );

    final success = await widget.commentService.addComment(
      issueId: widget.issueId,
      comment: comment,
    );

    if (success != null) {
      _controller.clear();
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitComment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

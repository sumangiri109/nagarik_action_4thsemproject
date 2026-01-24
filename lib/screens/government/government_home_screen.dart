// lib/screens/government/government_home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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

  // ===================================================================
  // LEFT SIDEBAR
  // ===================================================================
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
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.account_balance, color: Colors.white, size: 40),
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
                    Text('Your Jurisdiction',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
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
                  "Ward ${currentUser!.location.ward}",
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
              children: [
                const Icon(Icons.badge, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    currentUser!.governmentDetails?.position ?? "Official",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
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
                    currentUser!.name[0].toUpperCase(),
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Government",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Logout
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () async {
                await _authService.signOut();
                if (mounted) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const NagarikLoginPage()));
                }
              },
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.white, size: 22),
                  SizedBox(width: 12),
                  Text("Logout", style: TextStyle(color: Colors.white, fontSize: 15)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===================================================================
  // MAIN CONTENT
  // ===================================================================
  Widget _buildMainContent() {
    return Column(
      children: [
        _buildTopBar(),
        _buildStatisticsSection(),
        Expanded(child: _buildIssuesFeed()),
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
              offset: const Offset(0, 2)),
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
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Color(0xFFFF6B6B), size: 18),
          const SizedBox(width: 6),
          DropdownButton<IssueStatus?>(
            value: selectedStatusFilter,
            underline: const SizedBox(),
            hint: const Text("All Status"),
            items: const [
              DropdownMenuItem(value: null, child: Text("All Status")),
              DropdownMenuItem(
                  value: IssueStatus.not_started, child: Text("Not Started")),
              DropdownMenuItem(
                  value: IssueStatus.in_progress, child: Text("In Progress")),
              DropdownMenuItem(
                  value: IssueStatus.completed, child: Text("Completed")),
            ],
            onChanged: (value) => setState(() => selectedStatusFilter = value),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // STATISTICS
  // ===================================================================
  Widget _buildStatisticsSection() {
    return StreamBuilder<Map<String, int>>(
      stream: _getStatisticsStream(),
      builder: (context, snapshot) {
        final stats = snapshot.data ?? {
          "total": 0,
          "notStarted": 0,
          "inProgress": 0,
          "completed": 0,
        };

        final total = stats["total"]!;
        final active = stats["notStarted"]! + stats["inProgress"]!;
        final resolved = stats["completed"]!;
        final resolutionRate =
            total == 0 ? 0 : ((resolved / total) * 100).toInt();

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: _buildStatCard("Total Issues", "$total",
                          Icons.assignment, const Color(0xFFFF6B6B))),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildStatCard("Active", "$active",
                          Icons.pending_actions, Colors.orange)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildStatCard("Resolved", "$resolved",
                          Icons.check_circle, Colors.green)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildStatCard("Resolution Rate", "$resolutionRate%",
                          Icons.trending_up, Colors.blue)),
                ],
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
      int notStarted = 0, inProgress = 0, completed = 0;

      for (var issue in issues) {
        if (issue.status == IssueStatus.not_started) notStarted++;
        if (issue.status == IssueStatus.in_progress) inProgress++;
        if (issue.status == IssueStatus.completed) completed++;
      }

      return {
        "total": issues.length,
        "notStarted": notStarted,
        "inProgress": inProgress,
        "completed": completed,
      };
    });
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ],
      ),
    );
  }

  // ===================================================================
  // ISSUES FEED — COMPLETED SECTION
  // ===================================================================
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
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final issues = snapshot.data ?? [];

        if (issues.isEmpty) {
          return const Center(
              child: Text(
            "No issues found in your jurisdiction.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: issues.length,
          itemBuilder: (context, index) {
            return _buildIssueCard(issues[index]);
          },
        );
      },
    );
  }

  // ===================================================================
  // ISSUE CARD
  // ===================================================================
  Widget _buildIssueCard(IssueModel issue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Status
          Row(
            children: [
              Expanded(
                child: Text(
                  issue.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildStatusTag(issue.status),
            ],
          ),

          const SizedBox(height: 6),

          Text(timeago.format(issue.createdAt.toDate()),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),

          const SizedBox(height: 12),

          Text(issue.description,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 14)),

          const SizedBox(height: 12),

          if (issue.mediaUrl != null) _buildMediaPreview(issue.mediaUrl!),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.comment, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              StreamBuilder<List<CommentModel>>(
                stream: _commentService.getComments(issue.id),
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  return Text("$count comments",
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade700));
                },
              ),
              const Spacer(),
              _buildUpdateStatusButton(issue),
            ],
          )
        ],
      ),
    );
  }

  // ===================================================================
  // MEDIA PREVIEW
  // ===================================================================
  Widget _buildMediaPreview(String url) {
    final isImage =
        url.endsWith(".png") || url.endsWith(".jpg") || url.endsWith(".jpeg");

    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        height: isImage ? 160 : 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(url, fit: BoxFit.cover))
            : Row(
                children: const [
                  SizedBox(width: 10),
                  Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
                  SizedBox(width: 10),
                  Text("View PDF",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
      ),
    );
  }

  // ===================================================================
  // STATUS TAG
  // ===================================================================
  Widget _buildStatusTag(IssueStatus status) {
    Color color;

    switch (status) {
      case IssueStatus.not_started:
        color = Colors.red;
        break;
      case IssueStatus.in_progress:
        color = Colors.orange;
        break;
      case IssueStatus.completed:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
      child: Text(
        status.displayName,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  // ===================================================================
  // UPDATE STATUS BUTTON
  // ===================================================================
  Widget _buildUpdateStatusButton(IssueModel issue) {
    return PopupMenuButton<IssueStatus>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: const [
            Icon(Icons.edit, size: 16, color: Colors.blue),
            SizedBox(width: 6),
            Text("Update", style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
      onSelected: (status) async {
        await _issueService.updateIssueStatus(issue.id, status);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
            value: IssueStatus.not_started, child: Text("Not Started")),
        const PopupMenuItem(
            value: IssueStatus.in_progress, child: Text("In Progress")),
        const PopupMenuItem(
            value: IssueStatus.completed, child: Text("Completed")),
      ],
    );
  }
}

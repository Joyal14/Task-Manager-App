import 'package:flutter/material.dart';
import 'package:task_manager_app/features/auth/data/models/user_model.dart';

class TaskItem {
  final String id;
  final String title;
  final String category;
  final String time;
  final String priority; 
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.priority,
    this.isCompleted = false,
  });
}

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Work', 'Personal', 'Design', 'Dev'];

  final List<TaskItem> _tasks = [
    TaskItem(
      id: '1',
      title: 'Review UI mockups for mobile app',
      category: 'Design',
      time: '10:00 AM',
      priority: 'High',
      isCompleted: false,
    ),
    TaskItem(
      id: '2',
      title: 'Setup Dio client & API endpoints',
      category: 'Dev',
      time: '11:30 AM',
      priority: 'High',
      isCompleted: true,
    ),
    TaskItem(
      id: '3',
      title: 'Team sync meeting & weekly roadmap',
      category: 'Work',
      time: '02:00 PM',
      priority: 'Medium',
      isCompleted: false,
    ),
    TaskItem(
      id: '4',
      title: 'Evening gym session & 5k run',
      category: 'Personal',
      time: '06:30 PM',
      priority: 'Low',
      isCompleted: false,
    ),
    TaskItem(
      id: '5',
      title: 'Draft technical design documentation',
      category: 'Work',
      time: '08:00 PM',
      priority: 'Medium',
      isCompleted: false,
    ),
  ];

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _addNewTaskModal() {
    final titleController = TextEditingController();
    String selectedCategory = 'Work';
    String selectedPriority = 'Medium';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create New Task',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: ['Work', 'Personal', 'Design', 'Dev']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => selectedCategory = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: ['High', 'Medium', 'Low']
                              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => selectedPriority = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.trim().isNotEmpty) {
                          setState(() {
                            _tasks.insert(
                              0,
                              TaskItem(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: titleController.text.trim(),
                                category: selectedCategory,
                                time: 'Just now',
                                priority: selectedPriority,
                              ),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Save Task',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final completedCount = _tasks.where((t) => t.isCompleted).length;
    final pendingCount = _tasks.length - completedCount;

    final filteredTasks = _selectedCategory == 'All'
        ? _tasks
        : _tasks.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // User Header & Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: theme.colorScheme.primary,
                              child: Text(
                                widget.user.firstName.isNotEmpty
                                    ? widget.user.firstName[0].toUpperCase()
                                    : 'A',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${widget.user.firstName} 👋',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  'You have $pendingCount tasks pending today',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Notification Bell with Badge
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.search_rounded,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          hintText: 'Search tasks, tags, or projects...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Overview Stats Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatWidget('Total Tasks', '${_tasks.length}', Icons.list_alt_rounded),
                          Container(width: 1, height: 40, color: Colors.white24),
                          _buildStatWidget('Completed', '$completedCount', Icons.check_circle_outline_rounded),
                          Container(width: 1, height: 40, color: Colors.white24),
                          _buildStatWidget('Pending', '$pendingCount', Icons.pending_actions_rounded),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category Selector
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: FilterChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: theme.colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF334155)),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : (isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFCBD5E1)),
                                ),
                              ),
                              onSelected: (_) {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Tasks",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${filteredTasks.length} tasks',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Task Items List
            filteredTasks.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 64,
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFCBD5E1),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No tasks in this category',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = filteredTasks[index];
                          final priorityColor = _getPriorityColor(task.priority);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              leading: Checkbox(
                                value: task.isCompleted,
                                activeColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    task.isCompleted = val ?? false;
                                  });
                                },
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: task.isCompleted
                                      ? (isDark
                                          ? const Color(0xFF64748B)
                                          : const Color(0xFF94A3B8))
                                      : (isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A)),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 13,
                                      color: isDark
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      task.time,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        task.category,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: priorityColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  task.priority,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: priorityColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: filteredTasks.length,
                      ),
                    ),
                  ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewTaskModal,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedNavIndex,
          onTap: (index) {
            setState(() {
              _selectedNavIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor:
              isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_rounded),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatWidget(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/enums/task_status.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/presentation/bloc/task_event.dart';
import '../../../tasks/presentation/bloc/task_state.dart';
import '../../../tasks/presentation/pages/task_detail_page.dart';
import '../../../tasks/presentation/pages/task_form_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../location/presentation/widgets/location_permission_dialog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationPermissionDenied) {
          // Show dialog after first frame to ensure context is ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              LocationPermissionDialog.show(context);
            }
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<TaskBloc>().add(const LoadMyTasksEvent());
            await Future.delayed(const Duration(milliseconds: 300));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    _buildStatsSection(),
                    _buildQuickActions(),
                    _buildRecentTasks(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'User';
        if (state is AuthAuthenticatedState) {
          userName = state.user.displayName;
        }

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        int totalTasks = 0;
        int pendingTasks = 0;
        int completedTasks = 0;
        int dueTodayTasks = 0;

        if (state is TasksLoaded) {
          totalTasks = state.tasks.length;
          pendingTasks = state.tasks
              .where((task) => task.status == TaskStatus.pending)
              .length;
          completedTasks = state.tasks
              .where((task) => task.status == TaskStatus.completed)
              .length;

          final today = DateTime.now();
          dueTodayTasks = state.tasks.where((task) {
            return task.dueDateTime.year == today.year &&
                task.dueDateTime.month == today.month &&
                task.dueDateTime.day == today.day &&
                task.status != TaskStatus.completed;
          }).length;
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _AnimatedStatCard(
                      title: 'Total',
                      value: totalTasks.toString(),
                      icon: Icons.task_alt,
                      color: Colors.blue,
                      delay: 100,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AnimatedStatCard(
                      title: 'Pending',
                      value: pendingTasks.toString(),
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                      delay: 200,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _AnimatedStatCard(
                      title: 'Completed',
                      value: completedTasks.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                      delay: 300,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AnimatedStatCard(
                      title: 'Due Today',
                      value: dueTodayTasks.toString(),
                      icon: Icons.today,
                      color: Colors.red,
                      delay: 400,
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

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _AnimatedQuickActionCard(
                  title: 'Create Task',
                  icon: Icons.add_task,
                  color: Colors.blue,
                  delay: 100,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskFormPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AnimatedQuickActionCard(
                  title: 'Update Location',
                  icon: Icons.my_location,
                  color: Colors.orange,
                  delay: 400,
                  onTap: () {
                    context
                        .read<LocationBloc>()
                        .add(const GetCurrentLocationEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Getting current location...')),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRecentTasks() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is TasksLoaded) {
          final recentTasks = state.tasks.take(5).toList();

          if (recentTasks.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first task to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Tasks',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTasks.length < 3 ? recentTasks.length : 3,
                  itemBuilder: (context, index) {
                    final task = recentTasks[index];
                    return _AnimatedTaskListItem(
                      task: task,
                      delay: index * 100,
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// Animated Stat Card Widget
class _AnimatedStatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const _AnimatedStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color statColor = theme.colorScheme.primary;
    final Color statTextColor = theme.colorScheme.onSurface.withOpacity(0.8);
    final Color statLabelColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + widget.delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final v = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: v,
          child: Opacity(
            opacity: v,
            child: child,
          ),
        );
      },
      child: Card(
        // elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + widget.delay),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      final v = value.clamp(0.0, 1.0);
                      return Transform.scale(
                        scale: v,
                        child: Icon(widget.icon, color: statColor, size: 28),
                      );
                    },
                  ),
                  TweenAnimationBuilder<int>(
                    duration: Duration(milliseconds: 800 + widget.delay),
                    tween: IntTween(
                      begin: 0,
                      end: int.tryParse(widget.value) ?? 0,
                    ),
                    builder: (context, value, child) {
                      final displayValue = value >= 9 ? '9+' : value.toString();
                      return Text(
                        displayValue,
                        style: value >= 9
                            ? theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: statTextColor,
                              )
                            : theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: statTextColor,
                              ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: statLabelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated Quick Action Card Widget
class _AnimatedQuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _AnimatedQuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color actionColor = theme.colorScheme.secondary;
    final Color actionTextColor = theme.colorScheme.onSurface.withOpacity(0.8);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        // elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 400 + delay),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: actionColor.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: actionColor, size: 28),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: actionTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Animated Task List Item Widget
class _AnimatedTaskListItem extends StatelessWidget {
  final dynamic task;
  final int delay;

  const _AnimatedTaskListItem({
    required this.task,
    required this.delay,
  });

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.checkedIn:
        return Colors.blue;
      case TaskStatus.checkedOut:
        return Colors.grey;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
      case TaskStatus.expired:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending;
      case TaskStatus.checkedIn:
        return Icons.location_on;
      case TaskStatus.checkedOut:
        return Icons.logout;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel;
      case TaskStatus.expired:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor(task.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getStatusIcon(task.status),
              color: _getStatusColor(task.status),
            ),
          ),
          title: Text(
            task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                task.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, hh:mm a').format(task.dueDateTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailPage(taskId: task.id),
              ),
            );
          },
        ),
      ),
    );
  }
}

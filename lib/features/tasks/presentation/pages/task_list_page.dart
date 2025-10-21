import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/services/expired_tasks_checker_service.dart';
import '../../domain/entities/task.dart';
import '../../../sync/presentation/widgets/sync_status_indicator.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_card.dart';
import 'task_detail_page.dart';
import 'task_form_page.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TaskBloc>()..add(const LoadMyTasksEvent()),
      child: const TaskListView(),
    );
  }
}

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'all';
  List<Task> _filteredTasks = [];
  Timer? _searchDebounce;
  late AnimationController _fabController;
  late AnimationController _headerController;
  bool _isSearchFocused = false;

  final List<Map<String, dynamic>> _filters = [
    {'value': 'all', 'label': 'All', 'icon': Icons.list, 'color': Colors.blue},
    {
      'value': 'pending',
      'label': 'Pending',
      'icon': Icons.pending_actions,
      'color': Colors.orange
    },
    {
      'value': 'checked_in',
      'label': 'Checked In',
      'icon': Icons.check_circle,
      'color': Colors.blue
    },
    {
      'value': 'completed',
      'label': 'Completed',
      'icon': Icons.done_all,
      'color': Colors.green
    },
    {
      'value': 'expired',
      'label': 'Expired',
      'icon': Icons.warning,
      'color': Colors.red
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fabController.forward();
    _headerController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    _fabController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bloc = context.read<TaskBloc>();
    final state = bloc.state;

    // Auto-hide/show FAB based on scroll direction
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_fabController.status == AnimationStatus.completed) {
        _fabController.reverse();
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_fabController.status == AnimationStatus.dismissed) {
        _fabController.forward();
      }
    }

    // Trigger load more when user scrolls to 90% of the list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (state is TasksLoaded && state.hasMore) {
        bloc.add(const LoadMoreTasksEvent());
      }
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _currentFilter = filter;
    });

    final bloc = context.read<TaskBloc>();

    if (filter == 'expired') {
      bloc.add(const LoadExpiredTasksEvent(useLocal: false));
    } else if (filter == 'all') {
      bloc.add(const LoadMyTasksEvent(isRefresh: true));
    } else {
      bloc.add(LoadTasksByStatusEvent(filter));
    }
  }

  void _performSearch(String query) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<TaskBloc>().add(SearchTasksEvent(query));
      } else {
        context.read<TaskBloc>().add(const ClearSearchEvent());
      }
    });
  }

  List<Task> _getFilteredTasks(List<Task> allTasks) {
    return allTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        elevation: 0,
        actions: [
          // Expired Tasks Badge
          FutureBuilder<int>(
            future: getIt<ExpiredTasksCheckerService>().getExpiredTasksCount(),
            builder: (context, snapshot) {
              final expiredCount = snapshot.data ?? 0;
              if (expiredCount == 0) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () {
                    // Switch to expired filter
                    setState(() {
                      _currentFilter = 'expired';
                    });
                    context.read<TaskBloc>().add(
                          const LoadExpiredTasksEvent(),
                        );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$expiredCount',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: Opacity(
                          opacity: value,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: const Text('Loading tasks...'),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          if (state is TasksEmpty) {
            return _buildEmptyState(
              icon: Icons.task_alt,
              title: 'No tasks found',
              subtitle: 'Tasks assigned to you will appear here',
            );
          }

          if (state is TasksLoaded || state is TaskRefreshing) {
            final tasks = state is TasksLoaded
                ? state.tasks
                : (state as TaskRefreshing).currentTasks;
            final hasMore = state is TasksLoaded
                ? state.hasMore
                : (state as TaskRefreshing).hasMore;

            _filteredTasks = _getFilteredTasks(tasks);

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<TaskBloc>()
                    .add(const LoadMyTasksEvent(isRefresh: true));
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Column(
                children: [
                  // Sync Status Indicator with Animation
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _headerController,
                      curve: Curves.easeOut,
                    )),
                    child: const SyncStatusIndicator(),
                  ),

                  // Animated Search Bar
                  _buildAnimatedSearchBar(),

                  // Filter Chips
                  _buildFilterChips(),

                  // Task Count Info
                  _buildTaskCountInfo(hasMore),

                  // Task List
                  Expanded(
                    child: _filteredTasks.isEmpty
                        ? _buildEmptyState(
                            icon: Icons.search_off,
                            title: _searchController.text.isNotEmpty
                                ? 'No tasks match your search'
                                : 'No tasks in this filter',
                            subtitle: _searchController.text.isNotEmpty
                                ? 'Try a different search term'
                                : 'Apply a different filter to see tasks',
                          )
                        : _buildAnimatedTaskList(hasMore),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.easeInOut,
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            _navigateToCreateTask(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('New Task'),
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar() {
    return FadeTransition(
      opacity: _headerController,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isSearchFocused
              ? Theme.of(context).primaryColor.withOpacity(0.15)
              : Theme.of(context).primaryColor.withOpacity(0.1),
          boxShadow: _isSearchFocused
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isSearchFocused = hasFocus;
            });
          },
          child: TextField(
            controller: _searchController,
            onChanged: _performSearch,
            decoration: InputDecoration(
              hintText: 'Search tasks by name or description...',
              prefixIcon: AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: _isSearchFocused ? 0.5 : 0,
                child: const Icon(Icons.search),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to get count for each filter
  int _getFilterCount(String filterValue, List<Task> allTasks) {
    switch (filterValue) {
      case 'all':
        return allTasks.length;
      case 'pending':
        return allTasks.where((t) => t.status.value == 'pending').length;
      case 'checked_in':
        return allTasks.where((t) => t.status.value == 'checked_in').length;
      case 'completed':
        return allTasks.where((t) => t.status.value == 'completed').length;
      case 'expired':
        return allTasks
            .where((t) =>
                t.dueDateTime.isBefore(DateTime.now()) &&
                (t.status.value == 'pending' || t.status.value == 'checked_in'))
            .length;
      default:
        return 0;
    }
  }

  Widget _buildFilterChips() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        // Get all tasks for counting
        List<Task> allTasks = [];
        if (state is TasksLoaded) {
          allTasks = state.tasks;
        } else if (state is TaskRefreshing) {
          allTasks = state.currentTasks;
        }

        return FadeTransition(
          opacity: _headerController,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _currentFilter == filter['value'];
                final count =
                    _getFilterCount(filter['value'] as String, allTasks);

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 400 + (index * 100)),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: FilterChip(
                        selected: isSelected,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              filter['icon'] as IconData,
                              size: 18,
                              color: isSelected
                                  ? Colors.white
                                  : (filter['color'] as Color),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              filter['label'] as String,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[800],
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                            if (count > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.3)
                                      : (filter['color'] as Color)
                                          .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : (filter['color'] as Color),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            _applyFilter(filter['value'] as String);
                          }
                        },
                        backgroundColor: Colors.grey[100],
                        selectedColor: filter['color'] as Color,
                        checkmarkColor: Colors.white,
                        elevation: isSelected ? 4 : 0,
                        shadowColor:
                            (filter['color'] as Color).withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? filter['color'] as Color
                                : Colors.grey[300]!,
                            width: isSelected ? 0 : 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskCountInfo(bool hasMore) {
    return FadeTransition(
      opacity: _headerController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TweenAnimationBuilder<int>(
                duration: const Duration(milliseconds: 600),
                tween: IntTween(begin: 0, end: _filteredTasks.length),
                builder: (context, value, child) {
                  return Text(
                    'Showing $value task${value != 1 ? 's' : ''}${hasMore ? ' (more available)' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTaskList(bool hasMore) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredTasks.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _filteredTasks.length) {
          return _buildLoadingIndicator();
        }

        final task = _filteredTasks[index];
        return _AnimatedTaskItem(
          key: ValueKey(task.id),
          task: task,
          index: index,
          onTap: () => _navigateToTaskDetail(context, task),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Loading more tasks...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (value * 0.2),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTaskDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(taskId: task.id),
      ),
    );
  }

  Future<void> _navigateToCreateTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskFormPage(),
      ),
    );

    if (result == true && mounted) {
      context.read<TaskBloc>().add(const LoadMyTasksEvent(isRefresh: true));
    }
  }
}

// Animated Task Item Widget
class _AnimatedTaskItem extends StatefulWidget {
  final Task task;
  final int index;
  final VoidCallback onTap;

  const _AnimatedTaskItem({
    super.key,
    required this.task,
    required this.index,
    required this.onTap,
  });

  @override
  State<_AnimatedTaskItem> createState() => _AnimatedTaskItemState();
}

class _AnimatedTaskItemState extends State<_AnimatedTaskItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 50)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _controller,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TaskCard(
              task: widget.task,
              onTap: widget.onTap,
            ),
          ),
        ),
      ),
    );
  }
}

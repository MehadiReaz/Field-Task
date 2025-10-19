import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/task.dart';
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

class _TaskListViewState extends State<TaskListView> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'all';
  List<Task> _filteredTasks = []; // Current page's filtered tasks
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final bloc = context.read<TaskBloc>();
    final state = bloc.state;

    // Trigger load more when user scrolls to 90% of the list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (state is TasksLoaded && state.hasMore) {
        // Only load more if we have more items
        bloc.add(const LoadMoreTasksEvent());
      }
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _currentFilter = filter;
    });

    // Refresh with new filter - reset pagination
    final bloc = context.read<TaskBloc>();

    if (filter == 'expired') {
      // Load expired tasks
      bloc.add(const LoadExpiredTasksEvent(useLocal: false));
    } else if (filter == 'all') {
      // Load all tasks with pagination
      bloc.add(const LoadMyTasksEvent(isRefresh: true));
    } else {
      // Load tasks by specific status
      bloc.add(LoadTasksByStatusEvent(filter));
    }
  }

  void _performSearch(String query) {
    // Cancel previous debounce timer
    _searchDebounce?.cancel();

    // Debounce with 500ms delay to avoid too many requests
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      // Only emit event if user has typed something
      if (query.isNotEmpty) {
        context.read<TaskBloc>().add(SearchTasksEvent(query));
      } else {
        // If query is empty, clear search
        context.read<TaskBloc>().add(const ClearSearchEvent());
      }
    });
  }

  List<Task> _getFilteredTasks(List<Task> allTasks) {
    // All filtering is now done server-side or via BLoC events
    // This method can be simplified or removed in future refactoring
    return allTasks;
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'pending':
        return 'Pending';
      case 'checked_in':
        return 'Checked In';
      case 'completed':
        return 'Completed';
      case 'expired':
        return 'Expired';
      case 'all':
      default:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              _applyFilter(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.list, size: 20),
                    SizedBox(width: 8),
                    Text('All Tasks'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pending',
                child: Row(
                  children: [
                    Icon(Icons.pending_actions, size: 20, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Pending'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'checked_in',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Checked In'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 20, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Completed'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'expired',
                child: Row(
                  children: [
                    Icon(Icons.warning, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Expired (Overdue)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasksEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tasks assigned to you will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            );
          }

          if (state is TasksLoaded || state is TaskRefreshing) {
            final tasks = state is TasksLoaded
                ? state.tasks
                : (state as TaskRefreshing).currentTasks;
            final hasMore = state is TasksLoaded
                ? state.hasMore
                : (state as TaskRefreshing).hasMore;

            // Apply filters to tasks
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
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _performSearch,
                      decoration: InputDecoration(
                        hintText: 'Search tasks by name or description...',
                        prefixIcon: const Icon(Icons.search),
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

                  // Task Count and Filter Info
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Showing ${_filteredTasks.length} task${_filteredTasks.length != 1 ? 's' : ''}${hasMore ? ' (more available)' : ''}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_currentFilter != 'all')
                          Chip(
                            label: Text(_getFilterDisplayName(_currentFilter)),
                            onDeleted: () => _applyFilter('all'),
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                      ],
                    ),
                  ),

                  // Task List with Server-Side Pagination
                  Expanded(
                    child: _filteredTasks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isNotEmpty
                                      ? 'No tasks match your search'
                                      : 'No tasks in this filter',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount:
                                _filteredTasks.length + (hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              // Loading indicator at the bottom when there are more items
                              if (index == _filteredTasks.length) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Loading more tasks...',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final task = _filteredTasks[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TaskCard(
                                  task: task,
                                  onTap: () =>
                                      _navigateToTaskDetail(context, task),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateTask(context),
        child: const Icon(Icons.add),
        tooltip: 'Create New Task',
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

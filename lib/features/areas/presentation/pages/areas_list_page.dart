import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/presentation/bloc/task_event.dart';
import '../../../tasks/presentation/bloc/task_state.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../../../tasks/presentation/pages/task_detail_page.dart';

class AreasListPage extends StatefulWidget {
  const AreasListPage({super.key});

  @override
  State<AreasListPage> createState() => _AreasListPageState();
}

class _AreasListPageState extends State<AreasListPage> {
  late ScrollController _scrollController;
  String _currentFilter = 'completed';
  late TaskBloc _taskBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Initialize bloc early
    _taskBloc = getIt<TaskBloc>()
      ..add(const LoadMyTasksEvent(
        status: 'completed',
        showExpiredOnly: false,
      ));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = _taskBloc.state;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (state is TasksLoaded && state.hasMore) {
        _loadMoreWithCurrentFilter();
      }
    }
  }

  void _loadMoreWithCurrentFilter() {
    String? status;
    bool showExpiredOnly = false;

    if (_currentFilter == 'expired') {
      status = 'expired';
      showExpiredOnly = true;
    } else if (_currentFilter != 'all') {
      status = _currentFilter;
    }

    _taskBloc.add(LoadMoreTasksEvent(
      status: status,
      showExpiredOnly: showExpiredOnly,
    ));
  }

  void _applyFilter(String filter) {
    setState(() {
      _currentFilter = filter;
    });

    String? status;
    bool showExpiredOnly = false;

    if (filter == 'expired') {
      status = 'expired';
      showExpiredOnly = true;
    } else if (filter != 'all') {
      status = filter;
    }

    _taskBloc.add(LoadMyTasksEvent(
      isRefresh: true,
      status: status,
      showExpiredOnly: showExpiredOnly,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _taskBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Completed & Expired Tasks'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              onSelected: _applyFilter,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'all',
                  child: Text('All Tasks'),
                ),
                const PopupMenuItem(
                  value: 'completed',
                  child: Text('Completed'),
                ),
                const PopupMenuItem(
                  value: 'expired',
                  child: Text('Expired'),
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
                      _currentFilter == 'completed'
                          ? 'No completed tasks yet'
                          : _currentFilter == 'expired'
                              ? 'No expired tasks'
                              : 'No tasks available',
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

              return RefreshIndicator(
                onRefresh: () async {
                  _applyFilter(_currentFilter);
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: Column(
                  children: [
                    // Task count info
                    if (tasks.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Showing ${tasks.length} task${tasks.length != 1 ? 's' : ''}${hasMore ? ' (more available)' : ''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            if (_currentFilter != 'all')
                              Chip(
                                label: Text(_currentFilter.toUpperCase()),
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                                labelStyle: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    // Task list
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: tasks.length + (hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == tasks.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
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

                          final task = tasks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TaskCard(
                              task: task,
                              onTap: () => _navigateToTaskDetail(context, task),
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
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../injection_container.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/presentation/bloc/task_event.dart';
import '../../../tasks/presentation/pages/task_list_page.dart';
import '../../../tasks/presentation/pages/history_page.dart';
import '../../../sync/presentation/bloc/sync_bloc.dart';
import '../../../sync/presentation/bloc/sync_state.dart';
import 'dashboard_page.dart';
import 'menu_page.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  late PageController _pageController;
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> _onWillPop() async {
    // Only apply double-tap-to-exit on the first tab (Dashboard)
    if (_currentIndex != 0) {
      // If not on dashboard, navigate back to dashboard
      _onNavBarTapped(0);
      return false;
    }

    final now = DateTime.now();
    final isWarning = _lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2);

    if (isWarning) {
      _lastPressedAt = now;
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe
          children: [
            // Dashboard
            BlocProvider(
              create: (context) =>
                  getIt<TaskBloc>()..add(const LoadMyTasksEvent()),
              child: const DashboardPage(),
            ),

            // Tasks
            BlocProvider(
              create: (context) =>
                  getIt<TaskBloc>()..add(const LoadMyTasksEvent()),
              child: const TaskListView(),
            ),

            // History
            BlocProvider(
              create: (context) => getIt<TaskBloc>()
                ..add(const LoadTasksByStatusEvent('completed')),
              child: const HistoryPage(),
            ),

            // Menu (replaces Profile)
            const MenuPage(),
          ],
        ),
        bottomNavigationBar: BlocBuilder<SyncBloc, SyncState>(
          builder: (context, syncState) {
            final pendingCount = syncState is SyncIdle
                ? syncState.pendingCount
                : syncState is SyncInProgress
                    ? syncState.queueCount
                    : 0;

            return BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onNavBarTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 8,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                  tooltip: 'Overview',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.task_alt),
                  label: 'Tasks',
                  tooltip: 'My Tasks',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History',
                  tooltip: 'Task History',
                ),
                BottomNavigationBarItem(
                  icon: pendingCount > 0
                      ? Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.menu_rounded),
                            Positioned(
                              right: -6,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  pendingCount > 9 ? '9+' : '$pendingCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Icon(Icons.menu_rounded),
                  label: 'Menu',
                  tooltip: 'Menu & Settings',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

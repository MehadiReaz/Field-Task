import 'dart:async';
import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget child;
  final ConnectivityService connectivityService;

  const ConnectivityBanner({
    super.key,
    required this.child,
    required this.connectivityService,
  });

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  StreamSubscription<ConnectivityStatus>? _subscription;
  ConnectivityStatus? _currentStatus;
  ConnectivityStatus? _previousStatus;
  bool _showBanner = false;
  Timer? _hideTimer;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _subscription =
        widget.connectivityService.statusStream.listen(_onStatusChanged);
  }

  void _onStatusChanged(ConnectivityStatus status) {
    setState(() {
      _previousStatus = _currentStatus;
      _currentStatus = status;
    });

    _hideTimer?.cancel();

    if (status == ConnectivityStatus.offline) {
      // Show offline banner persistently
      setState(() => _showBanner = true);
      _animationController.forward();
    } else if (_previousStatus == ConnectivityStatus.offline) {
      // Coming back online - show briefly then hide
      setState(() => _showBanner = true);
      _animationController.forward();

      _hideTimer = Timer(const Duration(seconds: 3), () {
        _animationController.reverse().then((_) {
          if (mounted) {
            setState(() => _showBanner = false);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _hideTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showBanner && _currentStatus != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                child: _ConnectivityStatusBar(
                  status: _currentStatus!,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ConnectivityStatusBar extends StatelessWidget {
  final ConnectivityStatus status;

  const _ConnectivityStatusBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOffline = status == ConnectivityStatus.offline;

    return Material(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isOffline ? Colors.grey[800] : Colors.green[700],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOffline ? Icons.cloud_off : Icons.cloud_done,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isOffline ? 'You\'re offline' : 'Back online',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

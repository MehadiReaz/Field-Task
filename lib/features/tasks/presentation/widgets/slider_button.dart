import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:vibration/vibration.dart';

/// A customizable slider button widget with swipe-to-confirm functionality.
///
/// This widget provides a sliding button that requires the user to swipe
/// to confirm an action, commonly used for critical operations like
/// logout, delete, or power off.
class SliderButtonWidget extends StatefulWidget {
  /// Custom child widget to display inside the slider button.
  final Widget? child;

  /// Border radius for the button corners.
  final double radius;

  /// Height of the widget container.
  final double height;

  /// Width of the widget container.
  final double width;

  /// Size of the draggable button.
  final double buttonSize;

  /// Background color of the slider track.
  final Color backgroundColor;

  /// Base color for shimmer effect.
  final Color baseColor;

  /// Highlighted color for shimmer effect.
  final Color highlightedColor;

  /// Color of the draggable button.
  final Color buttonColor;

  /// Label text displayed on the slider.
  final Text? label;

  /// Alignment of the label within the container.
  final Alignment alignLabel;

  /// Shadow effect for the button.
  final BoxShadow boxShadow;

  /// Icon displayed on the draggable button.
  final Widget icon;

  /// Callback function executed when slider is completed.
  /// Returns true if the action was successful and the slider should be dismissed,
  /// false if the action was cancelled and the slider should remain visible.
  final Future<bool> Function() action;

  /// Enable or disable shimmer animation effect.
  final bool shimmer;

  /// Whether the widget should be removed from tree after completion.
  final bool dismissible;

  /// Enable or disable haptic vibration feedback.
  final bool vibrationFlag;

  /// Threshold percentage (0.0-1.0) for completing the slide action.
  /// e.g., 0.8 means user must drag 80% to complete.
  final double dismissThresholds;

  /// Disable the slider button interaction.
  final bool disable;

  /// Set text direction (true for LTR, false for RTL).
  final bool isLtr;

  /// Optional callback triggered when the user first touches the slider
  /// (before dragging). Useful for prefetching async work (like location)
  /// so the confirmation step can complete faster.
  final Future<void> Function()? onDragStart;

  const SliderButtonWidget({
    super.key,
    required this.action,
    this.radius = 100,
    this.boxShadow = const BoxShadow(
      color: Colors.black26,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    this.child,
    this.isLtr = true,
    this.vibrationFlag = true,
    this.shimmer = true,
    this.height = 70,
    this.buttonSize = 60,
    this.width = 250,
    this.alignLabel = const Alignment(0.0, 0),
    this.backgroundColor = const Color(0xffe0e0e0),
    this.baseColor = Colors.black87,
    this.buttonColor = Colors.white,
    this.highlightedColor = Colors.white,
    this.label,
    this.icon = const Icon(
      Icons.power_settings_new,
      color: Colors.red,
      size: 30.0,
    ),
    this.dismissible = true,
    this.dismissThresholds = 1.0,
    this.disable = false,
    this.onDragStart,
  })  : assert(buttonSize <= height,
            'Button size must be less than or equal to height'),
        assert(dismissThresholds >= 0.0 && dismissThresholds <= 1.0,
            'Dismiss threshold must be between 0.0 and 1.0');

  @override
  State<SliderButtonWidget> createState() => _SliderButtonWidgetState();
}

class _SliderButtonWidgetState extends State<SliderButtonWidget> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible && widget.dismissible) {
      return const SizedBox.shrink();
    }

    return _buildSliderControl();
  }

  Widget _buildSliderControl() {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.disable ? Colors.grey.shade700 : widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      alignment: Alignment.centerLeft,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Label with optional shimmer effect
          _buildLabel(),

          // Draggable button or disabled state
          widget.disable ? _buildDisabledButton() : _buildDraggableButton(),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    if (widget.label == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: widget.alignLabel,
      child: widget.shimmer && !widget.disable
          ? Shimmer(
              color: widget.highlightedColor,
              child: widget.label!,
            )
          : widget.label,
    );
  }

  Widget _buildDisabledButton() {
    return Tooltip(
      message: 'Button is disabled',
      verticalOffset: 50,
      child: _buildButtonContainer(
        isInteractive: false,
      ),
    );
  }

  Widget _buildDraggableButton() {
    return Dismissible(
      key: Key('slider_button_${widget.hashCode}'),
      direction: widget.isLtr
          ? DismissDirection.startToEnd
          : DismissDirection.endToStart,
      dismissThresholds: {
        widget.isLtr
            ? DismissDirection.startToEnd
            : DismissDirection.endToStart: widget.dismissThresholds,
      },
      // confirmDismiss lets us run an async check (show dialog, run action)
      // and decide whether to actually dismiss the widget. This avoids the
      // "A dismissed Dismissible widget is still part of the tree" assertion
      // because the Dismissible will only be dismissed if this returns true
      // and then onDismissed can immediately remove it from the tree.
      confirmDismiss: (direction) async {
        try {
          final shouldDismiss = await widget.action();

          // Provide vibration feedback for successful confirmation
          if (widget.vibrationFlag && shouldDismiss) {
            _triggerVibration();
          }

          // Allow the Dismissible to be removed from the tree only when the
          // action succeeded and the widget is configured to be dismissible.
          return shouldDismiss && widget.dismissible;
        } catch (e) {
          return false;
        }
      },
      onDismissed: (direction) {
        // Remove the Dismissible from the tree immediately as required by
        // the framework when a Dismissible is dismissed.
        setState(() {
          _isVisible = false;
        });
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          try {
            widget.onDragStart?.call();
          } catch (e) {
            // ignore
          }
        },
        child: _buildButtonContainer(
          isInteractive: true,
        ),
      ),
    );
  }

  Widget _buildButtonContainer({required bool isInteractive}) {
    return Container(
      width: widget.width - widget.height,
      height: widget.height,
      alignment: widget.isLtr ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.only(
        left: widget.isLtr ? (widget.height - widget.buttonSize) / 2 : 0,
        right: !widget.isLtr ? (widget.height - widget.buttonSize) / 2 : 0,
      ),
      child: widget.child ?? _buildDefaultButton(isInteractive),
    );
  }

  Widget _buildDefaultButton(bool isInteractive) {
    return Container(
      height: widget.buttonSize,
      width: widget.buttonSize,
      decoration: BoxDecoration(
        boxShadow: [widget.boxShadow],
        color: isInteractive ? widget.buttonColor : Colors.grey,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: Center(child: widget.icon),
    );
  }

  

  Future<void> _triggerVibration() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: 200);
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
  }
}

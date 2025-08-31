import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FakeBlur extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final Color? overlay;

  const FakeBlur({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.overlay,
  });

  @override
  State<FakeBlur> createState() => _FakeBlurState();
}

class _FakeBlurState extends State<FakeBlur> {
  final GlobalKey _containerKey = GlobalKey();
  Offset _offsetInScaffoldBody = Offset.zero;
  Size _scaffoldBodySize = Size.zero;
  ScrollPosition? _scrollPosition;

  void _updateMetrics() {
    if (!mounted) return;

    final renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null && renderBox.hasSize) {
      try {
        // Get screen dimensions
        final screenSize = MediaQuery.of(context).size;
        final statusBarHeight = MediaQuery.of(context).viewPadding.top;

        // Get the actual app bar height from the current scaffold
        double appBarHeight = 0;
        try {
          final scaffoldState = Scaffold.of(context);
          appBarHeight = scaffoldState.appBarMaxHeight ?? 0;
        } catch (e) {
          // No scaffold found, app bar height remains 0
        }

        // In your BackgroundScaffold, the background image is in the body area
        // So it covers: screen width x (screen height - status bar - app bar)
        final bodyHeight = screenSize.height - statusBarHeight - appBarHeight;
        final newScaffoldBodySize = Size(screenSize.width, bodyHeight);

        // Get this widget's global position
        final containerGlobalOffset = renderBox.localToGlobal(Offset.zero);

        // The body (where background image starts) begins at statusBarHeight + appBarHeight
        final bodyStartY = statusBarHeight + appBarHeight;

        // Calculate offset relative to the body start (where your background image begins)
        final newOffsetInScaffoldBody = Offset(
          containerGlobalOffset.dx, // x position relative to screen left
          containerGlobalOffset.dy -
              bodyStartY, // y position relative to body start
        );

        // Always update if values changed
        if (_offsetInScaffoldBody != newOffsetInScaffoldBody ||
            _scaffoldBodySize != newScaffoldBodySize) {
          if (mounted) {
            setState(() {
              _offsetInScaffoldBody = newOffsetInScaffoldBody;
              _scaffoldBodySize = newScaffoldBodySize;
            });
          }
        }
      } catch (e) {
        debugPrint('Error updating FakeBlur metrics: $e');
        // Fallback to basic screen dimensions
        if (mounted) {
          final screenSize = MediaQuery.of(context).size;
          setState(() {
            _scaffoldBodySize = screenSize;
            _offsetInScaffoldBody = Offset.zero;
          });
        }
      }
    }
  }

  void _attachScrollListener() {
    if (_scrollPosition != null || !mounted) return;

    final ScrollableState? scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      _scrollPosition = scrollable.position;
      _scrollPosition!.addListener(_updateMetrics);
    }
  }

  void _detachScrollListener() {
    _scrollPosition?.removeListener(_updateMetrics);
    _scrollPosition = null;
  }

  @override
  void initState() {
    super.initState();
    // Initialize with screen size as fallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final screenSize = MediaQuery.of(context).size;
        setState(() {
          _scaffoldBodySize = screenSize;
        });
        _updateMetrics();
        _attachScrollListener();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _updateMetrics();
      _attachScrollListener();
    });
  }

  @override
  void dispose() {
    _detachScrollListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The child widget with key - this determines our actual size and position
        Container(key: _containerKey),

        // Blur background positioned behind child and clipped to child's bounds
        if (_scaffoldBodySize.width > 0 && _scaffoldBodySize.height > 0)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Stack(
                children: [
                  Positioned(
                    left: -_offsetInScaffoldBody.dx,
                    top: -_offsetInScaffoldBody.dy,
                    child: SizedBox(
                      width: _scaffoldBodySize.width,
                      height: _scaffoldBodySize.height,
                      child: Image.asset(
                        'lib/assets/img/background_blur.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint(
                            'Error loading background_blur.jpg: $error',
                          );
                          return Container(color: Colors.white30);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Optional semi-transparent overlay
        if (widget.overlay != null)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Container(color: widget.overlay!),
            ),
          ),

        // Child content on top
        ClipRRect(borderRadius: widget.borderRadius, child: widget.child),
      ],
    );
  }
}

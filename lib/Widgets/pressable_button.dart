import 'package:flutter/material.dart';

/// Finom, visszafogott "press" animációs gomb.
/// Használat:
/// PressableButton(
///   onPressed: () => print('clicked'),
///   child: const Text('Login'),
/// );
class PressableButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final Duration duration;
  final double pressedScale;
  final double elevation;
  final double pressedElevation;
  final Color? backgroundColor;

  const PressableButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.duration = const Duration(milliseconds: 120),
    this.pressedScale = 0.985,
    this.elevation = 6.0,
    this.pressedElevation = 2.0,
    this.backgroundColor,
  });


  @override
  State<PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
  bool _pressed = false;

  void _handleTapDown(_) {
    setState(() => _pressed = true);
  }

  void _handleTapUp(_) {
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = widget.backgroundColor ?? theme.colorScheme.primary;

    return AnimatedPhysicalModel(
      duration: widget.duration,
      curve: Curves.easeOut,
      elevation: _pressed ? widget.pressedElevation : widget.elevation,
      shape: BoxShape.rectangle,
      shadowColor: Colors.black,
      color: Colors.white70, // Material color inside
      borderRadius: widget.borderRadius as BorderRadius,
      child: AnimatedScale(
        duration: widget.duration,
        curve: Curves.easeOut,
        scale: _pressed ? widget.pressedScale : 1.0,
        child: Material(
          color: bg,
          borderRadius: widget.borderRadius as BorderRadius,
          child: InkWell(
            borderRadius: widget.borderRadius as BorderRadius,
            overlayColor: WidgetStateProperty.all(Colors.black.withAlpha(25)),
            onTap: widget.onPressed,
            onTapDown: _handleTapDown,
            onTapCancel: _handleTapCancel,
            onTapUp: _handleTapUp,
            child: Padding(
              padding: widget.padding,
              child: DefaultTextStyle(
                style: theme.textTheme.labelLarge?.copyWith(color: Colors.white) ??
                    const TextStyle(color: Colors.white, fontSize: 16),
                child: Center(child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

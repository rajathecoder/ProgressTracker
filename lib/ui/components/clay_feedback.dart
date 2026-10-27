import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_button.dart';
import 'clay_container.dart';

/// Layout Molecule - rounded-top clay sheet with a drag handle. The standard
/// container for cell backfill, metric entry, habit editing and confirmations.
Future<T?> showClayBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  final clay = context.clay;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    // Left to the ambient theme, Material 3's ModalBottomSheetRoute supplies
    // its own default shape, elevation and a max-width constraint - stated
    // explicitly here so the sheet is always flush with the screen edges and
    // bottom, with our own DecoratedBox as the only thing drawing a shape.
    elevation: 0,
    shape: const RoundedRectangleBorder(),
    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: clay.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: clay.surfaceBorder)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: clay.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Flexible(child: builder(context)),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Layout Molecule - modal clay card for destructive confirmations.
Future<bool> showClayDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: ClayContainer(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: ClayButton(
                    label: cancelLabel,
                    compact: true,
                    expand: true,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClayButton(
                    label: confirmLabel,
                    compact: true,
                    expand: true,
                    primary: true,
                    destructive: destructive,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}

/// Feedback Molecule - floating clay toast with an Undo action.
/// "Every destructive or XP-affecting action surfaces one."
void showClaySnackBar(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
  IconData? icon,
  Color? accent,
}) {
  final clay = context.clay;
  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 4),
      content: ClayContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        radius: 18,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: accent ?? clay.accentFrost),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
                child: Text(
                  actionLabel.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: clay.accentFrost,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// Layout Molecule - illustration + message + optional CTA.
class ClayEmptyState extends StatelessWidget {
  const ClayEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayContainer(
              state: ClaySurfaceState.recessed,
              radius: 32,
              width: 96,
              height: 96,
              alignment: Alignment.center,
              child: Icon(icon, size: 40, color: clay.textSecondary),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: clay.textSecondary),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 22),
              ClayButton(
                label: actionLabel!,
                primary: true,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Feedback Atom - shimmering clay placeholder for the first frame while Isar
/// resolves. Prevents layout jump on the matrix.
class ClaySkeleton extends StatefulWidget {
  const ClaySkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.radius = 12,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<ClaySkeleton> createState() => _ClaySkeletonState();
}

class _ClaySkeletonState extends State<ClaySkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    if (clay.reduceMotion) {
      return ClayContainer(
        state: ClaySurfaceState.recessed,
        radius: widget.radius,
        width: widget.width,
        height: widget.height,
        child: const SizedBox.shrink(),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Opacity(
        opacity: 0.4 + _controller.value * 0.35,
        child: ClayContainer(
          state: ClaySurfaceState.recessed,
          radius: widget.radius,
          width: widget.width,
          height: widget.height,
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Layout Molecule - standardised section header with optional badge + action.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.badge,
    this.actionLabel,
    this.onAction,
    this.trailing,
  });

  final String title;
  final String? badge;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            ClayContainer(
              state: ClaySurfaceState.recessed,
              radius: 10,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Text(
                badge!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: clay.accentFrost,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const Spacer(),
          ?trailing,
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: clay.accentFrost,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

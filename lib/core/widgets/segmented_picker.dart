import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';

/// Options on a sand track; the selected one is sun with an outline.
class SegmentedPicker<T> extends StatelessWidget {
  const SegmentedPicker({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  /// Value → visible label.
  final Map<T, String> options;
  final T value;
  final ValueChanged<T> onChanged;

  /// Group label for screen readers.
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final duration =
        AppMotion.reduce(context) ? AppMotion.reduced : AppMotion.select;
    final entries = options.entries.toList();
    return Semantics(
      label: label,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: boldBox(
          fill: t.sand,
          outline: t.outline,
          radius: AppShape.rControlSm,
        ),
        child: Row(
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: _Segment(
                  label: entries[i].value,
                  selected: entries[i].key == value,
                  duration: duration,
                  onTap: () => onChanged(entries[i].key),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.duration,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: duration,
          height: AppSizes.minTouch,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.sun : Colors.transparent,
            borderRadius: BorderRadius.circular(AppShape.rTiny),
            border: Border.all(
              color: selected ? t.outline : Colors.transparent,
              width: AppShape.stroke,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.body(13,
                weight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? AppColors.ink : t.text),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

/// 44 px accent circle; selected = 3 px border + gap + ink ring (13).
class AccentSwatch extends StatelessWidget {
  const AccentSwatch({
    super.key,
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
                color: t.outline, width: selected ? 3 : AppShape.stroke),
            boxShadow: selected
                ? [
                    BoxShadow(color: t.outline, spreadRadius: 5.5),
                    BoxShadow(color: t.surface, spreadRadius: 3),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}

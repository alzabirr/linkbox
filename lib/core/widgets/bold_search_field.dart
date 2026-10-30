import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import 'app_icon.dart';
import 'icon_box.dart';

/// 52 high search bar. Idle: plain outline. Focused: small hard shadow and a
/// pink clear button while there is text.
class BoldSearchField extends StatefulWidget {
  const BoldSearchField({
    super.key,
    required this.hint,
    required this.clearLabel,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  final String hint;

  /// Tooltip for the clear button.
  final String clearLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// For the Home bar, which only opens the search page.
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;

  @override
  State<BoldSearchField> createState() => _BoldSearchFieldState();
}

class _BoldSearchFieldState extends State<BoldSearchField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focus = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_rebuild);
    _controller.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_rebuild);
    _controller.removeListener(_rebuild);
    if (widget.focusNode == null) _focus.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final focused = _focus.hasFocus;
    final hasText = _controller.text.isNotEmpty;
    final style = AppText.body(16,
        weight: hasText ? FontWeight.w600 : FontWeight.w400, color: t.text);

    return AnimatedContainer(
      duration: AppMotion.press,
      height: AppSizes.searchHeight,
      padding: EdgeInsets.only(left: 16, right: hasText ? 6 : 16),
      decoration: boldBox(
        fill: t.surface,
        outline: t.outline,
        radius: AppShape.rControl,
        shadow: focused ? t.shadowOf(AppShadows.offSm) : null,
      ),
      child: Row(
        children: [
          AppIcon(AppIcons.search, size: 20, color: t.text),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              onTap: widget.onTap,
              onChanged: widget.onChanged,
              style: style,
              cursorColor: t.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: AppText.body(16,
                    weight: FontWeight.w400, color: t.muted),
              ),
            ),
          ),
          if (hasText)
            IconBox(
              icon: AppIcons.close,
              tooltip: widget.clearLabel,
              size: 38,
              radius: AppShape.rTiny,
              iconSize: 16,
              fill: AppColors.pink,
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
              },
            ),
        ],
      ),
    );
  }
}

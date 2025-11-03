import 'package:flutter/material.dart';

class SlidingButton extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final Color backgroundColor;
  final Color selectedColor;
  final Color textColor;
  final Color selectedTextColor;

  const SlidingButton({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.backgroundColor = const Color(0xfff5f1e7),
    this.selectedColor = Colors.white,
    this.textColor = Colors.black54,
    this.selectedTextColor = Colors.black,
  });

  @override
  State<SlidingButton> createState() =>
      _SlidingButtonState();
}

class _SlidingButtonState extends State<SlidingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(SlidingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabCount = widget.tabs.length;
    final segmentWidth = MediaQuery.of(context).size.width / tabCount - 32;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(
              widget.selectedIndex == 0 ? -1 : 1,
              0,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: segmentWidth,
              height: 40,
              decoration: BoxDecoration(
                color: widget.selectedColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: List.generate(widget.tabs.length, (index) {
              final bool isSelected = index == widget.selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTabChanged(index),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? widget.selectedTextColor
                            : widget.textColor,
                        fontSize: 14,
                      ),
                      child: Text(widget.tabs[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String labelText;
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final TextEditingController? controller;
  final double borderRadius;
  final Widget? hint;
  final TextStyle? textStyle;
  final BoxDecoration? dropdownDecoration;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.controller,
    this.validator,
    this.borderRadius = 10.0,
    this.hint,
    this.textStyle,
    this.dropdownDecoration,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: Colors.white,
              boxShadow: _isExpanded
                  ? [BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2)]
                  : [],
            ),
            child: DropdownButtonFormField<T>(
              value: widget.value,
              decoration: InputDecoration(
                labelText: widget.labelText,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              hint: widget.hint ?? const Icon(Icons.keyboard_arrow_down),
              style: widget.textStyle ?? const TextStyle(color: Colors.black, fontSize: 16),
              dropdownColor: widget.dropdownDecoration?.color ?? Colors.white,
              items: widget.items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item.toString()),
                );
              }).toList(),
              onChanged: widget.onChanged,
              validator: widget.validator,
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isExpanded ? 1.0 : 0.0,
          child: SizedBox(height: _isExpanded ? 200 : 0),
        ),
      ],
    );
  }
}

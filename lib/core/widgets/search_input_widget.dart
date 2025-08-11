import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

/// A search input widget inspired by the ChickFit Figma design.
///
/// This widget wraps a [TextField] inside a stylised container to
/// approximate the look and feel of the search component shown in the
/// provided Figma link. A search icon is displayed on the left and a
/// clear (X) icon is conditionally displayed on the right when text
/// is present in the field. Consumers can listen for text changes via
/// the [onChanged] callback or supply an external [TextEditingController]
/// to manage the field's value.
class SearchInput extends StatefulWidget {
  /// Creates a search input.
  const SearchInput({
    super.key,
    this.hintText,
    this.onChanged,
    this.controller,
  });

  /// Placeholder text displayed when the field is empty.
  final String? hintText;

  /// Callback fired whenever the text in the field changes.
  final ValueChanged<String>? onChanged;

  /// A custom controller to manage the text field's value. When omitted
  /// a controller will be created internally.
  final TextEditingController? controller;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to the controller so we can rebuild when the text changes.
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    // Only dispose the controller if it was created internally.
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged() {
    // Trigger a rebuild to show/hide the clear icon when the text changes.
    setState(() {});
    // Forward the value to any external callback.
    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        isDense: false,
        prefixIcon: Icon(
          Symbols.search,
          size: 24.ds,
          color: AssetColors.inputLabelColor,
        ),
        fillColor: AssetColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Set radius here
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: AssetColors.inputLabelColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: AssetColors.primaryMain),
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  _controller.clear();
                  // Ensure onChanged callback fires when clearing the text.
                  widget.onChanged?.call('');
                },
                child: Icon(
                  Icons.clear,
                  size: 20,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                ),
              )
            : const SizedBox(),
        hintText: widget.hintText ?? 'Search',
        isCollapsed: false,
      ),
      style: TextStyle(
        backgroundColor: AssetColors.white,
      ),
    );
  }
}

/// Example usage of [SearchInput] inside a simple scaffold.
///
/// This example shows how to integrate the search input into a screen and
/// handle updates as the user types. To try it out, embed the `SearchScreen`
/// as the home of your `MaterialApp`.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find your workout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SearchInput(
              hintText: 'Search exercises',
              onChanged: (value) {
                // Perform search or filter your list here.
                debugPrint('Search query: $value');
              },
            ),
            // Add the rest of your page content below...
          ],
        ),
      ),
    );
  }
}

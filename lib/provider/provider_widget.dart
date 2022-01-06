import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider
class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final ValueWidgetBuilder<T> builder;
  final Widget child;
  final Function(T model) onModelReady;
  final bool autoDispose;

  const ProviderWidget({
    Key key,
    @required this.model,
    @required this.builder,
    this.child,
    this.onModelReady,
    this.autoDispose = true,
  }) : super(key: key);

  @override
  _ProviderWidget<T> createState() => _ProviderWidget<T>();
}

class _ProviderWidget<T extends ChangeNotifier> extends State<ProviderWidget<T>> {
  T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

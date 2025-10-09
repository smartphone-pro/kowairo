import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  /// The AsyncValue to be rendered
  final AsyncValue<T> value;

  /// The widget to be built when the data is available
  final Widget Function(T data) data;

  /// The widget to be built when loading.
  /// Defaults to a centered CircularProgressIndicator.
  final Widget Function()? loading;

  /// The widget to be built on error.
  /// Defaults to a centered error message.
  final Widget Function(Object error, StackTrace stackTrace)? error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: loading ?? () => const Center(child: CircularProgressIndicator()),
      error: error ??
              (e, st) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'エラーが発生しました。\n$e',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            ),
          ),
    );
  }
}
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_index_provider.g.dart';

@riverpod
class TapIndex extends _$TapIndex {
  @override
  int build() => 0; // default tab index = 0

  void setTab(int index) => state = index;
}

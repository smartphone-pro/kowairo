import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_index_provider.g.dart';

@riverpod
class TabIndex extends _$TabIndex {
  @override
  int build() => 0; // default tab index = 0

  void setTab(int index) => state = index;
}

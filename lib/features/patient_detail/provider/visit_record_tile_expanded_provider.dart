import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visit_record_tile_expanded_provider.g.dart';

@riverpod
class VisitRecordTileExpanded extends _$VisitRecordTileExpanded {
  @override
  bool build(String recordId) {
    return false; // default collapsed
  }

  void toggle() => state = !state;
}

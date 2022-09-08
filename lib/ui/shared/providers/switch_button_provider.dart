import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwitchButtonNotifier extends StateNotifier<int> {
  // set default state to 0
  SwitchButtonNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }

  void resetIndex() {
    state = 0;
  }
}

final switchButtonFamily = StateNotifierProvider.autoDispose
    .family<SwitchButtonNotifier, int, String>(
        (ref, name) => SwitchButtonNotifier());

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:advcal/view/todo/todo_view.dart';
import 'package:advcal/view/timeline/timeline_view.dart';
import 'package:advcal/view/settings/settings.dart';
import 'package:advcal/util/notify/notify.dart';
import 'package:advcal/util/ui/alert.dart';

class Root extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> keys = ["Home", "TimeLine", "Settings"];
    List<Icon> icons = [
      Icon(Icons.home),
      Icon(Icons.timeline),
      Icon(Icons.settings),
    ];
    List<Widget> pages = [Todo(), TimeLine(), Settings()];
    final page_state = useState(0);
    List<BottomNavigationBarItem> navi_items = [];
    for (int i = 0; i < keys.length; i++) {
      navi_items.add(BottomNavigationBarItem(
        icon: icons[i],
        label: keys[i],
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(keys[page_state.value]),
      ),
      body: pages[page_state.value],
      bottomNavigationBar: BottomNavigationBar(
        items: navi_items,
        currentIndex: page_state.value,
        onTap: (index) {
          page_state.value = index;
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:advcal/model/db/todo_db.dart';
import 'package:drift/drift.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:advcal/view_model/timeline/timeline_model.dart';
import 'package:intl/intl.dart';

class TimeLine extends HookConsumerWidget {
  List<Widget> makeTimeLine(
    List<TodoItemData> todoitems,
    TimelineDataNotifier provider,
  ) {
    List<Widget> timeline = [];
    List<TodoItemData> items = provider.state;
    for (int i = 0; i < items.length; i++) {
      Widget tile = TimelineTile(
        endChild: Card(
          child: ListTile(
            title: Text(items[i].title),
            subtitle: Text(DateFormat('HH:mm').format(items[i].limitDate!)),
          ),
        ),
        isFirst: i == 0,
        isLast: i == items.length - 1,
      );
      timeline.add(tile);
    }
    return timeline;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineState = ref.watch(timelineDataProvider);

    final timelineProvider = ref.watch(timelineDataProvider.notifier);
    final datas = timelineProvider.state;
    useEffect(() {
      timelineProvider.makeLimitList(DateTime.now());
      print(timelineProvider.state);
    }, datas);

    List<Widget> timelineTiles = makeTimeLine(
      timelineProvider.state,
      timelineProvider,
    );
    return Scaffold(
      body: Center(
        child: ListView(
          children: timelineTiles,
        ),
      ),
    );
  }
}

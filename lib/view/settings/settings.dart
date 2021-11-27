import 'package:advcal/view/settings/notify/notify_setting.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class Settings extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Card(
        child: ListTile(
          title: Text('Notify Setting'),
          subtitle: Text('何時間前に通知するか設定します'),
          trailing: Icon(Icons.notifications),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return NotifySetting();
            }));
          },
        ),
      ),
    );
  }
}

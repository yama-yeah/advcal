import 'package:advcal/util/notify/notify.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:advcal/view/root.dart';

void main() {
  initial_notyfy();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // To read our provider, we can use the hook "ref.watch(".
    // This is only possible because MyApp is a HookConsumerWidget.
    //final String value = ref.watch(helloWorldProvider);
    start_listen(context);
    return MaterialApp(
      home: Root(),
    );
  }
}

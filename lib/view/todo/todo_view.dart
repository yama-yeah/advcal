import 'package:advcal/model/db/todo_db.dart';
import 'package:advcal/model/freezed/todo/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:advcal/view_model/todo/todo_provider.dart';
import 'package:advcal/util/notify/notify.dart';
import 'package:advcal/util/ui/alert.dart';

class Todo extends HookConsumerWidget {
  List<Widget> _buildTodoList(
      List<TodoItemData> todoItemList, TodoDatabaseNotifier db) {
    List<Widget> list = [];
    for (TodoItemData item in todoItemList) {
      Widget tile = Slidable(
        child: ListTile(
          title: Text(item.title),
          subtitle:
              Text(item.limitDate == null ? "" : item.limitDate.toString()),
        ),
        endActionPane: ActionPane(
          //スライドしたときに表示されるボタン
          motion: DrawerMotion(),
          //スライドしたときのアニメーション
          children: [
            SlidableAction(
              flex: 1,
              //長さ
              onPressed: (_) {
                //押された時の処理
                db.deleteData(item);
              },
              icon: Icons.delete,
              //アイコン
            ),
            SlidableAction(
              flex: 1,
              onPressed: (_) {
                TodoItemData data = TodoItemData(
                  id: item.id,
                  title: item.title,
                  description: item.description,
                  limitDate: item.limitDate,
                  isNotify: !item.isNotify,
                );
                db.updateData(data);
              },
              icon: item.isNotify
                  ? Icons.notifications_off
                  : Icons.notifications_active,
            ),
          ],
        ),
      );
      list.add(tile);
      //listにtileを追加
    }
    return list;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoDatabaseProvider);
    //Providerの状態が変化したさいに再ビルドします
    final todoProvider = ref.watch(todoDatabaseProvider.notifier);
    //Providerのメソッドや値を取得します
    final rebuild = useState(false);
    //bottomsheetが閉じた際に再ビルドするために使用します。
    List<TodoItemData> todoItems = todoProvider.state.todoItems;
    //Providerが保持しているtodoItemsを取得します。
    useEffect(() {
      make_notify_all();
    }, [todoItems]);
    List<Widget> tiles = _buildTodoList(todoItems, todoProvider);
    TempTodoItemData temp = TempTodoItemData();
    showAlert(context);
    return Scaffold(
      body: ListView(children: tiles),
      //ListViewでtilesを表示します。
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet<void>(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (_) {
              return HookConsumer(
                //どうやら、showModalBottomSheetはcontextのrootに近い場所にあるらしく、ここで状態が変更されても辿れない(外人が言ってた)
                //showModalBottomSheetの上にHookConsumerを設置することでHookConsumerから状態の変更を感知して再ビルドする。
                builder: (context, ref, _) {
                  final submittedLimit = useState(false);
                  //DatePickerが閉じた際に再ビルドするために使用します。
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'タスク名',
                          ),
                          onChanged: (value) {
                            temp = temp.copyWith(title: value);
                          },
                          onSubmitted: (value) {
                            temp = temp.copyWith(title: value);
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '説明',
                          ),
                          onChanged: (value) {
                            temp = temp.copyWith(description: value);
                          },
                          onSubmitted: (value) {
                            //print(value);
                            temp = temp.copyWith(description: value);
                          },
                        ),
                        Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.values[0],
                            children: [
                              TableRow(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      DatePicker.showDateTimePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        onConfirm: (date) {
                                          temp = temp.copyWith(limit: date);
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.jp,
                                      ).then((value) {
                                        submittedLimit.value =
                                            !submittedLimit.value;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today),
                                        Text(temp.limit == null
                                            ? ""
                                            : temp.limit
                                                .toString()
                                                .substring(0, 10)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      todoProvider.writeData(temp);
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      child: Text('OK'),
                                      padding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ],
                    ),
                  );
                },
              );
            },
          );
          temp = TempTodoItemData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

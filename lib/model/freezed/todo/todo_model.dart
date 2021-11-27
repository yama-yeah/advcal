import 'package:advcal/model/db/todo_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';

@freezed
abstract class TodoStateData with _$TodoStateData {
  //このクラスは、DBの状態を保持するクラスです。
  factory TodoStateData({
    @Default(false) bool isLoading,
    @Default(false) bool isReadyData,
    @Default([]) List<TodoItemData> todoItems,
  }) = _TodoStateData;
}

@freezed
abstract class TempTodoItemData with _$TempTodoItemData {
  //このクラスは、DBの状態を保持するクラスです。
  factory TempTodoItemData({
    @Default('') String title,
    @Default('') String description,
    @Default(null) DateTime? limit,
    @Default(true) bool isNotify,
  }) = _TempTodoItemData;
}

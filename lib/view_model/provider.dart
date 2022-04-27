import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_app/model/db/db.dart';
import 'package:tc_app/model/todo/todo.dart';

// DBの操作を行うクラス（dbの操作にstateを絡める）

class TodoDatabaseNotifier extends StateNotifier<TodoStateData> {
  TodoDatabaseNotifier() : super(TodoStateData());

  final _db = MyDatabase(); // DBへの操作を行える

  // TempTodoItemData = 全てのデータ / TodoItemData = 個々のデータ

  // 書き込み処理
  writeData(TempTodoItemData data) async {
    TodoItemCompanion entry = TodoItemCompanion(
      title: Value(data.title),
      comment: Value(data.comment),
    );
    state = state.copyWith(isLoading: true);
    await _db.writeTodo(entry); //入力された全ての値をDBに送る
    readData();
  }

  // 更新処理
  updateData(TodoItemData data) async {
    state = state.copyWith(isLoading: true);
    await _db.updateTodo(data); //入力された個々の値をDBに送る
    readData();
  }

  // 削除処理
  deleteData(TodoItemData data) async {
    state = state.copyWith(isLoading: true);
    await _db.deleteTodo(data.id); //指定されたidを削除（カード丸ごと削除する）
    readData();
  }

  // 読み込み処理
  readData() async {
    state = state.copyWith(isLoading: true);
    final todoItems = await _db.readAllTodoData(); //全てのデータを取得する
    state = state.copyWith(
      isLoading: false,
      isReadyData: true,
      todoItems: todoItems,
    );
  }
}

// 最新のTodoの状態管理をする
final todoDatabaseProvider = StateNotifierProvider((_) {
  TodoDatabaseNotifier notiry = TodoDatabaseNotifier();
  notiry.readData();
  return notiry; //読み込み処理
});

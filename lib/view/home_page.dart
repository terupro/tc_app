import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tc_app/common/card_widget.dart';
import 'package:tc_app/model/db/db.dart';
import 'package:tc_app/model/todo/todo.dart';
import 'dart:core';
import 'package:tc_app/view_model/provider.dart';

class HomePage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TempTodoItemData temp = TempTodoItemData();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerの監視
    final _todoDatabaseProvider = ref.watch(todoDatabaseProvider);
    final _todoDatabaseNotifier = ref.watch(todoDatabaseProvider.notifier);
    List<TodoItemData> _todoItems = _todoDatabaseNotifier.state.todoItems;

    // todo全体
    List<Widget> _allCard(
      List<TodoItemData> items,
      TodoDatabaseNotifier db,
    ) {
      List<Widget> list = [];
      for (TodoItemData item in items) {
        Widget card = CardWidget(
          item: item,
          db: _todoDatabaseNotifier,
        );
        list.insert(0, card);
      }
      return list;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white.withOpacity(0.8),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add_card_sharp,
            size: 35,
          ),
          backgroundColor: Colors.grey,
          onPressed: () async {
            await _todoDatabaseNotifier.writeData(temp);
            Fluttertoast.showToast(
              msg: "カードが追加されました",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white.withOpacity(0.6),
              textColor: Colors.black54,
              fontSize: 16.0,
            );
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'T & C',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 45.0,
                    fontFamily: 'OpenSansCondensed',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _allCard(_todoItems, _todoDatabaseNotifier),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

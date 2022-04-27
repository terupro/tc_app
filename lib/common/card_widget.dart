import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_app/common/text_field_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tc_app/model/db/db.dart';
import 'package:tc_app/util/util.dart';
import 'package:tc_app/view_model/provider.dart';

class CardWidget extends ConsumerWidget {
  const CardWidget({
    Key? key,
    required this.item,
    required this.db,
  }) : super(key: key);

  final TodoItemData item;
  final TodoDatabaseNotifier db;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var edited = item;
    final _titleController = TextEditingController(text: edited.title);
    final _commentController = TextEditingController(text: edited.comment);

    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: kBorderRadius,
        ),
        child: Column(
          children: [
            TextFieldWidget(
              controller: _titleController,
              label: 'title...',
              changed: (value) {
                edited = edited.copyWith(title: value);
              },
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              controller: _commentController,
              label: 'comment...',
              inputContentPadding: const EdgeInsets.only(
                top: 15,
                right: 15,
                bottom: 100,
                left: 15,
              ),
              changed: (value) {
                edited = edited.copyWith(comment: value);
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KeyboardDismissOnTap(
                    dismissOnCapturedTaps: true,
                    child: _cardButton('削除', () async {
                      await db.deleteData(edited);
                      Fluttertoast.showToast(
                        msg: "カードが削除されました",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white.withOpacity(0.6),
                        textColor: Colors.black54,
                        fontSize: 16.0,
                      );
                    }),
                  ),
                  _cardButton('リセット', () async {
                    _titleController.text = '';
                    _commentController.text = '';
                    edited = edited.copyWith(title: _titleController.text);
                    edited = edited.copyWith(comment: _commentController.text);

                    await db.updateData(edited);
                  }),
                  KeyboardDismissOnTap(
                    dismissOnCapturedTaps: true,
                    child: _cardButton('保存', () async {
                      await db.updateData(edited);
                      Fluttertoast.showToast(
                        msg: "編集内容が保存されました",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white.withOpacity(0.6),
                        textColor: Colors.black54,
                        fontSize: 16.0,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardButton(String label, VoidCallback press) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white30,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/models/comment.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentsList extends StatefulWidget {
  CommentsList({Key? key, required this.comments}) : super(key: key);

  final List<Comment> comments;

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  final TextEditingController controller = TextEditingController();

  var _scrollController = ScrollController();

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.transparent,
              )),
          Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: Colors.grey.shade100,
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: getChildren(),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextFormField(
                        focusNode: _focusNode,
                        autofocus: true,
                        controller: controller,
                        onFieldSubmitted: (p1) {
                          setState(() {
                            widget.comments.add(Comment(
                              comment: controller.text,
                              label: session.auth.currentUser!.displayName ?? '',
                              uid: session.auth.currentUser!.uid,
                              date: DateTime.now(),
                            ));
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 100),
                            );

                            _focusNode.requestFocus();
                            controller.clear();
                          });
                        },
                      ),
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8, right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.comments.add(Comment(
                                comment: controller.text,
                                label: session.auth.currentUser!.displayName ?? '',
                                uid: session.auth.currentUser!.uid,
                                date: DateTime.now(),
                              ));
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 100),
                              );

                              _focusNode.requestFocus();
                              controller.clear();
                            });
                          },
                          child: Text("Submit"),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  getChildren() {
    List<Widget> listTiles = [];

    for (int i = 0; i < widget.comments.length; i++) {
      // listTiles.add(Card(
      //   child: ListTile(
      //     title: Text(widget.comments[i].comment, style: TextStyle(color: Colors.black)),
      //     subtitle: Text(widget.comments[i].comment, style: TextStyle(color: Colors.black)),
      //     isThreeLine: true,
      //   ),
      // ));
      listTiles.add(Padding(
        padding: EdgeInsets.only(
          left: (session.auth.currentUser!.uid != widget.comments[i].uid) ? 0 : 40,
          right: (session.auth.currentUser!.uid == widget.comments[i].uid) ? 0 : 40,
        ),
        child: Card(
          child: ListTile(
            // leading: session.auth.currentUser!.uid == widget.comments[i].uid ? Container() : null,
            title: Text(widget.comments[i].comment, style: TextStyle(color: Colors.black)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(widget.comments[i].label + " ~ " + DateFormat.yMd().add_jm().format(widget.comments[i].date))),
            ),
            // trailing: session.auth.currentUser!.uid == widget.comments[i].uid ? null : Container(),
          ),
        ),
      ));

      // Map<int, TableColumnWidth>? columnWidths;
      // if (session.auth.currentUser!.uid == widget.comments[i].uid) {
      //   if (widget.comments[i].uid == session.auth.currentUser!.uid) {
      //     columnWidths = {
      //       0: FlexColumnWidth(0),
      //       1: FlexColumnWidth(8),
      //       2: FlexColumnWidth(2),
      //     };
      //   } else {
      //     columnWidths = {
      //       0: FlexColumnWidth(2),
      //       1: FlexColumnWidth(8),
      //       2: FlexColumnWidth(0),
      //     };
      //   }

      //   var table = Row(children: [
      //     Container(),
      //     ,
      //     Container(),
      //   ]);

      // }
    }

    return listTiles;
  }
}

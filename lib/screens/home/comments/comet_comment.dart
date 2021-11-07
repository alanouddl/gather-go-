import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/Models/comment.dart';
import 'package:gather_go/screens/home/comments/comment_component.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';

class CommentCommentWidget extends StatelessWidget {
  Comment? comment;
  UesrInfo? user;
  CommentCommentWidget({this.comment, this.user});
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Commentaire de ${user?.name}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: comments == null
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    )
                  : comments.length == 0
                      ? Center(
                          child: Text("Aucun commentaire"),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (ctx, i) {
                            final comment = comments[i];
                            return CommentComponent(comment: comment);
                          },
                        )),
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 25,
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      bool commentOk = await DatabaseService().add_comment(
                          Comment(
                              id_user: NewUser.currentUser?.uid,
                              id_comment: comment?.id,
                              msg: commentController.text));
                      if (commentOk) commentController.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

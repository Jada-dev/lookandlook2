import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_tutorial/helper/constants.dart';
import 'package:tiktok_tutorial/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentController.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(comment.profilePhoto),
                          ),
                          title: Row(
                            children: [
                              Text(
                                "${comment.username}  ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.orange[700]!,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                comment.comment,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                tago.format(
                                  comment.datePublished.toDate(),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${comment.likes.length} likes',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () =>
                                commentController.likeComment(comment.id),
                            child: Icon(
                              Icons.favorite,
                              size: 25,
                              color: comment.likes
                                      .contains(authController.user.uid)
                                  ? Colors.orange[700]
                                  : Colors.white,
                            ),
                          ),
                        );
                      });
                }),
              ),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange[700]!,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange[700]!,
                      ),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () =>
                      commentController.postComment(_commentController.text),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

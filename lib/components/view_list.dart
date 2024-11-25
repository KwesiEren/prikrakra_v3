import 'package:flutter/material.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({super.key, required this.taskName, required this.taskDetail
      //required this.deleteFunction,
      });

  final String taskName;
  final String? taskDetail;

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 0,
        right: 0,
        bottom: 20,
      ),
      child: GestureDetector(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 185),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.taskName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              // Text(
              //   widget.taskDetail ?? '',
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   style: const TextStyle(color: Colors.black45, fontSize: 15),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class toDolist extends StatefulWidget {
  const toDolist(
      {super.key,
      required this.taskName,
      required this.taskCompleted,
      required this.onChanged,
      required this.taskDetail
      //required this.deleteFunction,
      });

  final String taskName;
  final String? taskDetail;
  final bool taskCompleted;
  final Function(bool?)? onChanged;

  @override
  State<toDolist> createState() => _toDolistState();
}

class _toDolistState extends State<toDolist> {
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
        child: Row(
          children: [
            Checkbox(
              activeColor: const Color.fromRGBO(19, 62, 135, 1),
              checkColor: Colors.white,
              value: widget.taskCompleted,
              onChanged: widget.onChanged,
              side: const BorderSide(color: Colors.black),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 185),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: widget.taskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: 3,
                        decorationColor: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.taskDetail ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black45, fontSize: 15),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

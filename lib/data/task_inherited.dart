import 'package:flutter/material.dart';
import 'package:introduction/components/task.dart';

class TaskInherited extends InheritedWidget {
  TaskInherited({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final List<Task> taskList = [
    Task('Aprender Flutter', 'assets/images/flutter.png', 3),
    Task('Melhorar o tempo de foco', 'assets/images/focus.png', 5),
    Task('Meditar', 'assets/images/meditate.png', 5),
    Task('Ler', 'assets/images/read.png', 0),
    Task('Inglês', 'assets/images/english.png', 2),
  ];

  void newTask(String name, String image, int difficulty) {
    taskList.add(Task(name, image, difficulty));
  }

  static TaskInherited of(BuildContext context) {
    final TaskInherited? result =
        context.dependOnInheritedWidgetOfExactType<TaskInherited>();
    assert(result != null, 'No TaskInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TaskInherited old) {
    return old.taskList.length != taskList.length;
  }
}

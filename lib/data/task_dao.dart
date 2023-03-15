import 'package:introduction/data/database.dart';
import 'package:sqflite/sqflite.dart';

import '../components/task.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT)';

  static const String _tablename = 'taskTable';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';

  save(Task newTask) async {
    print('Iniciando o save: ');
    final Database database = await getDatabase();
    var itemExists = await find(newTask.name);
    Map<String, dynamic> taskMap = toMap(newTask);
    if (itemExists.isEmpty) {
      print('A tarefa nao existia.');
      return await database.insert(_tablename, taskMap);
    } else {
      print('A tarefa ja existia!');
      return await database.update(
        _tablename,
        taskMap,
        where: '$_name = ?',
        whereArgs: [newTask.name],
      );
    }
  }

  Map<String, dynamic> toMap(Task task) {
    print('Convertendo tarefa em Map: ');
    final Map<String, dynamic> tasksMap = Map();
    tasksMap[_name] = task.name;
    tasksMap[_difficulty] = task.difficulty;
    tasksMap[_image] = task.image;
    print('Mapa de tarefas: $tasksMap');
    return tasksMap;
  }

  Future<List<Task>> findAll() async {
    print('Acessando o findAll: ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tablename);
    print('Procurando dados no bd ... encontrado: $result');
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> tasksMap) {
    print('Convertendo to list');
    final List<Task> tasks = [];
    for (Map<String, dynamic> line in tasksMap) {
      final Task task = Task(line[_name], line[_image], line[_difficulty]);
      tasks.add(task);
    }
    print('Lista de tarefas $tasks');
    return tasks;
  }

  Future<List<Task>> find(String name) async {
    print('Acessando find: ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(
      _tablename,
      where: '$_name = ?',
      whereArgs: [name],
    );
    print('Tarefa encontrada: ${toList(result)}');
    return toList(result);
  }

  delete(String name) async {
    print('Deletando tarefa: $name');
    final Database database = await getDatabase();
    return database.delete(
      _tablename,
      where: '$_name = ?',
      whereArgs: [name],
    );
  }
}

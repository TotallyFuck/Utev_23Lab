import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoItem {
  String title;
  String description;
  bool isDone;

  TodoItem(
      {required this.title, required this.description, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  static TodoItem fromMap(Map<String, dynamic> map) {
    return TodoItem(
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoItem> _todos = [];
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> todosJson = json.decode(todosString);
      setState(() {
        _todos = todosJson.map((e) => TodoItem.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString =
        json.encode(_todos.map((e) => e.toMap()).toList());
    await prefs.setString('todos', todosString);
  }

  void _addTodo(TodoItem todo) {
    setState(() {
      _todos.add(todo);
    });
    _saveTodos();
  }

  void _updateTodo(int index, TodoItem todo) {
    setState(() {
      _todos[index] = todo;
    });
    _saveTodos();
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _saveTodos();
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
    _saveTodos();
  }

  void _navigateToAddEditTodoPage({TodoItem? todo, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTodoPage(todo: todo),
      ),
    );

    if (result != null) {
      if (result == 'delete' && index != null) {
        _deleteTodo(index);
      } else if (result is TodoItem) {
        if (index != null) {
          _updateTodo(index, result);
        } else {
          _addTodo(result);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodos = _showCompleted
        ? _todos.where((todo) => todo.isDone).toList()
        : _todos.where((todo) => !todo.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: [
          IconButton(
            icon: Icon(_showCompleted ? Icons.list : Icons.check),
            onPressed: () {
              setState(() {
                _showCompleted = !_showCompleted;
              });
            },
          ),
        ],
      ),
      body: filteredTodos.isEmpty
          ? Center(child: Text('Нет запланированных задач'))
          : ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(todo.description),
                  trailing: IconButton(
                    icon: Icon(
                      todo.isDone
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      _toggleTodoStatus(_todos.indexOf(todo));
                    },
                  ),
                  onTap: () {
                    _navigateToAddEditTodoPage(
                        todo: todo, index: _todos.indexOf(todo));
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditTodoPage(),
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddEditTodoPage extends StatefulWidget {
  final TodoItem? todo;

  AddEditTodoPage({this.todo});

  @override
  _AddEditTodoPageState createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTodo() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Заголовок не может быть пустым'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final todo = TodoItem(
      title: title,
      description: description,
      isDone: widget.todo?.isDone ?? false,
    );
    Navigator.pop(context, todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.todo == null ? 'Добавить задачу' : 'Редактировать задачу'),
        actions: [
          if (widget.todo != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Navigator.pop(context, 'delete');
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTodo,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

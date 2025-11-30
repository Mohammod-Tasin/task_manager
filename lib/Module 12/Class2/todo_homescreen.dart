import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2012/Class2/add_new_todo_screen.dart';
import 'package:m_ten_to_inf/Module%2012/Class2/todo.dart';

class TodoHomescreen extends StatefulWidget {
  const TodoHomescreen({super.key});

  @override
  State<TodoHomescreen> createState() => _TodoHomescreenState();
}

class _TodoHomescreenState extends State<TodoHomescreen> {
  List<Todo> todoList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text("To Do List")),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          Todo todo = todoList[index];
          return ListTile(
            onLongPress: (){
              setState(() {
                todoList.removeAt(index);
              });
            },
            leading: Icon(Icons.check_box_outline_blank),
            title: Text(todo.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todo.description),
                Text("Date: ${todo.createDate}"),
              ],
            ),
            trailing: Text(todo.status),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        splashColor: Colors.black,
        onPressed: () async {
          // Todo todoo = Todo(
          //   id: 1,
          //   title: "Task 1",
          //   description: "Do it or Die",
          //   status: "Pending",
          //   createDate: DateTime.now(),
          // );
          // todoList.add(todoo);
          // setState(() {
          //
          // });

          Todo? todo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewTodoScreen()),
          );
          if (todo != null) {
            setState(() {
              todoList.add(todo);
            });
          }
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

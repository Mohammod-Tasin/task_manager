import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2012/Class2/add_new_todo_screen_2.dart';
import 'package:m_ten_to_inf/Module%2012/Class2/todo.dart';
class TodoHomescreen2 extends StatefulWidget {
  const TodoHomescreen2({super.key});

  @override
  State<TodoHomescreen2> createState() => _TodoHomescreen2State();
}

class _TodoHomescreen2State extends State<TodoHomescreen2> {
  List<Todo> lObjTodo= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("To Do List 2", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: lObjTodo.length,
                itemBuilder: (context, index){
                  Todo objTodo= lObjTodo[index];
                  return ListTile(
                    leading: Icon(Icons.check_box_outline_blank_outlined, color: Colors.white,),
                    title: Text(objTodo.title, style: TextStyle(color: Colors.white),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(objTodo.description),
                        Text("Date: ${objTodo.createDate}")
                      ],
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          splashColor: Colors.white,
          onPressed:() async {
            Todo ? todo= await Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>AddNewTodoScreen2())
            );
            if(todo!=null){
              setState(() {
                lObjTodo.add(todo);
              });
            }
          },
          child: Icon(Icons.add, color: Colors.white,),
      )
    );
  }
}

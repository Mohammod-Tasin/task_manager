import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2012/Class2/todo.dart';

class AddNewTodoScreen extends StatefulWidget {
  const AddNewTodoScreen({super.key});

  @override
  State<AddNewTodoScreen> createState() => _AddNewTodoScreenState();
}

class _AddNewTodoScreenState extends State<AddNewTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formkey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Add new Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Task Name",
                ),
                validator: (String ? value){
                  if(value?.trim().isEmpty?? true){
                    return 'Enter valid title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
                validator: (String ? value){
                  if(value?.isEmpty??true){
                    return 'Enter valid description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  if(_formkey.currentState!.validate()==false){
                    return;
                  }
                  Todo todo = Todo(
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    status: 'pending',
                    createDate: DateTime.now(),
                  );
                  Navigator.pop(context, todo);
                },
                child: Text("Add Task", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

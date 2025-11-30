import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2012/Class2/todo.dart';

class AddNewTodoScreen2 extends StatefulWidget {
  const AddNewTodoScreen2({super.key});

  @override
  State<AddNewTodoScreen2> createState() => _AddNewTodoScreen2State();
}

class _AddNewTodoScreen2State extends State<AddNewTodoScreen2> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add New Todo 2", style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Task Name",
              ),
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
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
                labelText: 'Description',
              ),
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Enter valid description';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.black),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate() == false) {
                  return;
                }
                Todo todo = Todo(
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  status: "Pending",
                  createDate: DateTime.now(),
                );
                Navigator.pop(context, todo);
              },
              child: Text("Add task", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

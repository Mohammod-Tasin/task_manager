import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Models/task_model.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Services/api_caller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/snack_bar_message.dart';
import '../../DATA/Utils/urls.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskColor,
    required this.taskStatus,
    required this.taskModel,
    required this.refreshParent,
    required this.refreshCount,
  });

  final Color taskColor;
  final String taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshParent;
  final VoidCallback refreshCount;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _changeStatusInProgress = false;
  bool _deleteInProgress = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.taskModel.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(widget.taskModel.description, style: TextStyle(fontSize: 12)),
          Text(
            'Date: ${widget.taskModel.createdDate}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Chip(
                label: Text(
                  widget.taskModel.status,
                  style: TextStyle(fontSize: 10),
                ),
                backgroundColor: widget.taskColor,
                labelStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              Spacer(),
              Visibility(
                visible: _deleteInProgress == false,
                replacement: Center(child: CircularProgressIndicator(),),
                child: IconButton(
                  onPressed: _onTapDeleteButton,
                  icon: Icon(Icons.delete_outline_outlined, color: Colors.grey),
                ),
              ),
              Visibility(
                visible: _changeStatusInProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: IconButton(
                  onPressed: _showChangeStatusDialog,
                  icon: Icon(Icons.edit_outlined),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Change Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _changeStatus('New');
                },
                title: Text("New"),
                trailing: widget.taskModel.status == 'New'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus('Pending');
                },
                title: Text("Pending"),
                trailing: widget.taskModel.status == 'Pending'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus('Cancelled');
                },
                title: Text("Cancelled"),
                trailing: widget.taskModel.status == 'Cancelled'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _changeStatus('Completed');
                },
                title: Text("Completed"),
                trailing: widget.taskModel.status == 'Completed'
                    ? Icon(Icons.done)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeStatus(String status) async {
    if (status == widget.taskModel.status) {
      return;
    }
    Navigator.pop(context);
    _changeStatusInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );
    _changeStatusInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.refreshParent();
      widget.refreshCount();
    } else {
      // ignore: use_build_context_synchronously
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.id),
    );
    _deleteInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.refreshParent();
      widget.refreshCount();
    } else {
      // ignore: use_build_context_synchronously
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  void _onTapDeleteButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete!'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog (Cancel)
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog (Confirm)
                _deleteTask(); // Call the delete API
              },
              child: const Text('Yes, Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

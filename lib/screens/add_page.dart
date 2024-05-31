import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_rest/service/to_service.dart';
import 'package:to_rest/service/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override 
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override 
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null){
      isEdit = true;
      titleController.text = todo['title'];
      descriptionController.text = todo['description'];
    }
  }
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title'
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: isEdit? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Update' : 'Submit',
              ),
            )
          )
        ],
      )
    );
  }
  Future <void> updateData() async {
    
    String id = widget.todo!['_id'];
    final isSuccess = await TodoService.updateTodo(id, body);
    if (isSuccess)
    {
      showSuccessMessage(context, message:"Update Success");
    }
    else  
    {
      showErrorMessage(context, message:'Update Failed');
    }

  }

  Future <void> submitData() async {
    
    
    // Submit data to the server
    final isSuccess = await TodoService.addTodo(body);
    // show success of fail message based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message:'Creation Success');
    }
    else  
    {
      showErrorMessage(context, message:'Creation Failed');
    }
  }

  Map get body{
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:to_rest/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:to_rest/screens/add_page.dart';
import 'package:to_rest/service/snackbar_helper.dart';
import 'package:to_rest/widget/todo_card.dart';

import '../service/to_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override 
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage>{
  bool isLoading = true;
  List items = [];

  @override
  void initState(){
    super.initState();
    fetchTodo();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const  Text('Todo List')
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'Nothing left todo',
                style: Theme.of(context).textTheme.headline3,
              )
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder:(context, index) {
                final item = items[index];
                final id = item['_id'];
                return TodoCard(
                  index: index,
                  deleteById: deleteById,
                  navigatetoEdit: navigateToEditPage,
                  item: item,
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage, 
        label: Text('Add Todo')
      )
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage()
    );

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future <void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo:item)
    );

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    // Delete the item 
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess)
    {
      // Remove item from the list
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState((){
        items = filtered; 
      });
    } 
    else 
    {
      // Show error 
      showErrorMessage(context, message:'Delete Failed');

    }
    
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if (response != null){
      setState(() {
        items = response;
      });
    }else{
      //Show error
      showErrorMessage(context, message:"Someting went wrong");
    }

    setState(() {
      isLoading = false;
    });


  } 

  


}
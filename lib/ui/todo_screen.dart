import 'package:flutter/material.dart';
import 'package:flutter_todo_list/model/todo_item.dart';
import 'package:flutter_todo_list/utils/database_client.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = new DatabaseHelper();

  final List<TodoItem> _itemList = <TodoItem>[];

  @override
  void initState() {
    super.initState();
    _readTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
            itemBuilder: (_, int index) {
              return Card(
                color: Colors.white10,
                child: new ListTile(
                  title: _itemList[index],
                  onLongPress: () => _updateItem(_itemList[index], index),
                  trailing: new Listener(
                    key: new Key(_itemList[index].itemName),
                    child: new Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                    onPointerDown: (pointerEvent) =>
                        _deleteTodo(_itemList[index].id, index),
                  ),
                ),
              );
            },
            itemCount: _itemList.length,
          )),
          new Divider(
            height: 1.0,
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    _textEditingController.clear();
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              onChanged: (value) {
                debugPrint(value);
              },
              autofocus: true,
              maxLength: 8,
              keyboardType: TextInputType.number,
              controller: _textEditingController,
              decoration: new InputDecoration(
                  prefixText: "+93 ",
                  labelText: "number",
                  hintText: "7xxxxxxxx",
                  icon: new Icon(Icons.phone)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmit(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: new Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmit(String text) async {
    TodoItem todoItem = new TodoItem(text, dateFormated());
    int saveItem = await db.saveItem(todoItem);
    TodoItem addedItem = await db.getItem(saveItem);
    setState(() {
      _itemList.insert(0, addedItem);
    });
    print("Item saved id: $saveItem");
  }

  _readTodoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        _itemList.add(TodoItem.map(item));
      });
    });
  }

  _deleteTodo(int id, int index) async {
    print("Delete Item at index $index");
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(TodoItem item, int index) {
    _textEditingController.text = item.itemName;
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Item",
              hintText: "Eg. Do not buy stuff",
              icon: new Icon(Icons.edit),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              TodoItem newTodoItem = TodoItem.fromMap({
                "itemName": _textEditingController.text,
                "itemCreated": dateFormated(),
                "id": item.id
              });
              _handleSubmitUpdate(index, item);
              await db.updateItem(newTodoItem);
              setState(() {
                _readTodoList();
              });
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: new Text("Update")),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: new Text("Cancel"))
      ],
    );
    showDialog(
      context: context,
      builder: (_) {
        return alert;
      },
    );
  }

  void _handleSubmitUpdate(int index, TodoItem item) {
    setState(() {
      _itemList
          .removeWhere((element) => _itemList[index].itemName == item.itemName);
    });
  }
}

String dateFormated() {
  var now = DateTime.now();
  var formatter = new DateFormat("EEE, MMM d, yyyy h:m:s a");
  String formatted = formatter.format(now);
  return formatted;
}

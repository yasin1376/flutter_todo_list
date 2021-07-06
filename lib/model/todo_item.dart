import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  String _itemName = "";
  String _itemCreated = "";
  int _id = 0;

  TodoItem(this._itemName, this._itemCreated);

  TodoItem.map(dynamic obj) {
    this._itemName = obj['itemName'];
    this._itemCreated = obj['itemCreated'];
    this._id = obj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['itemName'] = _itemName;
    map['itemCreated'] = _itemCreated;
    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  TodoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map['itemName'];
    this._itemCreated = map['itemCreated'];
    this._id = map['id'];
  }

  String get itemName => _itemName;

  String get itemCreated => _itemCreated;

  int get id => _id;

  set itemName(String value) {
    _itemName = value;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                _itemName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.9,
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Created at $_itemCreated",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.normal,
                    fontSize: 13.5,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

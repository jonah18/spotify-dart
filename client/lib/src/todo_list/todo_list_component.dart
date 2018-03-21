import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:http/browser_client.dart' as http;

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'todo_list_service.dart';

@Component(
  selector: 'todo-list',
  styleUrls: const ['todo_list_component.css'],
  templateUrl: 'todo_list_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [TodoListService],
)
class TodoListComponent implements OnInit {
  final TodoListService todoListService;

  List<String> items = [];
  String artistName = '';

  String baseUrl = "http://localhost:8000/api/spotify_dart/v1/";
  var client = new http.BrowserClient();

  TodoListComponent(this.todoListService);

  @override
  Future<Null> ngOnInit() async {
    items = await todoListService.getTodoList();

    authenticate();
  }

  // print the raw json response text from the server
  void onDataLoaded(String responseText) {
    var jsonString = responseText;
    print(jsonString);
  }

  // Authenticate to Spotify API and receive token
  authenticate() {
    var url = baseUrl + "authenticate";

    client.get(url)
      .then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      });
  }

  void search() {
    items.add(artistName);
    String url = Uri.encodeFull(baseUrl + "artist/search/" + artistName);

    client.get(url)
      .then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      });

    artistName = '';
  }

  String remove(int index) => items.removeAt(index);
  void onReorder(ReorderEvent e) =>
      items.insert(e.destIndex, items.removeAt(e.sourceIndex));
}

import 'package:flutter/material.dart';
import 'db_mirza.dart';
import './model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

final dbMirza = DatabaseMirza();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
/*
autor: Mirza Mojahid
github: https://github.com/mirzamojahid
linkedin: https://bd.linkedin.com/in/mirzamojahid
Startup(TourX): https://tourx.com.bd
*/
  await dbMirza.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo by Mirza Mojahid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Mirza> _items = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);

    setState(() {
      _items = List<Mirza>.from(data.map((e) {
        return Mirza.fromJson(e as Map<String, dynamic>);
      }));
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  var readData = false;

  changeFunc() {
    setState(() {
      readData = !readData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SqfLite CRUD from Json by Mirza Mojahid'),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: changeFunc,
              child: readData
                  ? Text('Hide List of Data')
                  : Text('Show Json from Data'),
            ),
            _items.isNotEmpty && readData
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: ValueKey(_items[index].id),
                          margin: const EdgeInsets.all(10),
                          color: Colors.amber.shade100,
                          child: ListTile(
                            leading: Text(_items[index].id.toString()),
                            title: Text(_items[index].title),
                            subtitle: Text(_items[index].completed.toString()),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            ElevatedButton(
              onPressed: _insert,
              child: const Text('Insert Data'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('Fetch All Data from DB'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('Update Data'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('Delete last number index'),
            ),
          ],
        ),
      ),
    );
  }

  void _insert() async {
    try {
      for (int i = 0; i < _items.length; i++) {
        Map<String, dynamic> row = {
          DatabaseMirza.columnId: _items[i].id,
          DatabaseMirza.columnUserId: _items[i].userId,
          DatabaseMirza.columnTitle: _items[i].title,
          DatabaseMirza.columnCompleted: _items[i].completed,
        };
        final id = await dbMirza.insert(row);
        debugPrint('inserted row id: $id');
      }
    } catch (e) {
      print(e);
    }
  }

  void _query() async {
    final allRows = await dbMirza.queryAllRows();
    debugPrint('query all rows:');

/*
    for (final row in allRows) {
      debugPrint(row.toString());
    }
*/

    setState(() {
      _items = List<Mirza>.from(allRows.map((e) {
        return Mirza(
            userId: e['userId'],
            id: e['id'],
            title: e['title'],
            completed: e['completed'] == 1 ? true : false);
      }));

      readData = true;
    });

    print(allRows);
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseMirza.columnId: 1,
      DatabaseMirza.columnTitle: "Mirza Mojahid",
      DatabaseMirza.columnUserId: 23,
      DatabaseMirza.columnCompleted: true
    };
    final rowsAffected = await dbMirza.update(row);

    debugPrint('updated $rowsAffected row(s)');


      Map<String, dynamic> row1 = {
      DatabaseMirza.columnId: 2,
      DatabaseMirza.columnTitle: "TourX is Bangladesh based Travel Startup",
      DatabaseMirza.columnUserId: 1,
      DatabaseMirza.columnCompleted: true
    };
    final rowsAffected1 = await dbMirza.update(row);
    
    debugPrint('updated $rowsAffected1 row(s)');
  }

  void _delete() async {
    final id = await dbMirza.queryRowCount();
    final rowsDeleted = await dbMirza.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
}

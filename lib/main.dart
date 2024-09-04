import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

const String CACHE_BOX = 'CACHE_BOX';
const String CACHE_KEY = 'CACHE_KEY';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final applicationDocumentsDirectory = await path.getApplicationDocumentsDirectory();

  Hive.init(applicationDocumentsDirectory.path);

  final box = await Hive.openBox(CACHE_BOX);
  await box.delete(CACHE_KEY);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
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
  Future<void> _add() async {
    final box = await Hive.openBox(CACHE_BOX);

    final storedData = box.get(CACHE_KEY) ?? [];

    storedData.add(DateTime.now().toString());

    await box.put(CACHE_KEY, storedData);
  }

  Future<void> _getData() async {
    final box = await Hive.openBox(CACHE_BOX);

    data = ((box.get(CACHE_KEY) ?? []) as List).map((e) => e.toString()).toList();
  }

  List<String> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Append Test'),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return Text(data[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _add();

          await _getData();

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
